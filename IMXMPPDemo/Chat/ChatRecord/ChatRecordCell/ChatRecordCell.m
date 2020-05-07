//
//  ChatRecordCell.m
//  IMDemo
//
//  Created by Civet on 2020/4/24.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "ChatRecordCell.h"

@interface ChatRecordCell()

@property (nonatomic,strong) UILabel *userNameLabel;
@property (nonatomic,strong) UILabel *latestMessageLabel;
@property (nonatomic,strong) UILabel *currentDateLabel;

@end

@implementation ChatRecordCell
@synthesize userNameLabel;
@synthesize latestMessageLabel;
@synthesize currentDateLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    userNameLabel = [[UILabel alloc] init];
    userNameLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:userNameLabel];
    [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left).mas_offset(10);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(self.mas_right).mas_offset(-150);
    }];
    
    latestMessageLabel = [[UILabel alloc] init];
    latestMessageLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:latestMessageLabel];
    [latestMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.mas_equalTo(userNameLabel.mas_top);
        make.left.mas_equalTo(self.mas_left).mas_offset(10);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(self.mas_right).mas_offset(-150);
    }];
    
    currentDateLabel = [[UILabel alloc] init];
    currentDateLabel.backgroundColor = [UIColor whiteColor];
    currentDateLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:currentDateLabel];
    [currentDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(latestMessageLabel.mas_right).mas_offset(10);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(15);
        make.right.mas_equalTo(self.mas_right);
    }];
}

- (void)configData{
    ChatRecordModel *model = self.chatRecordModel;
//    userNameLabel.text = model.userName;
//    latestMessageLabel.text = model.content;
//    currentDateLabel.text = model.currentDate;
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
