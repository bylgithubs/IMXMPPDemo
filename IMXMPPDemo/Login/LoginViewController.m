//
//  LoginViewController.m
//  IMXMPPDemo
//
//  Created by Civet on 2020/5/4.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (nonatomic,strong) UILabel *userNameLabel;
@property (nonatomic,strong) UILabel *passwardLabel;
@property (nonatomic,strong) UITextField *userNameTextField;
@property (nonatomic,strong) UITextField *passwardTextField;
@property (nonatomic,strong) UIButton *loginBtn;
@property (nonatomic,strong) UIButton *registerBtn;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *passward;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    [self initData];
}

-(void)initUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.userNameLabel = [[UILabel alloc] init];
    [self.userNameLabel setText:@"用户名:"];
    
    self.passwardLabel = [[UILabel alloc] init];
    [self.passwardLabel setText:@"密码:"];
    
    self.userNameTextField = [[UITextField alloc] init];
    self.userNameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwardTextField = [[UITextField alloc] init];
    self.passwardTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwardTextField.secureTextEntry = YES;
    
    self.userNameTextField.text = @"aaa";
    self.passwardTextField.text = @"aaa";
    
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginBtn addTarget:self action:@selector(loginClickAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [self.registerBtn addTarget:self action:@selector(registerClickAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.userNameLabel.backgroundColor = [UIColor grayColor];
    self.userNameTextField.backgroundColor = [UIColor greenColor];
    self.passwardLabel.backgroundColor = [UIColor grayColor];
    self.passwardTextField.backgroundColor = [UIColor greenColor];
    self.loginBtn.backgroundColor = [UIColor redColor];
    self.registerBtn.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:self.userNameLabel];
    [self.view addSubview:self.passwardLabel];
    [self.view addSubview:self.userNameTextField];
    [self.view addSubview:self.passwardTextField];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.registerBtn];
    
    CGFloat width = 60;
    CGFloat height = 40;
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(-SCREEN_WIDTH/5);
        make.centerY.mas_equalTo(self.view.mas_centerY).mas_offset(-20);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    [self.userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.userNameLabel.mas_right).mas_offset(10);
        make.top.mas_equalTo(self.userNameLabel.mas_top);
        make.width.mas_equalTo(width*2);
        make.height.mas_equalTo(height);
    }];
    
    [self.passwardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userNameLabel.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(self.userNameLabel.mas_left);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    [self.passwardTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.passwardLabel.mas_right).mas_offset(10);
        make.top.mas_equalTo(self.passwardLabel.mas_top);
        make.width.mas_equalTo(width*2);
        make.height.mas_equalTo(height);
    }];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passwardLabel.mas_bottom).mas_offset(30);
        make.left.mas_equalTo(self.passwardLabel.mas_left).mas_offset(15);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.loginBtn.mas_right).mas_offset(30);
        make.top.mas_equalTo(self.loginBtn.mas_top);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
}

- (void)initData{
    self.userName = self.userNameTextField.text;
    self.passward = self.passwardTextField.text;
}

- (void)loginClickAction{
    //连接xmpp
    XmppManager *xmppManager = [XmppManager sharedInstance];
    xmppManager.isRegisterAfterConnected = NO;
    [xmppManager connectToServer:self.userName passward:self.passward];
}

- (void)registerClickAction{
    //连接xmpp
    XmppManager *xmppManager = [XmppManager sharedInstance];
    xmppManager.isRegisterAfterConnected = YES;
    [xmppManager connectToServer:self.userName passward:self.passward];
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
