//
//  ChatRoomTextCell.h
//  IMDemo
//
//  Created by Civet on 2020/4/16.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "SuperChatRoomCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatRoomTextCell : SuperChatRoomCell

@property (nonatomic,strong) UILabel *messageContent;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)configData;

@end

NS_ASSUME_NONNULL_END
