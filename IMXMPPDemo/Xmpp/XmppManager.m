//
//  XmppManager.m
//  IMXMPPDemo
//
//  Created by Civet on 2020/5/5.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "XmppManager.h"

@interface XmppManager ()<NSXMLParserDelegate>

@property (nonatomic,strong) XMPPStream *xmppStream;
@property (nonatomic,strong) XMPPReconnect *xmppReconnect;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *passward;
@property (nonatomic,strong) XMPPRosterCoreDataStorage *rosterStorage;
@property (nonatomic,strong) XMPPRoster *xmppRoster;

@end

@implementation XmppManager
@synthesize xmppStream;
@synthesize xmppReconnect;
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
    [self activeRosterModules];
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
    NSLog(@"注册失败执行的方法");
}

#pragma mark 密码验证成功方法
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    NSLog(@"xmppStreamDidAuthenticate:");
    
    [[NSUserDefaults standardUserDefaults] setObject:self.userName forKey:@"currentUserName"];
    [[NSUserDefaults standardUserDefaults] setObject:self.passward forKey:@"currentPassward"];
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
    [[self xmppStream] sendElement:presence];
    //[[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_SUCCESS object:nil];
}

#pragma mark 密码验证失败方法
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    NSLog(@"验证失败的方法,请检查你的用户名或密码是否正确,%@",error);
}

#pragma mark 激活花名册模块，获取好友列表
- (void)activeRosterModules{
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
    NSMutableArray *arr = self.rosterArr;
    [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_SUCCESS object:self.rosterArr];

}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    NSString *xmlString = iq.XMLString;
//    NSData *data = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
//    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
//    NSDictionary *dic = [self dictionaryWithParser:parser];
    //NSDictionary *dic = [NSDictionary dictionaryWithXMLString:iq.XMLString];
    //DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    XMLReader *xmlReader = [XMLReader sharedInstance];
    NSMutableArray *dataArr = [xmlReader arrayWithXMLString:xmlString];
    for (RosterListModel *model in dataArr) {
        FMDBOperation *fmdb = [FMDBOperation sharedDatabaseInstance];
        [fmdb insertRosterData:model];
    }
    NSLog(@"searched format %@", iq);
    return YES;

}

//- (NSDictionary<NSString *, id> *)dictionaryWithParser:(NSXMLParser *)parser
//{
//    parser.delegate = self;
//    [parser parse];
////    id result = _root;
////    _root = nil;
////    _stack = nil;
////    _text = nil;
//    NSDictionary *result = nil;
//    return result;
//}
//
//- (void)parser:(__unused NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(__unused NSString *)namespaceURI qualifiedName:(__unused NSString *)qName attributes:(NSDictionary *)attributeDict{
//
//}

@end
