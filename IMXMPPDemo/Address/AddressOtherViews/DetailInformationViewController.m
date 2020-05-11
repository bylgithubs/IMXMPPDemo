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
@property (nonatomic,strong) UIButton *deleteBtn;

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
    [self initUI];
    [self initData];

}

- (void)initUI{
    
    self.tabBarController.tabBar.hidden = YES;
    UIView *backBtnView = [CommonComponentMethods setLeftBarItems:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtnView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.userNameLabel = [[UILabel alloc] init];
    self.userNameText = [[UILabel alloc] init];

    [self.view addSubview:self.userNameLabel];
    [self.view addSubview:self.userNameText];
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).mas_offset(SCREEN_HEIGHT/7);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(orignX);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    [self.userNameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userNameLabel.mas_top);
        make.left.mas_equalTo(self.userNameLabel.mas_right).mas_offset(len);
        make.width.mas_equalTo(width*2);
        make.height.mas_equalTo(height);
    }];
    
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteBtn setTitle:@"删除好友" forState:UIControlStateNormal];
    self.deleteBtn.backgroundColor = [UIColor grayColor];
    [self.deleteBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.deleteBtn addTarget:self action:@selector(deleteFriendByuId) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.deleteBtn];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(45);
    }];

}

- (void)initData{
    
    [self.userNameLabel setText:@"用户名:"];
    [self.userNameText setText:self.loginInfoModel.user];
    

}

- (void)deleteFriendByuId{
    [[NSNotificationCenter defaultCenter] postNotificationName:XMPPMANAGER_DELETE_FRIEND object:self.loginInfoModel.user];
    [[NSNotificationCenter defaultCenter] postNotificationName:ADDRESS_Delete_ROSTER_DATA object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickBackBtn{
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
