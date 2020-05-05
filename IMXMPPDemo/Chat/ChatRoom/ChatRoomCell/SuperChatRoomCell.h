//
//  SuperChatRoomCell.h
//  IMDemo
//
//  Created by Civet on 2020/4/16.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatRoomDelegate.h"
#import "ChatRoomModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SuperChatRoomCell : UITableViewCell

@property (nonatomic,weak) id<ChatRoomCellDelegate> delegate;
@property (nonatomic,strong) ChatRoomModel *chatRoomModel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END
