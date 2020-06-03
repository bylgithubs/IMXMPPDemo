//
//  CommonMethods.m
//  IMDemo
//
//  Created by Civet on 2020/4/17.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "CommonMethods.h"

@implementation CommonMethods

+(BOOL)isEmptyString:(NSString *)text{
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [text isEqualToString:@""];
}

+(NSString *)setDateFormat:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    
    return [formatter stringFromDate:date];
}

+(NSString *)handleUserIDWithSeparated:(NSString *)userId{
    NSArray *strArr = [userId componentsSeparatedByString:@"@"];
    return strArr[0];
}

+ (NSString *)getGoupChatRoomID{
    NSString *room_id = [NSString stringWithFormat:@"%@_%@@conference.%@",[CURRENTUSER lowercaseString],[[NSUUID UUID] UUIDString],SERVER_DOMAIN];
    return room_id;
}

//通过用户id获取用户jid
+ (NSString *)getUserJid:(NSString *)uid{
    return [NSString stringWithFormat:@"%@@%@",uid,SERVER_DOMAIN];
}

//获取uuid
+ (NSString *)getUUid{
    return [[NSUUID UUID] UUIDString];
}

@end
