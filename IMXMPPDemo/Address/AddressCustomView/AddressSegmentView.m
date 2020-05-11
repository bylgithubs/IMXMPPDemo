//
//  AddressSegmentView.m
//  IMDemo
//
//  Created by Civet on 2020/4/14.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "AddressSegmentView.h"

@interface AddressSegmentView ()

@property (nonatomic,strong) UIButton *contactBtn;
@property (nonatomic,strong) UIButton *otherBtn;

@end

@implementation AddressSegmentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init{
    if (self = [super init]) {
        [self addSegmentView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSegmentView];
    }
    return self;
}
- (void)addSegmentView{
    _contactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _contactBtn.frame = CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height);
    _contactBtn.backgroundColor = [UIColor greenColor];
    [_contactBtn setTitle:@"联系人" forState:UIControlStateNormal];
    [self addSubview:_contactBtn];
    
    _otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _otherBtn.frame = CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, self.frame.size.height);
    _otherBtn.backgroundColor = [UIColor grayColor];
    [_otherBtn setTitle:@"其他" forState:UIControlStateNormal];
    [self addSubview:_otherBtn];
    
    [self.contactBtn addTarget:self action:@selector(clickContactBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.otherBtn addTarget:self action:@selector(clickOtherBtn) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)clickContactBtn{
    self.contactBtn.backgroundColor = [UIColor greenColor];
    self.otherBtn.backgroundColor = [UIColor grayColor];
    [self selectSegmentAction:SegmentOne];
    
}

- (void)clickOtherBtn{
    self.contactBtn.backgroundColor = [UIColor grayColor];
    self.otherBtn.backgroundColor = [UIColor greenColor];
    [self selectSegmentAction:SegmentTwo];
}

- (void)selectSegmentAction:(ClickIndex)index{
    if ([self.delegate respondsToSelector:@selector(selectSegmentAction:)]) {
        [self.delegate selectSegmentAction:index];
    }
}
@end
