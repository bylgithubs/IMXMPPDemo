//
//  AudioRecorder.m
//  IMXMPPDemo
//
//  Created by Civet on 2020/6/3.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "AudioRecorder.h"

@interface AudioRecorder()<AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioSession *session;
@property (nonatomic,strong) AVAudioRecorder *audioRecorder;//音频录制
@property (nonatomic, strong) AVAudioPlayer *player; //播放器

@end

@implementation AudioRecorder

static AudioRecorder *sharedInstance = nil;
+(AudioRecorder *)sharedInstance{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)initData{
    
}

-(AVAudioSession *)session{
    if(!_session){
        //AVAudioSession是一个单例 实例化
        _session =[AVAudioSession sharedInstance];
        
        NSError *sessionError;
        
        
        if (_session == nil) {
            
            NSLog(@"Error creating session: %@",[sessionError description]);
            
        }else{
            //激活session
            [_session setActive:YES error:nil];
            
        }
    }
    return _session;
}

/**
 录音开始
 */
-(void)audioRecorderBegin:(NSString *)audioPath{
    /**
     设置session属性
     AVAudioSessionCategoryAmbient：  当用户锁屏或者静音的时候静音，支持混音，只支持播放
     AVAudioSessionCategorySoloAmbient：  当用户锁屏或者静音的时候静音，不支持混音，只支持播放
     AVAudioSessionCategoryPlayback： 当用户锁屏或者静音的时候不静音，不支持混音，只支持播放
     AVAudioSessionCategoryRecord ：当用户锁屏或者静音的时候不静音，不支持混音，只支持录音
     AVAudioSessionCategoryPlayAndRecord：当用户锁屏或者静音的时候不静音，支持混音，可以录音和播放
     AVAudioSessionCategoryAudioProcessing：都不支持
     AVAudioSessionCategoryMultiRoute：当用户锁屏或者静音的时候不静音，不支持混音，可以录音和播放
     */
    [self.session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    NSURL *audioUrl=[NSURL fileURLWithPath:audioPath];
    //开始
    self.audioRecorder = [[AVAudioRecorder alloc]initWithURL:audioUrl settings:[self getAudioSetting] error:nil];
    self.audioRecorder.delegate = self;
    //        self.audioRecorder.meteringEnabled = YES;//开启音频测量
    [self.audioRecorder prepareToRecord];//
    [self.audioRecorder record];
    
    //
    [self.audioRecorder updateMeters];
    [self.audioRecorder averagePowerForChannel:0];//指定频道分贝值
    [self.audioRecorder peakPowerForChannel:0];//平均分贝值
    NSLog(@"-------------------------------录音已经开始了  %@",self.audioRecorder);
}

/**
 音频停止录制
 */
-(void)audioRecorderStop{
    //是否还在录
    [self.audioRecorder stop];
}

/**
 音频播放
 */
-(void)audioRecorderPlay:(NSString *)audioPath{
    [self.audioRecorder stop];
    NSURL *audioUrl = [NSURL fileURLWithPath:audioPath];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:audioUrl error:nil];
    //    NSLog(@"%li",self.player.data.length/1024);
    [self.session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    if([self.player prepareToPlay] == YES && [self.player play] == YES){
        NSLog(@"-------------------:播放");
    }else{
        NSLog(@"-------------------:停止");
    }
}

/*
 音频的存储url
 */
-(NSURL *)getSavePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = CHAT_MESSAGE_PATH;
    BOOL isExisted = [fileManager fileExistsAtPath:CHAT_MESSAGE_PATH];
    if (!isExisted) {
        [fileManager createDirectoryAtPath:CHAT_MESSAGE_PATH withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //NSString *audioPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *audioPath = [CHAT_MESSAGE_PATH stringByAppendingPathComponent:@"myRecord.aac"];
    NSLog(@"file path:%@",audioPath);
    NSURL *url=[NSURL fileURLWithPath:audioPath];
    return url;
}

/*
 @return 录音设置
 */
-(NSDictionary *)getAudioSetting{
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    //设置录音格式
    [dicM setObject:@(kAudioFormatMPEG4AAC) forKey:AVFormatIDKey];
    //设置录音采样率，8000是电话采样率，对于一般录音已经够了
    [dicM setObject:@(8000) forKey:AVSampleRateKey];
    //设置通道,这里采用单声道
    [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];
    //每个采样点位数,分为8、16、24、32
    [dicM setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    //录音质量
    [dicM setObject:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    //....其他设置等
    return dicM;
}

/*监听系统中断音频播放
 来电暂停
 QQ 微信语音暂停
 其他音乐软件占用
 */
- (void)audioInterruption:(NSNotification *)noti {
    
    NSDictionary *info = noti.userInfo;
    AVAudioSessionInterruptionType type = [info[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    
    if (type == AVAudioSessionInterruptionTypeBegan) {
        //表示中断开始，我们应该暂停播放和采集，取值为AVAudioSessionInterruptionTypeEnded表示中断结束，我们可以继续播放和采集。
    } else {
        //当前只有一种值AVAudioSessionInterruptionOptionShouldResume表示此时也应该恢复继续播放和采集。
        AVAudioSessionInterruptionOptions options = [info[AVAudioSessionInterruptionOptionKey] unsignedIntegerValue];
        if (options == AVAudioSessionInterruptionOptionShouldResume) {
            
        }
    }
}

#pragma mark AVAudioRecorderDelegate

/* audioRecorderDidFinishRecording:successfully: is called when a recording has been finished or stopped. This method is NOT called if the recorder is stopped due to an interruption. */
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    //录音完成
    NSLog(@"--------------:录音完成");
    
    //    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[self getSavePath] error:nil];
    //    if ([audioPlayer prepareToPlay] == YES &&
    //        [audioPlayer play] == YES) {
    //        NSLog(@"--------------------------------:开始播放");
    //    }else{
    //         NSLog(@"--------------------------------:失败");
    //    }
    
    
}

/* if an error occurs while encoding it will be reported to the delegate. */
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error{
    NSLog(@"--------------:录音编码发生错误");
}

@end
