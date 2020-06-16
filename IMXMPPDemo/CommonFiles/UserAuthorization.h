//
//  UserAuthorization.h
//  IMXMPPDemo
//
//  Created by Civet on 2020/6/11.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^UserAuthorizationAgreeAction)(void);

@interface UserAuthorization : NSObject

//相册
+ (void)getPhotoAlbumAuthorization:(UIViewController *)controller completionBlock:(UserAuthorizationAgreeAction)completionBlock;

@end

NS_ASSUME_NONNULL_END
