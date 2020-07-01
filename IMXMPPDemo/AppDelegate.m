//
//  AppDelegate.m
//  IMXMPPDemo
//
//  Created by Civet on 2020/5/4.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    //创建项目目录结构
    [CommonMethods createDirectoryStructure];
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    self.window.rootViewController = loginVC;
    [self.window makeKeyAndVisible];
    [self notificationRegister:YES];
    
    return YES;
}

- (void)loginMainInterface{
    [self cleanCacheAndCookie];
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = loginVC;
}

- (void)cleanCacheAndCookie{
    NSHTTPCookie *cookie;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies]){
            [storage deleteCookie:cookie];
        }
    //    [[NSURLCache sharedURLCache] removeAllCachedResponses];
        NSURLCache * cache = [NSURLCache sharedURLCache];
        [cache removeAllCachedResponses];
        [cache setDiskCapacity:0];
        [cache setMemoryCapacity:0];
}

#pragma mark notification
- (void)notificationRegister:(BOOL)flag{
    if (flag) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginMainInterface) name:ADDRESS_LOGINOUT object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(entryMainTabBar:) name:LOGIN_SUCCESS object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initDB) name:CREATE_DATABASE_AND_TABLE object:nil];
    } else {
         [[NSNotificationCenter defaultCenter] removeObserver:self name:ADDRESS_LOGINOUT object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGIN_SUCCESS object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:CREATE_DATABASE_AND_TABLE object:nil];
    }
}

- (void)entryMainTabBar:(NSNotification *)noti{
    MainTabBarViewController *mainTabBarVC = [[MainTabBarViewController alloc] init];
    self.window.rootViewController = mainTabBarVC;
    [self.window makeKeyAndVisible];
    
    //创建数据库
    //[self initDB];
}

//创建数据库
- (void)initDB{
    FMDBOperation *shareInstance = [FMDBOperation sharedDatabaseInstance];
    
    [shareInstance initDB];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)dealloc{
    [self notificationRegister:NO];
}

@end
