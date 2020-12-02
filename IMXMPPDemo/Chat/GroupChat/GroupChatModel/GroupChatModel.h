//
//  GroupChatModel.h
//  IMXMPPDemo
//
//  Created by Civet on 2020/12/2.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GroupChatModel : NSObject

@property(nonatomic,strong) NSString *title;
@property(nonatomic,assign) enum MessageType type;
@property(nonatomic,strong) NSString *bottonButtonTitle;
@property(nonatomic,strong) NSMutableArray *hasExistFriendsArr;

@end

NS_ASSUME_NONNULL_END
