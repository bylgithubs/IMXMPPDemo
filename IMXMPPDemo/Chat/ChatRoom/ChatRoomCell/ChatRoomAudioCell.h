//
//  ChatRoomAudioCell.h
//  IMXMPPDemo
//
//  Created by Civet on 2020/6/3.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "SuperChatRoomCell.h"
#import "AudioRecorder.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatRoomAudioCell : SuperChatRoomCell

@property (nonatomic,strong) UIButton *audioPlayBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)configData;

@end

NS_ASSUME_NONNULL_END
