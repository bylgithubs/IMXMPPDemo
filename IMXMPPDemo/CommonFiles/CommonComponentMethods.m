//
//  CommonComponentMethods.m
//  IMDemo
//
//  Created by Civet on 2020/4/16.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "CommonComponentMethods.h"

@implementation CommonComponentMethods

+ (UIView *)setLeftBarItems:(UIViewController *)viewControll{
    UIView *leftContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    leftContentView.backgroundColor = [UIColor blueColor];
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    imageView.image = [UIImage imageNamed:@"left_back.png"];
//    [leftContentView addSubview:imageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = leftContentView.frame;
    [button setImage:[UIImage imageNamed:@"left_back.png"] forState:UIControlStateNormal];
    [button addTarget:viewControll action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [leftContentView addSubview:button];
    return leftContentView;
}

- (void)clickBackBtn{
    
}

@end
