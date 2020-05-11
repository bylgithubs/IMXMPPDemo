//
//  AddressSideView.m
//  IMDemo
//
//  Created by Civet on 2020/4/14.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "AddressSideView.h"

@interface AddressSideView()

@property (nonatomic,strong) UIButton *startChatBtn;
@property (nonatomic,strong) UIButton *detailInformation;

@end

@implementation AddressSideView

@synthesize startChatBtn;
@synthesize detailInformation;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init{
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    //self.backgroundColor = [UIColor lightGrayColor];
    startChatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [startChatBtn setTitle:@"开始聊天" forState:UIControlStateNormal];
    startChatBtn.backgroundColor = [UIColor lightGrayColor];
    startChatBtn.tag = 1;
    [startChatBtn addTarget:self action:@selector(sideViewClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:startChatBtn];
    [startChatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.width.mas_equalTo(self.frame.size.width/2);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    
    detailInformation = [UIButton buttonWithType:UIButtonTypeCustom];
    [detailInformation setTitle:@"详细信息" forState:UIControlStateNormal];
    detailInformation.backgroundColor = [UIColor lightGrayColor];
    detailInformation.tag = 2;
    [detailInformation addTarget:self action:@selector(sideViewClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:detailInformation];
    [detailInformation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(startChatBtn.mas_right);
        make.width.mas_equalTo(self.frame.size.width/2);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}

- (void)sideViewClickBtn:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSLog(@"tag===========%ld",(long)btn.tag);
    if ([self.delegate respondsToSelector:@selector(sideViewClick:)]) {
        [self.delegate sideViewClick:btn.tag];
    }
    
}


@end
