//
//  ChatRoomDelegate.h
//  IMDemo
//
//  Created by Civet on 2020/4/22.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

//#ifndef ChatRoomDelegate_h
//#define ChatRoomDelegate_h
//#endif /* ChatRoomDelegate_h */



@class SuperChatRoomCell;
@protocol ChatRoomCellDelegate <NSObject>

- (void)chatRoomTableViewCellLongPress:(SuperChatRoomCell *)chatRoomCell type:(enum MessageType)type content:(NSString *)content;

@end
