//
//  AddressDataModel.h
//  IMDemo
//
//  Created by Civet on 2020/4/10.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddressDataModel : NSObject

@property (nonatomic,copy) NSString *userID;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *homePhone;
@property (nonatomic,copy) NSString *workPhone;
@property (nonatomic,copy) NSString *iPhonePhone;
@property (nonatomic,copy) NSString *mobilePhone;
@property (nonatomic,copy) NSString *mainPhone;
@property (nonatomic,copy) NSString *remark;

@end

NS_ASSUME_NONNULL_END
