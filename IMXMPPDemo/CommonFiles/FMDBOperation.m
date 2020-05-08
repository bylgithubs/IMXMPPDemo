//
//  FMDBOperation.m
//  IMDemo
//
//  Created by Civet on 2020/4/21.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "FMDBOperation.h"


@implementation FMDBOperation

static FMDBOperation *sharedInstance = nil;

+ (instancetype)sharedDatabaseInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (FMDatabaseQueue *)dbQueue{
    if (!_dbQueue) {
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:DATABASE_PATH];
    }
    return _dbQueue;
}

- (void)initDB{
    NSString *databasePath = DATABASE_PATH;
    self.dbOperation = [FMDatabase databaseWithPath:databasePath];
    BOOL isSuccess = [self.dbOperation open];
    if (!isSuccess) {
        NSLog(@"打开数据库 %@ 失败",DATABASE_NAME);
        return;
    }
    if (self.dbOperation != nil) {
        //建表
        [self initTable];
    }
}

- (void)initTable{
    
    NSString *tableName = @"RosterList";
    NSString *sqlStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(_id integer PRIMARY KEY AUTOINCREMENT,jid varchar,uid varchar,name varchar,ask varchar,subscription varchar,current_date varchar)",tableName];
    NSLog(@"===%@",sqlStr);
    BOOL result = [self.dbOperation executeUpdate:sqlStr];
    if (result) {
        NSLog(@"创建表 %@ 成功",tableName);
    } else {
        NSLog(@"创建表 %@ 失败",tableName);
    }
    
//    tableName = @"ChatMessage";
//    sqlStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(_id integer PRIMARY KEY AUTOINCREMENT,room_ID varchar,user_name varchar,content text,current_date varchar)",tableName];
//    NSLog(@"===%@",sqlStr);
//    result = [self.dbOperation executeUpdate:sqlStr];
//    if (result) {
//        NSLog(@"创建表 %@ 成功",tableName);
//    } else {
//        NSLog(@"创建表 %@ 失败",tableName);
//    }
//
//    tableName = @"ChatRecord";
//    sqlStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(jid integer PRIMARY KEY AUTOINCREMENT,room_ID varchar,user_name varchar,content text,current_date varchar)",tableName];
//    NSLog(@"===%@",sqlStr);
//    result = [self.dbOperation executeUpdate:sqlStr];
//    if (result) {
//        NSLog(@"创建表 %@ 成功",tableName);
//    } else {
//        NSLog(@"创建表 %@ 失败",tableName);
//    }
    
}

//插入花名册
- (void)insertRosterData:(RosterListModel *)model{

    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sqlStr = @"select * from RosterList where jid = ?";
        FMResultSet *res = [db executeQuery:sqlStr,model.jid];
        if ([res next]) {
            sqlStr = @"delete from RosterList where jid = ?";
            [db executeUpdate:sqlStr,model.jid];
        }
        sqlStr = @"insert into RosterList(jid,uid,name,ask,subscription,current_date) values(?,?,?,?,?,?);";
        [db executeUpdate:sqlStr,model.jid,model.uid,model.name,model.ask,model.subscription,model.current_date];
    }];
}

//查询用户是否存在
- (NSMutableArray *)searchFriendsFromRoster:(NSString *)name{
    NSMutableArray *dataArr = [NSMutableArray array];
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sqlStr = @"select * from RosterList where uid = ?";
        FMResultSet *resultSet = [db executeQuery:sqlStr,name];
        while ([resultSet next]) {
            RosterListModel *model = [[RosterListModel alloc] init];
            model.jid = [resultSet stringForColumn:@"jid"];
            model.uid = [resultSet stringForColumn:@"uid"];
            model.name = [resultSet stringForColumn:@"name"];
            model.ask = [resultSet stringForColumn:@"ask"];
            model.subscription = [resultSet stringForColumn:@"subscription"];
            model.current_date = [resultSet stringForColumn:@"current_date"];
            [dataArr addObject:model];
        }
        [resultSet close];
    }];
    return dataArr;
}

////插入聊天记录
//- (void)insertChatMessage:(ChatRoomModel *)model{
//    
//    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
//        NSString *sqlStr = @"insert into ChatMessage(room_ID,user_name,content,current_date) values(?,?,?,?)";
//        [db executeUpdate:sqlStr,model.userID,model.userName,model.content,model.currentDate];
//    }];
//}
//
////插入最新聊天记录
//- (void)insertChatRecord:(ChatRecordModel *)model{
//    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
//        NSString *sqlStr = @"select * from ChatRecord where room_ID = ?";
//        FMResultSet *resultSet = [db executeQuery:sqlStr,model.userID];
//        if ([resultSet next]) {
//            sqlStr = @"delete from ChatRecord where room_ID = ?";
//            [db executeUpdate:sqlStr,model.userID];
//        }
//        [resultSet close];
//        sqlStr = @"insert into ChatRecord(room_ID,user_name,content,current_date) values(?,?,?,?)";
//        [db executeUpdate:sqlStr,model.userID,model.userName,model.content,model.currentDate];
//    }];
//}
//
////取出聊天记录
//- (NSMutableArray *)getChatRoomMessage:(NSString *)userID{
//    NSMutableArray *dataArr = [NSMutableArray array];
//    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
//        NSString *sqlStr = @"select * from ChatMessage where room_ID = ?";
//        FMResultSet *resultSet = [db executeQuery:sqlStr,userID];
//        while ([resultSet next]) {
//            ChatRoomModel *model = [[ChatRoomModel alloc] init];
//            model.jID = [NSString stringWithFormat:@"%d",[resultSet intForColumn:@"jid"]];
//            model.userID = [resultSet stringForColumn:@"room_ID"];
//            model.userName = [resultSet stringForColumn:@"user_name"];
//            model.content = [resultSet stringForColumn:@"content"];
//            model.currentDate = [resultSet stringForColumn:@"current_date"];
//            [dataArr addObject:model];
//        }
//        [resultSet close];
//    }];
//    
//    return dataArr;
//}
//
////删除聊天记录
//- (BOOL)deleteChatRoomMessage:(NSString *)jID{
//    @try {
//        [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
//            NSString *sqlStr = @"delete from ChatMessage where jid = ?";
//            [db executeUpdate:sqlStr,jID];
//        }];
//        return YES;
//    } @catch (NSException *exception) {
//        NSLog(@"dbOperatin ERROR:%@",exception.description);
//        return NO;
//    }
//}
//
//
////查询最新聊天消息
//- (NSMutableArray *)getChatRecordData{
//    NSMutableArray *dataArr = [NSMutableArray array];
//    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
//        NSString *sqlStr = @"select * from ChatRecord order by jid desc";
//        FMResultSet *resultSet = [db executeQuery:sqlStr];
//        while ([resultSet next]) {
//            ChatRecordModel *model = [[ChatRecordModel alloc] init];
//            model.jID = [NSString stringWithFormat:@"%d",[resultSet intForColumn:@"jid"]];
//            model.userID = [resultSet stringForColumn:@"room_ID"];
//            model.userName = [resultSet stringForColumn:@"user_name"];
//            model.content = [resultSet stringForColumn:@"content"];
//            model.currentDate = [resultSet stringForColumn:@"current_date"];
//            [dataArr addObject:model];
//        }
//        [resultSet close];
//    }];
//    return dataArr;
//}
//
////删除最新聊天记录
//- (BOOL)deleteChatRecordMessage:(NSString *)jID{
//    @try {
//        [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
//            NSString *sqlStr = @"delete from ChatRecord where jid = ?";
//            [db executeUpdate:sqlStr,jID];
//        }];
//        return YES;
//    } @catch (NSException *exception) {
//        NSLog(@"dbOperatin ERROR:%@",exception.description);
//        return NO;
//    }
//}

@end
