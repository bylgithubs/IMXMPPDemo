//
//  ChatRoomViewController.m
//  IMDemo
//
//  Created by Civet on 2020/4/15.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "ChatRoomViewController.h"
#import "KeyboardView.h"
#import "ChatRoomModel.h"
#import "ChatRecordModel.h"

@interface ChatRoomViewController ()<UITableViewDelegate,UITableViewDataSource,KeyboardViewDelegate,ChatRoomCellDelegate,CollectionViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) KeyboardView *keyboard;
@property (nonatomic,strong) UITapGestureRecognizer *packUpKeyboard;
@property (nonatomic,strong) ChatRoomMenuView *chatRoomMenuView;
@property (nonatomic,strong) SuperChatRoomCell *currentCell;

@end

@implementation ChatRoomViewController

@synthesize tableView;
@synthesize chatRoomMenuView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    [self initData];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    self.packUpKeyboard = tapGesture;
    [tableView addGestureRecognizer:self.packUpKeyboard];
    [self addNotification:YES];
}

- (void)initUI{
    self.tabBarController.tabBar.hidden = YES;
    if (self.loginInfoModel!=nil) {
        [self.navigationItem setTitle:self.loginInfoModel.user];
    }
    //设置聊天室导航栏标题样式
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = [UIColor whiteColor];
    tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    UIView *backBtnView = [CommonComponentMethods setLeftBarItems:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtnView];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

- (void)initData{
    self.dataArr = [[NSMutableArray alloc] init];
    
//    dispatch_queue_t getChatRoomMessageQueue = dispatch_queue_create("getChatRoomMessageQueue", NULL);
//    dispatch_async(getChatRoomMessageQueue, ^{
//        self.dataArr = [[FMDBOperation sharedDatabaseInstance] getChatRoomMessage:self.addressDataModel.userID];
//        NSLog(@"============%@",[NSThread currentThread]);
//        NSLog(@"============%@",self.dataArr);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.tableView reloadData];
//            [self scrollToTableViewBottom];
//        });
//    });
}

- (void)addNotification:(BOOL)flag{
    if (flag) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:REFRESH_CHATROOM_MESSAGE object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:REFRESH_CHATROOM_MESSAGE object:nil];
    }
}

- (void)refreshTableView{
    [self initData];
    [self scrollToTableViewBottom];
    //[tableView reloadData];
}

- (void)clickBackBtn{
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollToTableViewBottom{
    NSInteger sectionNumber = [tableView numberOfSections];  //有多少组
    if (sectionNumber<1) return;  //无数据时不执行 要不会crash
    NSInteger rowNumber = [tableView numberOfRowsInSection:sectionNumber-1]; //最后一组有多少行
    if (rowNumber<1) return;
    NSIndexPath *index = [NSIndexPath indexPathForRow:rowNumber-1 inSection:sectionNumber-1];  //取最后一行数据
    [tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return 50;
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"ChatRoomTextCell";
    ChatRoomTextCell *textCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (textCell == nil) {
        textCell = [[ChatRoomTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    textCell.delegate = self;
    ChatRoomModel *model = self.dataArr[indexPath.row];
    textCell.chatRoomModel = model;
    textCell.textLabel.text = [NSString stringWithFormat:@"%@",model.content];
    return textCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)viewWillAppear:(BOOL)animated{
    [self addKeyBoard];
    [self changeTableViewHeight];
    
}

- (void)changeTableViewHeight{
    CGRect tableViewFrame = tableView.frame;
    tableViewFrame.size.height = self.keyboard.frame.origin.y;
    tableView.frame = tableViewFrame;
}

- (void)addKeyBoard{
    self.keyboard = [KeyboardView sharedInstance];
    self.keyboard.tag = 2020;
    self.keyboard.frame = CGRectMake(0, self.view.frame.size.height - 44 -SafeAreaBottom - 10, self.view.frame.size.width, 260);
    self.keyboard.delegate = self;
    self.keyboard.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.keyboard];
    
}

- (void)dismissKeyboard{
    [self.keyboard resignKeyboard];
}


-(void)KeyBoardViewHeightChange:(CGRect)keyboardFrame{
//    CGRect customKeyboardFrame = self.keyboard.frame;
//    customKeyboardFrame.origin.y =
    self.keyboard.frame = keyboardFrame;
    [self changeTableViewHeight];
}

- (void)KeyboardView:(KeyboardView *)keyboardView textFiledBegin:(UITextView *)textFiled{
    
}

-(void)KeyboardView:(KeyboardView *)keyboardView sendBtnClick:(UIButton *)sender text:(NSString *)text attribute:(NSAttributedString *)attr{
    NSString *string = text;
    if (text.length > 0) {
        if ([CommonMethods isEmptyString:text]) {
            return;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:DELETE_KEYBOARD_TEXT object:nil];
        //[self SendDataAndInsertDB:text];
    }
}

//发送和存储消息
//- (void)SendDataAndInsertDB:(NSString *)message{
//    dispatch_queue_t dispatchQueue = dispatch_queue_create("SendDataAndInsertDB", nil);
//    dispatch_async(dispatchQueue, ^{
//        ChatRoomModel *chatRoomModel = [[ChatRoomModel alloc] init];
//        ChatRecordModel *chatRecordModel = [[ChatRecordModel alloc] init];
//        chatRoomModel.userID = self.rosterModel.uid;
//        chatRecordModel.userID = self.rosterModel.uid;
//        chatRoomModel.userName = self.rosterModel.uid;
//        chatRecordModel.userName = self.rosterModel.uid;
//        if (message != nil) {
//            chatRoomModel.content = message;
//            chatRecordModel.content = message;
//        }
//        chatRoomModel.currentDate = [CommonMethods setDateFormat:[NSDate date]];
//        chatRecordModel.currentDate = [CommonMethods setDateFormat:[NSDate date]];
//
//    });
//}

- (void)chatRoomTableViewCellLongPress:(SuperChatRoomCell *)chatRoomCell type:(enum MessageType)type content:(NSString *)content{
    NSString *roomID = chatRoomCell.chatRoomModel.userID;
    self.currentCell = chatRoomCell;
    chatRoomMenuView = [[ChatRoomMenuView alloc] initWithFrame:self.view.bounds viewController:self];
    self.chatRoomMenuView.delegate = self;
    //长按后调整键盘和tableView高度
    [self dismissKeyboard];
    [self changeTableViewHeight];
}

- (void)didSelectedItem:(NSMutableArray *)functionArr atIndexPath:(NSIndexPath *)indexPath{
    NSString *functionName = [functionArr objectAtIndex:indexPath.row];
    if ([functionName isEqualToString:@"删除"]) {
        [self deleteMessageCell];
    }
}

- (void)deleteMessageCell{
    NSString *jid = self.currentCell.chatRoomModel.jID;
//    if ([[FMDBOperation sharedDatabaseInstance] deleteChatRoomMessage:jid]) {
//        [self.dataArr removeObject:self.currentCell.chatRoomModel];
//        [self reloadTableView];
//    }
    
}

- (void)reloadTableView{
    [tableView reloadData];
}

- (void)dealloc{
    [self addNotification:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
