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
#import "ChatRoomAudioCell.h"
#import "ChatRoomPictureCell.h"
#import "ChatRoomVideoCell.h"
#import "FMDBOperation.h"
#import "ChatRoomMenuView.h"
#import "XmppManager.h"
#import "AddressViewController.h"
#import "ChatRecordViewController.h"
#import "AudioRecorder.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import "ImageScrollViewController.h"
#import "ShareLocationViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatRoomViewController : UIViewController

@property (nonatomic,strong) RosterListModel *rosterListModel;

@property (nonatomic, strong) NSMutableArray *selectOriginImageArr;

@end

NS_ASSUME_NONNULL_END
