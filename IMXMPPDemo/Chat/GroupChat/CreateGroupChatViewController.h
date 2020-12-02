//
//  CreateGroupChatViewController.h
//  IMXMPPDemo
//
//  Created by Civet on 2020/5/14.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateGroupChatCell.h"
#import "FMDBOperation.h"
#import "ChatRoomViewController.h"
#import "RosterListModel.h"
#import "GroupChatModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CreateGroupChatViewController : UIViewController

@property(nonatomic,strong) GroupChatModel *groupChatModel;

@end

NS_ASSUME_NONNULL_END
