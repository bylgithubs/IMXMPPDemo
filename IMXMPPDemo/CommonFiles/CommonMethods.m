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

@end
