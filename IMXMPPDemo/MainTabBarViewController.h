//
//  MainTabBarViewController.h
//  IMXMPPDemo
//
//  Created by Civet on 2020/5/5.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressViewController.h"
#import "ChatRecordViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainTabBarViewController : UITabBarController

@property (nonatomic,strong) NSMutableArray *rostersArr;
- (void)initData:(NSMutableArray *)dataArr;

@end

NS_ASSUME_NONNULL_END
