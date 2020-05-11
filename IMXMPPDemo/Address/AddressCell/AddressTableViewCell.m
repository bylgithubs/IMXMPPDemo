//
//  AddressTableViewCell.m
//  IMDemo
//
//  Created by Civet on 2020/4/14.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//
#import "AddressTableViewCell.h"

@implementation AddressTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setCellContent{
    [super setCellContent];
    [self initUI];
}

- (void)initUI{
    NSLog(@"subview============%@",self.subviews);
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[AddressSideView class]] || [subview isKindOfClass:[UILabel class]]) {
            [subview removeFromSuperview];
        }
    }
    self.nameLabel = [[UILabel alloc] init];
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left).mas_offset(30);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(45);
    }];
}

- (void)addAddressSideView{
    self.sideView = [[AddressSideView alloc] initWithFrame:CGRectMake(0, 45, self.frame.size.width, 55)];
    [self addSubview:self.sideView];
    //不能用masonry，masonry使用block布局会导致子视图无法显示
//    [self.sideView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.nameLabel.mas_bottom);
//        make.left.mas_equalTo(self.mas_left);
//        make.right.mas_equalTo(self.mas_right);
//        make.height.mas_equalTo(55);
//    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
