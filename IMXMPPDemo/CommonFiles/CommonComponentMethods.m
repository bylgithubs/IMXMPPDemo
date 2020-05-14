//
//  CommonComponentMethods.m
//  IMDemo
//
//  Created by Civet on 2020/4/16.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "CommonComponentMethods.h"

@implementation CommonComponentMethods
//左上角返回按钮
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
//底部按钮
+ (void)setBottonButton:(UIViewController *)VC titleWithButton:(NSString *)title{
    UIButton *bottonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottonBtn.backgroundColor = [UIColor lightGrayColor];
    [bottonBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [bottonBtn setTitle:title forState:UIControlStateNormal];
    [bottonBtn addTarget:VC action:@selector(clickBottonBtn) forControlEvents:UIControlEventTouchUpInside];
    [VC.view addSubview:bottonBtn];
    [bottonBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(VC.view.mas_left);
        make.bottom.mas_equalTo(VC.view.mas_bottom);
        make.right.mas_equalTo(VC.view.mas_right);
        make.height.mas_equalTo(40);
    }];
    
}

- (void)clickBackBtn{
    
}

- (void)clickBottonBtn{
    
}

@end
