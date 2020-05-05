//
//  ChatRecordModel.h
//  IMDemo
//
//  Created by Civet on 2020/4/24.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatRecordModel : NSObject

@property (nonatomic,copy) NSString *jID;
@property (nonatomic,copy) NSString *userID;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *currentDate;

@end

NS_ASSUME_NONNULL_END
