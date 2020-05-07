//
//  SearchFriends.m
//  IMXMPPDemo
//
//  Created by Civet on 2020/5/7.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "SearchFriends.h"
@interface SearchFriends()

@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UIButton *searchBtn;

@end

@implementation SearchFriends

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.backgroundColor = [UIColor purpleColor];
    self.textField = [[UITextField alloc] init];
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self addSubview:self.textField];
    
    self.searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.searchBtn.backgroundColor = [UIColor whiteColor];
    [self.searchBtn setTitle:@"添加" forState:UIControlStateNormal];
    [self.searchBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.searchBtn addTarget:self action:@selector(searchClickAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.searchBtn];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).mas_offset(5);
        make.left.mas_equalTo(self.mas_left).mas_offset(10);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-5);
        make.right.mas_equalTo(self.mas_right).mas_offset(-SCREEN_WIDTH*0.2);
    }];
    
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textField.mas_top);
        make.left.mas_equalTo(self.textField.mas_right).mas_offset(10);
        make.bottom.mas_equalTo(self.textField.mas_bottom);
        make.right.mas_equalTo(self.mas_right).mas_offset(-10);
    }];
}

//- (void)searchClickAction{
//    NSString *searchText = self.textField.text;
//    if ([self.delegate respondsToSelector:@selector(searchFriendWithName:)]) {
//        [self.delegate searchFriendWithName:searchText];
//    }
//}
- (void)searchClickAction{
    NSString *searchText = self.textField.text;
    [[NSNotificationCenter defaultCenter] postNotificationName:XMPPMANAGER_ADD_FRIEND object:searchText];
    self.textField.text = @"";
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
