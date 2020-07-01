//
//  CommonMethods.m
//  IMDemo
//
//  Created by Civet on 2020/4/17.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "CommonMethods.h"

@implementation CommonMethods

//创建项目文件目录结构
+(void)createDirectoryStructure{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExisted = [fileManager fileExistsAtPath:USER_FOLDER];
    if (!isExisted) {
        [fileManager createDirectoryAtPath:USER_FOLDER withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    isExisted = [fileManager fileExistsAtPath:CHAT_MESSAGE_PATH];
    if (!isExisted) {
        [fileManager createDirectoryAtPath:CHAT_MESSAGE_PATH withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
}

//创建指定文件夹
+(void)createDirectory:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExisted = [fileManager fileExistsAtPath:filePath];
    if (!isExisted) {
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

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

//保存原图
+(BOOL)saveOriginalImageToPath:(NSString *)path image:(NSData *)imageData
{
    @try
    {
        [imageData writeToFile:path atomically:YES];
        NSLog(@"文件大小为 %lu",(unsigned long)[imageData length]);
        return true;
    }
    @catch (NSException *exception)
    {
        return false;
    }
}

//读取图片
+(UIImage *)getImageFromPath:(NSString *)path{
    UIImage *img=[UIImage imageWithContentsOfFile:path];
    return img;
}

//获取相册权限
+ (void)getUserPhotoAlbumAuthorization:(UIViewController *)controller completionBlock:(GetUserCameraAuthorizationBlock)completionBlock{
    NSString *productName = PRODUCT_NAME;
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusNotDetermined:{//未授权
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    if (completionBlock) {
                        completionBlock();
                    }
                }
            }];
            break;
        }
        case PHAuthorizationStatusRestricted:{//受限
            break;
        }
        case PHAuthorizationStatusDenied://拒绝访问
        {
            UIAlertController *alertC = [UIAlertController
                                          alertControllerWithTitle:NSLocalizedString(@"warming_simple",@"温馨提示")
                                          message:[NSString stringWithFormat:@"请在iPhone的\"设置-隐私-相册\"选项中,允许%@访问你的相册.", productName]
                                          preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertsure = [UIAlertAction actionWithTitle:NSLocalizedString(@"sure_simple", @"确定") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                //跳转到系统类
                NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if([[UIApplication sharedApplication] canOpenURL:url]) {
                    NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];
            [alertC addAction:alertsure];
            [controller presentViewController:alertC animated:YES completion:nil];
            break;
        }
        case PHAuthorizationStatusAuthorized:{//允许
            if (completionBlock) {
                completionBlock();
            }
            break;
        }
        default:{
            break;
        }
    }
}

//获取相机权限
+ (void)getUserCameraAuthorization:(UIViewController *)controller completionBlock:(GetUserCameraAuthorizationBlock)completionBlock {
    //有权限跳转，无权限提示
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    NSString *productName = PRODUCT_NAME;
    if(authStatus == AVAuthorizationStatusAuthorized) {
        if (completionBlock) {
            completionBlock();
        }
    } else if(authStatus == AVAuthorizationStatusDenied) {
        
        // 拒绝
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"请在iPhone的\"设置-隐私-相机\"选项中,允许%@访问你的相机.",productName] preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertsure = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            //跳转到系统类
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
        [alertC addAction:alertsure];
        [controller presentViewController:alertC animated:YES completion:nil];
    } else if(authStatus == AVAuthorizationStatusRestricted) {
        // 相机受限制
    } else if(authStatus == AVAuthorizationStatusNotDetermined) {
        // 未决定
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted) {
                NSLog(@"Granted access to %@ $$$$$$$$$$", AVMediaTypeVideo);
                if (completionBlock) {
                    completionBlock();
                }
            } else {
                NSLog(@"Not granted access to %@ ********", AVMediaTypeVideo);
                UIAlertController *alertVC = [UIAlertController
                                              alertControllerWithTitle:@"温馨提示"
                                              message:[NSString stringWithFormat:@"请在iPhone的\"设置-隐私-相机\"选项中,允许%@访问你的相机." ,productName]
                                              preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *alertsure = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alertVC addAction:alertsure];
                [controller presentViewController:alertVC animated:YES completion:nil];
            }
        }];
    } else {
        // 其他状态
    }
}

@end
