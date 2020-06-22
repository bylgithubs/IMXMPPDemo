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
//@property (nonatomic,strong) NSString *userName;
//@property (nonatomic,strong) NSString *passward;

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
    self.userNameLabel.textAlignment = NSTextAlignmentCenter;
    
    self.passwardLabel =
    [[UILabel alloc] init];
    [self.passwardLabel setText:@"密码:"];
    self.passwardLabel.textAlignment = NSTextAlignmentCenter;
    
    self.userNameTextField = [[UITextField alloc] init];
    self.userNameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.userNameTextField.layer.borderWidth = 1.0f;
    self.userNameTextField.layer.cornerRadius = 8;
    self.userNameTextField.layer.borderColor = [UIColor blackColor].CGColor;
    //设置清除按钮
    self.userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.passwardTextField = [[UITextField alloc] init];
    self.passwardTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwardTextField.secureTextEntry = YES;
    self.passwardTextField.layer.borderWidth = 1.0f;
    self.passwardTextField.layer.cornerRadius = 8;
    self.passwardTextField.layer.borderColor = [UIColor blackColor].CGColor;
    //设置清除按钮
    self.passwardTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.userNameTextField.text = @"ccc";
    self.passwardTextField.text = @"ccc";
    
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = 8;
    self.loginBtn.layer.borderWidth = 1.0f;
    
    self.loginBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    [self.loginBtn addTarget:self action:@selector(loginClickAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [self.registerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.registerBtn.layer.borderWidth = 1.0f;
    self.registerBtn.layer.cornerRadius = 8;
    self.registerBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    
    [self.registerBtn addTarget:self action:@selector(registerClickAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.userNameLabel.backgroundColor = [UIColor whiteColor];
    self.userNameTextField.backgroundColor = [UIColor whiteColor];
    self.passwardLabel.backgroundColor = [UIColor whiteColor];
    self.passwardTextField.backgroundColor = [UIColor whiteColor];
    self.loginBtn.backgroundColor = [UIColor whiteColor];
    self.registerBtn.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.userNameLabel];
    [self.view addSubview:self.passwardLabel];
    [self.view addSubview:self.userNameTextField];
    [self.view addSubview:self.passwardTextField];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.registerBtn];
    
    CGFloat width = 70;
    CGFloat height = 35;
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
        make.left.mas_equalTo(self.passwardLabel.mas_left).mas_offset(20);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.loginBtn.mas_right).mas_offset(40);
        make.top.mas_equalTo(self.loginBtn.mas_top);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
}

- (void)initData{
//    self.userName = self.userNameTextField.text;
//    self.passward = self.passwardTextField.text;
}

- (void)loginClickAction{
    //连接xmpp
    XmppManager *xmppManager = [XmppManager sharedInstance];
    xmppManager.isRegisterAfterConnected = NO;
    [xmppManager connectToServer:self.userNameTextField.text passward:self.passwardTextField.text];
}

- (void)registerClickAction{
    //连接xmpp
    XmppManager *xmppManager = [XmppManager sharedInstance];
    xmppManager.isRegisterAfterConnected = YES;
    [xmppManager connectToServer:self.userNameTextField.text passward:self.passwardTextField.text];
    self.userNameTextField.text = @"";
    self.passwardTextField.text = @"";
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
