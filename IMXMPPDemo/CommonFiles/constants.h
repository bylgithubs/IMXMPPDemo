//
//  constants.h
//  IMXMPPDemo
//
//  Created by Civet on 2020/5/4.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#ifndef constants_h
#define constants_h


#endif /* constants_h */


#pragma mark 屏幕大小
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#pragma mark 服务器相关
#define SERVER_DOMAIN @"192.168.43.139"
#define SERVER_PORT @"5222"
#define XMPP_RESOURCE @"iOS"
#define HOST_NAME @"192.168.43.139"

#pragma mark 手机屏幕适配
#define Device_Is_iPhoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define SafeAreaBottom (Device_Is_iPhoneX ? 34.f : 0.f) //底部安全距离

#pragma mark 添加通知
#define LOGIN_SUCCESS @"LoginSuccess"
#define REGISTER_SUCCESS @"RegisterSuccess"
#define DELETE_KEYBOARD_TEXT @"DeleteKeyboardText"
#define REFRESH_CHATROOM_MESSAGE @"RefreshChatRoomMessage"
#define UPDATE_CHAT_RECORD @"UpdateChatRecord"
#define ADDRESS_REFRESH_ROSTER_DATA @"AddressRefreshRosterData"

enum MessageType{
    Text
};
