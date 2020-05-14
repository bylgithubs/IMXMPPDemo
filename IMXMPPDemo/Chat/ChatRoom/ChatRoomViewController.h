//
//  ChatRoomViewController.h
//  IMDemo
//
//  Created by Civet on 2020/4/15.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressDataModel.h"
#import "ChatRoomTextCell.h"
#import "CommonComponentMethods.h"
#import "CommonMethods.h"
#import "FMDBOperation.h"
#import "ChatRoomMenuView.h"
#import "XmppManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatRoomViewController : UIViewController

@property (nonatomic,strong) RosterListModel *rosterListModel;

@end

NS_ASSUME_NONNULL_END
