//
//  SearchFriends.m
//  IMXMPPDemo
//
//  Created by Civet on 2020/5/7.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "SearchFriends.h"

@implementation SearchFriends

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    //self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    self.backgroundColor = [UIColor purpleColor];
//    [self mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(super.);
//    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
