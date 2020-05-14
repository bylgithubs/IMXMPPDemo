//
//  XmppManager.h
//  IMXMPPDemo
//
//  Created by Civet on 2020/5/5.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XMPPFramework.h>
#import "XMLReader.h"
#import "RosterListModel.h"
#import "FMDBOperation.h"
#import "ChatRoomModel.h"
#import "LoginInformationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XmppManager : NSObject

@property (nonatomic,strong) XMPPStream *xmppStream;
@property (nonatomic,strong) XMPPReconnect *xmppReconnect;
@property (nonatomic,strong) XMPPRosterCoreDataStorage *rosterStorage;
@property (nonatomic,strong) XMPPRoster *xmppRoster;
@property (nonatomic,strong) XMPPRoom *xmppRoom;
@property (nonatomic,assign) BOOL isRegisterAfterConnected;
@property (nonatomic,strong) NSMutableArray *rosterArr;

+ (instancetype)sharedInstance;
//连接服务器
- (void)connectToServer:(NSString *)user passward:(NSString *)passward;

//初始化聊天室
- (void)createGroupChat;

@end

NS_ASSUME_NONNULL_END
