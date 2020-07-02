//
//  ImageScrollViewController.h
//  IMXMPPDemo
//
//  Created by Civet on 2020/6/23.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatRoomModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImageScrollViewController : UIViewController

@property (nonatomic,assign) ChatRoomModel *mediaModel;
@property (nonatomic,strong) UIImage *image;

//设置视图内容
//- (void)setScrollViewContent:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
