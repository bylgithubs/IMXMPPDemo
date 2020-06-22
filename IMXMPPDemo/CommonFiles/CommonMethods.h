//
//  CommonMethods.h
//  IMDemo
//
//  Created by Civet on 2020/4/17.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonMethods : NSObject

+(BOOL)isEmptyString:(NSString *)text;

+(NSString *)setDateFormat:(NSDate *)date;

//获取不带@的用户名
+(NSString *)handleUserIDWithSeparated:(NSString *)userId;
//获取聊天室ID
+ (NSString *)getGoupChatRoomID;
//通过用户id获取用户jid
+ (NSString *)getUserJid:(NSString *)uid;
//获取uuid
+ (NSString *)getUUid;
//保存原图
+(BOOL)saveOriginalImageToPath:(NSString *)path image:(NSData *)imageData;
//读取图片
+(UIImage *)getImageFromPath:(NSString *)path;
@end

NS_ASSUME_NONNULL_END
