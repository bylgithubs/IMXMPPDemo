//
//  FMDBOperation.h
//  IMDemo
//
//  Created by Civet on 2020/4/21.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDatabase.h>
#import <FMDatabaseQueue.h>
#import "ChatRoomModel.h"
#import "ChatRecordModel.h"
#import "RosterListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMDBOperation : NSObject

+ (instancetype) sharedDatabaseInstance;
- (void)initDB;
@property (nonatomic,strong) FMDatabase *dbOperation;
@property (nonatomic,strong) FMDatabaseQueue *dbQueue;
//插入花名册信息
- (void)insertRosterData:(RosterListModel *)model;
//删除好友
- (BOOL)deleteRosterFriend:(NSString *)uid;
//查询当前用户所有好友
- (NSMutableArray *)searchFriendsFromRoster;
//插入聊天记录
- (void)insertChatMessage:(ChatRoomModel *)model;
//取出聊天室记录
- (NSMutableArray *)getChatRoomMessage:(NSString *)uid;
//插入最新聊天记录
- (void)insertChatRecord:(ChatRecordModel *)model;
//查询最新聊天消息
- (NSMutableArray *)getChatRecordData;
//删除聊天记录
- (BOOL)deleteChatRoomMessage:(NSString *)jID;
//删除最新聊天记录
- (BOOL)deleteChatRecordMessage:(NSString *)jID;

@end

NS_ASSUME_NONNULL_END
