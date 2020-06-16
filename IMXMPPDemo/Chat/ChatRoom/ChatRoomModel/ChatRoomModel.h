//
//  ChatRoomModel.h
//  IMDemo
//
//  Created by Civet on 2020/4/15.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatRoomModel : NSObject

@property (nonatomic,copy) NSString *jId;
@property (nonatomic,copy) NSString *uId;
@property (nonatomic,copy) NSString *roomId;
@property (nonatomic,copy) NSString *userNick;
@property (nonatomic,copy) NSString *messageFrom;
@property (nonatomic,copy) NSString *messageTo;
@property (nonatomic,copy) NSString *messageType;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *thumbnail;
@property (nonatomic,copy) NSString *sendDate;

@end

NS_ASSUME_NONNULL_END
