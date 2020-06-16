//
//  UserAuthorization.m
//  IMXMPPDemo
//
//  Created by Civet on 2020/6/11.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "UserAuthorization.h"
#import <Photos/Photos.h>

@implementation UserAuthorization

+ (void)getPhotoAlbumAuthorization:(UIViewController *)controller completionBlock:(UserAuthorizationAgreeAction)completionBlock{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusNotDetermined:{//未授权状态
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized ) {
                    if (completionBlock) {
                        completionBlock();
                    }
                }
            }];
        }
        case PHAuthorizationStatusRestricted:
            break;
        case PHAuthorizationStatusDenied:{
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请在iPhone的\"设置-隐私-相册\"选项中,允许应用访问你的相册." preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertSure = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                //跳转到系统类
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];
            [alertC addAction:alertSure];
            [controller presentViewController:alertC animated:YES completion:nil];
            break;
        }
        case PHAuthorizationStatusAuthorized:{
            if (completionBlock) {
                completionBlock();
            }
            break;
        }
        default:
            break;
    }
}

@end
