//
//  MainTabBarViewController.m
//  IMXMPPDemo
//
//  Created by Civet on 2020/5/5.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "MainTabBarViewController.h"

@interface MainTabBarViewController ()

@property (nonnull,strong) AddressViewController *addrVC;
@property (nonnull,strong) ChatRecordViewController *chatVC;
@property (nonnull,strong) UINavigationController *addrNC;
@property (nonnull,strong) UINavigationController *chatNC;

@end

@implementation MainTabBarViewController
@synthesize addrVC;
@synthesize chatVC;
@synthesize addrNC;
@synthesize chatNC;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initTabBar];
    [self initUI];
    //[self initData];
}

- (void)initTabBar{
    addrVC = [[AddressViewController alloc] init];
    addrNC = [[UINavigationController alloc] initWithRootViewController:addrVC];
    
    chatVC = [[ChatRecordViewController alloc] init];
    chatNC = [[UINavigationController alloc] initWithRootViewController:chatVC];
    
    NSArray *NCArray = @[addrNC,chatNC];
    [self setViewControllers:NCArray];
    
}

- (void)initUI{
    self.tabBar.barTintColor = [UIColor colorWithRed:0 green:1 blue:1 alpha:0.8];
    addrNC.navigationBar.barTintColor = [UIColor blueColor];
    chatNC.navigationBar.barTintColor = [UIColor blueColor];
    [addrVC setTitle:@"通讯录"];
    [addrVC.view setBackgroundColor:[UIColor whiteColor]];
    
    [chatVC setTitle:@"聊天记录"];
    [chatVC.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)initData:(NSMutableArray *)dataArr{
    addrVC.rosterArr = dataArr;
    [[NSNotificationCenter defaultCenter] postNotificationName:ADDRESS_REFRESH_ROSTER_DATA object:nil];
    //获取通讯录数据
    
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
