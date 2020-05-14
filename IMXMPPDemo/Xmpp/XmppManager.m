//
//  XmppManager.m
//  IMXMPPDemo
//
//  Created by Civet on 2020/5/5.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "XmppManager.h"

@interface XmppManager ()<NSXMLParserDelegate,XMPPRoomStorage>


@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *passward;


@end

@implementation XmppManager
@synthesize xmppStream;
@synthesize xmppReconnect;
@synthesize xmppRoom;
@synthesize isRegisterAfterConnected;

#pragma mark Singleton
+ (instancetype)sharedInstance{
    static XmppManager *xmppManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        xmppManager = [self new];
        [xmppManager configStream];
    });
    return xmppManager;
}

- (void)configStream{
    self.rosterArr = [[NSMutableArray alloc] init];
    xmppStream = [[XMPPStream alloc] init];
    xmppReconnect = [[XMPPReconnect alloc] init];
    [xmppReconnect activate:xmppStream];
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self activeModules];
    [self notification:YES];
}

#pragma mark 连接服务器
- (void)connectToServer:(NSString *)user passward:(NSString *)passward{
    if (user.length < 1 || passward.length < 1) {
        return;
    }
    self.userName = user;
    self.passward = passward;
    
    if ([xmppStream isDisconnected]) {
        [xmppStream setMyJID:[XMPPJID jidWithUser:self.userName domain:SERVER_DOMAIN resource:XMPP_RESOURCE]];
        [xmppStream setHostName:HOST_NAME];
        NSError *error = nil;
        [xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
    }else{
        [self disconnectedToServer];
    }
}

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket {
    NSLog(@"socketDidConnect:");
}

//连接服务器成功方法
- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    NSLog(@"xmppStreamDidConnect:");

    NSError *error = nil;
    if (isRegisterAfterConnected) {
        //注册
        [xmppStream registerWithPassword:self.passward error:&error];
    } else {
        //向服务器发送密码验证
        [xmppStream authenticateWithPassword:self.passward error:&error];
    }
}

#pragma mark 连接服务器失败的方法
-(void)xmppStreamConnectDidTimeout:(XMPPStream *)sender{
    NSLog(@"连接服务器失败的方法，请检查网络是否正常");
}

#pragma mark 与服务器断开连接
- (void)disconnectedToServer{
    //表示离线不可用
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    //向服务器发送离线消息
    [xmppStream sendElement:presence];
     //断开链接
    [xmppStream disconnect];
}

#pragma mark 注册成功的方法
-(void)xmppStreamDidRegister:(XMPPStream *)sender{
    //断开之前的连接
    [self disconnectedToServer];
    NSLog(@"注册成功的方法");
}

#pragma mark 注册失败的方法
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
    //断开之前的连接
    [self disconnectedToServer];
    NSLog(@"注册失败执行的方法");
}

#pragma mark 密码验证成功方法
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    NSLog(@"xmppStreamDidAuthenticate:");
    
    [self.rosterArr removeAllObjects];
    [[NSUserDefaults standardUserDefaults] setObject:self.userName forKey:@"currentUserName"];
    [[NSUserDefaults standardUserDefaults] setObject:self.passward forKey:@"currentPassward"];
    [[NSNotificationCenter defaultCenter] postNotificationName:CREATE_DATABASE_AND_TABLE object:nil];
    //[self getDetailsofRegisteredUser];
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
    [[self xmppStream] sendElement:presence];
}

#pragma mark 密码验证失败方法
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    NSLog(@"验证失败的方法,请检查你的用户名或密码是否正确,%@",error);
}

#pragma mark 激活花名册模块，获取好友列表
- (void)activeModules{
    //1.花名册存储对象
    self.rosterStorage = [XMPPRosterCoreDataStorage sharedInstance];
    //2.花名册模块
    self.xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:self.rosterStorage];
    //3.激活此模块
    [self.xmppRoster activate:self.xmppStream];
    //4.添加roster代理
    [self.xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

#pragma mark 获取所有好友,有多少好友，这个代理方法执行几遍
//获取所有好友,有多少好友，这个代理方法执行几遍
-(void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(DDXMLElement *)item
{  //得到item的jid
    NSString *jid = [[item attributeForName:@"jid"]stringValue];
    
    //转换成XMPPJID类型
    XMPPJID *userJID = [XMPPJID jidWithString:jid];
    NSLog(@"%@",[userJID user]);
    //将所有userJID放入数组，以便在获取好友列表结束时为外部传值
    [self.rosterArr addObject:userJID];
}

//登录成功后会执行这个代理
-(void)xmppRosterDidEndPopulating:(XMPPRoster *)sender
{
    NSLog(@"获取好友列表结束,此处向外部传值");
//    [self sendMessage:@"111111111111111111111111111111111111" toUser:@"bbb"];
    NSMutableArray *arr = self.rosterArr;
    FMDBOperation *fmdb = [FMDBOperation sharedDatabaseInstance];
    RosterListModel *model = [[RosterListModel alloc] init];
    for (XMPPJID *jid in self.rosterArr) {
        model.jid = [NSString stringWithFormat:@"%@@%@",jid.user,jid.domain];
        model.uid = jid.user;
        model.domain = jid.domain;
        model.nick = jid.user;
        model.resource = jid.resource;
        model.current_date = [CommonMethods setDateFormat:[NSDate date]];
        [fmdb insertRosterData:model];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_SUCCESS object:self.rosterArr];

}

//添加好友
- (void)xmppAddFriendSubscribe:(NSNotification *)noti
{
    //XMPPHOST 就是服务器名， 主机名
    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",noti.object,SERVER_DOMAIN]];
    [self.xmppRoster subscribePresenceToUser:jid];
}

//删除好友
- (void)xmppDeleteFriendSubscribe:(NSNotification *)noti
{
    //XMPPHOST 就是服务器名， 主机名
    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",noti.object,SERVER_DOMAIN]];
    [self.xmppRoster removeUser:jid];
}

#pragma mark -- 聊天相关
//发送消息方法
//-(void)sendMessage:(NSString *)sendMsg toJid:(XMPPJID *)jid
//{
//    //组装xml格式的消息
//    XMPPMessage *msg = [XMPPMessage messageWithType:@"chat" to:jid];
//    /*添加内容节点
//     <message type = "chat" ,ToJID = toJid>
//     <body>sendMsg</body>
//     </message>
//     */
//    [self sendMessage:sendMsg toJid:jid];
//    [msg addBody:sendMsg];
//    //发送
//    [xmppStream sendElement:msg];
//}

//- (void)sendMessage{
//    [self sendMessage:@"2222222222222222222" toUser:@"bbb"];
//}

- (void)sendMessage:(NSString *) message1 toUser:(NSString *) user
{
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:message1];
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    NSString *to = [NSString stringWithFormat:@"%@@%@", user,SERVER_DOMAIN];
    [message addAttributeWithName:@"to" stringValue:to];
    [message addChild:body];
    [self.xmppStream sendElement:message];
}

#pragma mark -- 消息代理方法
-(void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message
{
    NSLog(@"发送消息成功");
}
-(void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error
{
    NSLog(@"发送失败");
}
//接收到消息触发
-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    [self parseDidReceiveMessage:message];
    NSLog(@"接收到消息--%@",[message body]);
}

- (void)parseDidReceiveMessage:(XMPPMessage *)message{
    NSString *type = [[message attributeForName:@"type"] stringValue];
    NSString *messageFrom = [[message attributeForName:@"from"] stringValue];
    NSString *messageTo = [[message attributeForName:@"to"] stringValue];
    NSString *sendDate = [[message attributeForName:@"sendDate"] stringValue];
    NSString *body = [message body];
    ChatRoomModel *chatRoomModel = [[ChatRoomModel alloc] init];
    messageFrom = [CommonMethods handleUserIDWithSeparated:messageFrom];
    messageTo = [CommonMethods handleUserIDWithSeparated:messageTo];
    chatRoomModel.uId = messageFrom;
    chatRoomModel.roomId = messageFrom;
    chatRoomModel.userNick = messageFrom;
    chatRoomModel.messageType = type;
    chatRoomModel.messageFrom = messageFrom;
    chatRoomModel.messageTo = messageTo;
    chatRoomModel.sendDate =sendDate;
    chatRoomModel.content = body;
    
    ChatRecordModel *chatRecordModel = [[ChatRecordModel alloc] init];
    chatRecordModel.uId = messageFrom;
    chatRecordModel.roomId = messageFrom;
    chatRecordModel.userNick = messageFrom;
    chatRecordModel.messageType = type;
    chatRecordModel.messageFrom = messageFrom;
    chatRecordModel.messageTo = messageTo;
    chatRecordModel.sendDate =sendDate;
    chatRecordModel.content = body;
    FMDBOperation *fmdb = [FMDBOperation sharedDatabaseInstance];
    [fmdb insertChatMessage:chatRoomModel];
    [fmdb insertChatRecord:chatRecordModel];
    [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_CHATROOM_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_CHAT_RECORD object:nil];
}

//初始化聊天室
- (void)createGroupChat{
    XMPPJID *room_id = [XMPPJID jidWithString:[CommonMethods getGoupChatRoomID]];
    xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:self jid:room_id];
    [xmppRoom activate:xmppStream];
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

-(void)xmppRoomDidCreate:(XMPPRoom *)sender
{
    NSLog(@"================创建聊天室成功");
}

- (void)notification:(BOOL)flag{
    if (flag) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xmppAddFriendSubscribe:) name:XMPPMANAGER_ADD_FRIEND object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xmppDeleteFriendSubscribe:) name:XMPPMANAGER_DELETE_FRIEND object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disconnectedToServer) name:XMPPMANAGER_DISCONNECTED_TO_SERVER object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:XMPPMANAGER_ADD_FRIEND object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:XMPPMANAGER_DELETE_FRIEND object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:XMPPMANAGER_DISCONNECTED_TO_SERVER object:nil];
    }
}

- (void)dealloc{
    [self notification:NO];
}


@end
