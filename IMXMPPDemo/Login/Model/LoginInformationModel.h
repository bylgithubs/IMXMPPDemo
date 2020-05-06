//
//  LoginInformationModel.h
//  IMXMPPDemo
//
//  Created by Civet on 2020/5/5.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginInformationModel : NSObject

@property (nonatomic,copy) NSString *user;
@property (nonatomic,copy) NSString *domain;
@property (nonatomic,copy) NSString *resource;

@end

NS_ASSUME_NONNULL_END
