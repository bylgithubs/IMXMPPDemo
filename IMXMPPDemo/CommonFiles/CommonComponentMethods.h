//
//  CommonComponentMethods.h
//  IMDemo
//
//  Created by Civet on 2020/4/16.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"
#import <Masonry.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonComponentMethods : UIView
//左上角返回按钮
+ (UIView *)setLeftBarItems:(UIViewController *)viewControll;
//底部按钮
+ (void)setBottonButton:(UIViewController *)VC titleWithButton:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
