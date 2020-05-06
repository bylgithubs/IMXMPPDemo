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

@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *ask;
@property (nonatomic,copy) NSString *subscription;
@property (nonatomic,copy) NSString *current_date;

@end

NS_ASSUME_NONNULL_END
