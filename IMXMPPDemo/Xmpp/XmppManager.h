//
//  XmppManager.h
//  IMXMPPDemo
//
//  Created by Civet on 2020/5/5.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XMPPFramework.h>

NS_ASSUME_NONNULL_BEGIN

@interface XmppManager : NSObject

@property (nonatomic,assign) BOOL isRegisterAfterConnected;
@property (nonatomic,strong) NSMutableArray *rosterArr;

+ (instancetype)sharedInstance;
//连接服务器
- (void)connectToServer:(NSString *)user passward:(NSString *)passward;

@end

NS_ASSUME_NONNULL_END
