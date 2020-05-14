//
//  RosterListModel.h
//  IMXMPPDemo
//
//  Created by Civet on 2020/5/6.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RosterListModel : NSObject

@property (nonatomic,copy) NSString *jid;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *domain;
@property (nonatomic,copy) NSString *nick;
@property (nonatomic,copy) NSString *resource;
@property (nonatomic,copy) NSString *current_date;

@end

NS_ASSUME_NONNULL_END
