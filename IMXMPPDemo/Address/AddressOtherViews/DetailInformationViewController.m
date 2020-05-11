//
//  DetailInformationViewController.m
//  IMDemo
//
//  Created by Civet on 2020/4/27.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "DetailInformationViewController.h"

@interface DetailInformationViewController ()

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UILabel *userNameLabel;
@property (nonatomic,strong) UILabel *userNameText;
@property (nonatomic,strong) UILabel *homePhoneLabel;
@property (nonatomic,strong) UILabel *homePhoneText;
@property (nonatomic,strong) UILabel *workPhoneLabel;
@property (nonatomic,strong) UILabel *workPhoneText;
@property (nonatomic,strong) UILabel *iPhonePhoneLabel;
@property (nonatomic,strong) UILabel *iPhonePhoneText;
@property (nonatomic,strong) UILabel *mobilePhoneLabel;
@property (nonatomic,strong) UILabel *mobilePhoneText;
@property (nonatomic,strong) UILabel *mainPhoneLabel;
@property (nonatomic,strong) UILabel *mainPhoneText;
//@property (nonatomic,strong) UILabel *remarkLabel;
//@property (nonatomic,strong) UILabel *remarkText;

@property (nonatomic,assign) CGFloat orignX;
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) CGFloat len;

@end

@implementation DetailInformationViewController
@synthesize tableView;
@synthesize orignX;
@synthesize width;
@synthesize height;
@synthesize len;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    orignX = 30;
    width = 70;
    height = 30;
    len = 10;
//    [self initUI];
//    [self initData];

}
//
//- (void)initUI{
//    self.view.backgroundColor = [UIColor whiteColor];
//    self.userNameLabel = [[UILabel alloc] init];
//    self.userNameText = [[UILabel alloc] init];
//    self.homePhoneLabel = [[UILabel alloc] init];
//    self.homePhoneText = [[UILabel alloc] init];
//    self.workPhoneLabel = [[UILabel alloc] init];
//    self.workPhoneText = [[UILabel alloc] init];
//    self.iPhonePhoneLabel = [[UILabel alloc] init];
//    self.iPhonePhoneText = [[UILabel alloc] init];
//    self.mobilePhoneLabel = [[UILabel alloc] init];
//    self.mobilePhoneText = [[UILabel alloc] init];
//    self.mainPhoneLabel = [[UILabel alloc] init];
//    self.mainPhoneText = [[UILabel alloc] init];
////    self.remarkLabel = [[UILabel alloc] init];
////    self.remarkText = [[UILabel alloc] init];
//    
//    [self.view addSubview:self.userNameLabel];
//    [self.view addSubview:self.userNameText];
//    [self.view addSubview:self.homePhoneLabel];
//    [self.view addSubview:self.homePhoneText];
//    [self.view addSubview:self.workPhoneLabel];
//    [self.view addSubview:self.workPhoneText];
//    [self.view addSubview:self.iPhonePhoneLabel];
//    [self.view addSubview:self.iPhonePhoneText];
//    [self.view addSubview:self.mobilePhoneLabel];
//    [self.view addSubview:self.mobilePhoneText];
//    [self.view addSubview:self.mainPhoneLabel];
//    [self.view addSubview:self.mainPhoneText];
////    [self.view addSubview:self.remarkLabel];
////    [self.view addSubview:self.remarkText];
//    
//    CGFloat h = SCREEN_HEIGHT;
//    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.view.mas_top).mas_offset(SCREEN_HEIGHT/7);
//        make.left.mas_equalTo(self.view.mas_left).mas_offset(orignX);
//        make.width.mas_equalTo(width);
//        make.height.mas_equalTo(height);
//    }];
//    [self.userNameText mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.userNameLabel.mas_top);
//        make.left.mas_equalTo(self.userNameLabel.mas_right).mas_offset(len);
//        make.width.mas_equalTo(width*2);
//        make.height.mas_equalTo(height);
//    }];
//    
//    [self.homePhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.userNameLabel.mas_bottom).mas_offset(len);
//        make.left.mas_equalTo(self.view.mas_left).mas_offset(orignX);
//        make.width.mas_equalTo(width);
//        make.height.mas_equalTo(height);
//    }];
//    [self.homePhoneText mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.homePhoneLabel.mas_top);
//        make.left.mas_equalTo(self.homePhoneLabel.mas_right).mas_offset(len);
//        make.width.mas_equalTo(width*2);
//        make.height.mas_equalTo(height);
//    }];
//    
//    [self.workPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.homePhoneLabel.mas_bottom).mas_offset(len);
//        make.left.mas_equalTo(self.view.mas_left).mas_offset(orignX);
//        make.width.mas_equalTo(width);
//        make.height.mas_equalTo(height);
//    }];
//    [self.workPhoneText mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.workPhoneLabel.mas_top);
//        make.left.mas_equalTo(self.homePhoneLabel.mas_right).mas_offset(len);
//        make.width.mas_equalTo(width*2);
//        make.height.mas_equalTo(height);
//    }];
//    
//    [self.iPhonePhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.workPhoneLabel.mas_bottom).mas_offset(len);
//        make.left.mas_equalTo(self.view.mas_left).mas_offset(orignX);
//        make.width.mas_equalTo(width);
//        make.height.mas_equalTo(height);
//    }];
//    [self.iPhonePhoneText mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.iPhonePhoneLabel.mas_top);
//        make.left.mas_equalTo(self.homePhoneLabel.mas_right).mas_offset(len);
//        make.width.mas_equalTo(width*2);
//        make.height.mas_equalTo(height);
//    }];
//    
//    [self.mobilePhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.iPhonePhoneText.mas_bottom).mas_offset(len);
//        make.left.mas_equalTo(self.view.mas_left).mas_offset(orignX);
//        make.width.mas_equalTo(width);
//        make.height.mas_equalTo(height);
//    }];
//    [self.mobilePhoneText mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.mobilePhoneLabel.mas_top);
//        make.left.mas_equalTo(self.homePhoneLabel.mas_right).mas_offset(len);
//        make.width.mas_equalTo(width*2);
//        make.height.mas_equalTo(height);
//    }];
//    
//    [self.mainPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.mobilePhoneText.mas_bottom).mas_offset(len);
//        make.left.mas_equalTo(self.view.mas_left).mas_offset(orignX);
//        make.width.mas_equalTo(width);
//        make.height.mas_equalTo(height);
//    }];
//    [self.mainPhoneText mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.mainPhoneLabel.mas_top);
//        make.left.mas_equalTo(self.homePhoneLabel.mas_right).mas_offset(len);
//        make.width.mas_equalTo(width*2);
//        make.height.mas_equalTo(height);
//    }];
//    
////    [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.top.mas_equalTo(self.mainPhoneText.mas_bottom).mas_offset(len);
////        make.left.mas_equalTo(self.view.mas_left).mas_offset(orignX);
////        make.width.mas_equalTo(width);
////        make.height.mas_equalTo(height);
////    }];
////    [self.remarkText mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.top.mas_equalTo(self.remarkLabel.mas_bottom).mas_offset(len);
////        make.left.mas_equalTo(self.view.mas_left).mas_offset(orignX);
////        make.width.mas_equalTo(width*3);
////        make.height.mas_equalTo(height*3);
////    }];
//
//}
//
//- (void)initData{
//    
//    [self.userNameLabel setText:@"用户名:"];
//    [self.userNameText setText:self.detailInfoModel.userName];
//    
//    [self.homePhoneLabel setText:@"住宅:"];
//    [self.homePhoneText setText:self.detailInfoModel.homePhone];
//    
//    [self.workPhoneLabel setText:@"工作:"];
//    [self.workPhoneText setText:self.detailInfoModel.workPhone];
//    
//    [self.iPhonePhoneLabel setText:@"iPhone:"];
//    [self.iPhonePhoneText setText:self.detailInfoModel.iPhonePhone];
//    
//    [self.mobilePhoneLabel setText:@"手机:"];
//    [self.mobilePhoneText setText:self.detailInfoModel.mobilePhone];
//    
//    [self.mainPhoneLabel setText:@"主要:"];
//    [self.mainPhoneText setText:self.detailInfoModel.mainPhone];
//    
////    [self.remarkLabel setText:@"备注:"];
////    self.remarkText.textAlignment = NSTextAlignmentLeft;
////    [self.remarkText setText:self.detailInfoModel.remark];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
