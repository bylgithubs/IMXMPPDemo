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
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExisted = [fileManager fileExistsAtPath:DATABASE_FOLDER];
    if (!isExisted) {
        [fileManager createDirectoryAtPath:DATABASE_FOLDER withIntermediateDirectories:YES attributes:nil error:nil];
    }
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
    NSString *sqlStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(_id integer PRIMARY KEY AUTOINCREMENT,jid varchar,uid varchar,domain varchar,nick varchar,resource varchar,current_date varchar)",tableName];
    NSLog(@"===%@",sqlStr);
    BOOL result = [self.dbOperation executeUpdate:sqlStr];
    if (result) {
        NSLog(@"创建表 %@ 成功",tableName);
    } else {
        NSLog(@"创建表 %@ 失败",tableName);
    }
    
    tableName = @"ChatMessage";
    sqlStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(_id integer PRIMARY KEY AUTOINCREMENT,uid varchar,room_id varchar,user_nick varchar,message_type varchar,message_from varchar,message_to varchar,content text,send_date varchar)",tableName];
    NSLog(@"===%@",sqlStr);
    result = [self.dbOperation executeUpdate:sqlStr];
    if (result) {
        NSLog(@"创建表 %@ 成功",tableName);
    } else {
        NSLog(@"创建表 %@ 失败",tableName);
    }
    
    tableName = @"ChatRecord";
    sqlStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(_id integer PRIMARY KEY AUTOINCREMENT,uid varchar,room_id varchar,user_nick varchar,message_type varchar,message_from varchar,message_to varchar,content text,send_date varchar)",tableName];
    NSLog(@"===%@",sqlStr);
    result = [self.dbOperation executeUpdate:sqlStr];
    if (result) {
        NSLog(@"创建表 %@ 成功",tableName);
    } else {
        NSLog(@"创建表 %@ 失败",tableName);
    }
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
        sqlStr = @"insert into RosterList(jid,uid,domain,nick,resource,current_date) values(?,?,?,?,?,?);";
        [db executeUpdate:sqlStr,model.jid,model.uid,model.domain,model.nick,model.resource,model.current_date];
    }];
}

//删除好友
- (BOOL)deleteRosterFriend:(NSString *)uid{
    NSString *jid = [NSString stringWithFormat:@"%@@%@",uid,SERVER_DOMAIN];
    @try {
        [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
            NSString *sqlStr = @"delete from RosterList where jid = ?";
            [db executeUpdate:sqlStr,jid];
        }];
    } @catch (NSException *exception) {
        NSLog(@"=========删除本地好友失败");
        return NO;
    }
}

//查询当前用户所有好友
- (NSMutableArray *)searchFriendsFromRoster{
    NSMutableArray *dataArr = [NSMutableArray array];
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sqlStr = @"select * from RosterList";
        FMResultSet *resultSet = [db executeQuery:sqlStr];
        while ([resultSet next]) {
            RosterListModel *model = [[RosterListModel alloc] init];
            model.jid = [resultSet stringForColumn:@"jid"];
            model.uid = [resultSet stringForColumn:@"uid"];
            model.domain = [resultSet stringForColumn:@"domain"];
            model.nick = [resultSet stringForColumn:@"nick"];
            model.resource = [resultSet stringForColumn:@"resource"];
            model.current_date = [resultSet stringForColumn:@"current_date"];
            [dataArr addObject:model];
        }
        [resultSet close];
    }];
    return dataArr;
}

//插入聊天记录
- (void)insertChatMessage:(ChatRoomModel *)model{

    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sqlStr = @"insert into ChatMessage(uid,room_id,user_nick,message_type,message_from,message_to,content,send_date) values(?,?,?,?,?,?,?,?)";
        [db executeUpdate:sqlStr,model.uId,model.roomId,model.userNick,model.messageType,model.messageFrom,model.messageTo,model.content,model.sendDate];
    }];
}

//插入最新聊天记录
- (void)insertChatRecord:(ChatRecordModel *)model{
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sqlStr = @"select * from ChatRecord where uid = ?";
        FMResultSet *resultSet = [db executeQuery:sqlStr,model.uId];
        if ([resultSet next]) {
            sqlStr = @"delete from ChatRecord where uid = ?";
            [db executeUpdate:sqlStr,model.uId];
        }
        [resultSet close];
        sqlStr = @"insert into ChatRecord(uid,room_id,user_nick,message_type,message_from,message_to,content,send_date) values(?,?,?,?,?,?,?,?)";
        [db executeUpdate:sqlStr,model.uId,model.roomId,model.userNick,model.messageType,model.messageFrom,model.messageTo,model.content,model.sendDate];
    }];
}

//取出聊天记录
- (NSMutableArray *)getChatRoomMessage:(NSString *)uid{
    NSMutableArray *dataArr = [NSMutableArray array];
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sqlStr = @"select * from ChatMessage where uid = ?";
        FMResultSet *resultSet = [db executeQuery:sqlStr,uid];
        while ([resultSet next]) {
            ChatRoomModel *model = [[ChatRoomModel alloc] init];
            model.jId = [resultSet stringForColumn:@"_id"];
            model.uId = [resultSet stringForColumn:@"uid"];
            model.roomId = [resultSet stringForColumn:@"room_id"];
            model.userNick = [resultSet stringForColumn:@"user_nick"];
            model.messageFrom = [resultSet stringForColumn:@"message_from"];
            model.messageTo = [resultSet stringForColumn:@"message_to"];
            model.messageType = [resultSet stringForColumn:@"message_type"];
            model.content = [resultSet stringForColumn:@"content"];
            model.sendDate = [resultSet stringForColumn:@"send_date"];
            [dataArr addObject:model];
        }
        [resultSet close];
    }];
    
    return dataArr;
}

//删除聊天记录
- (BOOL)deleteChatRoomMessage:(NSString *)jID{
    @try {
        [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
            NSString *sqlStr = @"delete from ChatMessage where _id = ?";
            [db executeUpdate:sqlStr,jID];
        }];
        return YES;
    } @catch (NSException *exception) {
        NSLog(@"dbOperatin ERROR:%@",exception.description);
        return NO;
    }
}


//查询最新聊天消息
- (NSMutableArray *)getChatRecordData{
    NSMutableArray *dataArr = [NSMutableArray array];
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sqlStr = @"select * from ChatRecord order by _id desc";
        FMResultSet *resultSet = [db executeQuery:sqlStr];
        while ([resultSet next]) {
            ChatRoomModel *model = [[ChatRoomModel alloc] init];
            model.jId = [resultSet stringForColumn:@"_id"];
            model.uId = [resultSet stringForColumn:@"uid"];
            model.roomId = [resultSet stringForColumn:@"room_id"];
            model.userNick = [resultSet stringForColumn:@"user_nick"];
            model.messageFrom = [resultSet stringForColumn:@"message_from"];
            model.messageTo = [resultSet stringForColumn:@"message_to"];
            model.messageType = [resultSet stringForColumn:@"message_type"];
            model.content = [resultSet stringForColumn:@"content"];
            model.sendDate = [resultSet stringForColumn:@"send_date"];
            [dataArr addObject:model];
        }
        [resultSet close];
    }];
    
    return dataArr;
}

//删除最新聊天记录
- (BOOL)deleteChatRecordMessage:(NSString *)jID{
    @try {
        [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
            NSString *sqlStr = @"delete from ChatRecord where _id = ?";
            [db executeUpdate:sqlStr,jID];
        }];
        return YES;
    } @catch (NSException *exception) {
        NSLog(@"dbOperatin ERROR:%@",exception.description);
        return NO;
    }
}

@end
