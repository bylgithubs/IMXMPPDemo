//
//  AudioRecorder.h
//  IMXMPPDemo
//
//  Created by Civet on 2020/6/3.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioRecorder : NSObject
//创建对象，单例
+(AudioRecorder *)sharedInstance;
//开始录音
-(void)audioRecorderBegin:(NSString *)audioPath;
//停止录音
-(void)audioRecorderStop;
//播放录音
-(void)audioRecorderPlay:(NSString *)audioPath;

@end

NS_ASSUME_NONNULL_END
