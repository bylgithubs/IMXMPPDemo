//
//  ChatRecordViewController.h
//  IMDemo
//
//  Created by Civet on 2020/4/10.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatRecordCell.h"
#import "FMDBOperation.h"
#import "ChatRoomViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatRecordViewController : UIViewController

@property (nonatomic,strong) NSMutableArray *dataArr;

@end

NS_ASSUME_NONNULL_END
