//
//  ChatRoomAudioCell.m
//  IMXMPPDemo
//
//  Created by Civet on 2020/6/3.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "ChatRoomAudioCell.h"

@implementation ChatRoomAudioCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.audioPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.audioPlayBtn setTitle:@"语音" forState:UIControlStateNormal];
    self.audioPlayBtn.backgroundColor = [UIColor orangeColor];
    [self.audioPlayBtn addTarget:self action:@selector(audioRecordPlay) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.audioPlayBtn];
}

- (void)configData{
    [super configData];
    ChatRoomModel *model = self.chatRoomModel;
    if (![CURRENTUSER isEqualToString:model.messageFrom]) {
        [self.audioPlayBtn setFrame:CGRectMake(20, 20, 60, 40)];
    } else {
        [self.audioPlayBtn setFrame:CGRectMake(SCREEN_WIDTH - 40 - 60, 30, 60, 40)];
    }
    self.cellHeight = self.audioPlayBtn.frame.size.height + 40;
}

- (void)audioRecordPlay{
    ChatRoomModel *model = self.chatRoomModel;
    NSString *audioPath = [CHAT_MESSAGE_PATH stringByAppendingPathComponent:model.content];
    AudioRecorder *audioRecorder = [AudioRecorder sharedInstance];
    [audioRecorder audioRecorderPlay:audioPath];
}

@end
