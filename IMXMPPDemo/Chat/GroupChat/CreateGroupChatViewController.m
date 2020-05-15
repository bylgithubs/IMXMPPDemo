//
//  CreateGroupChatViewController.m
//  IMXMPPDemo
//
//  Created by Civet on 2020/5/14.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "CreateGroupChatViewController.h"

@interface CreateGroupChatViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSMutableArray *selectedArr;//选中cell
@property (nonatomic,strong) NSMutableDictionary *selectedDic;//选择数据

@end

@implementation CreateGroupChatViewController
@synthesize tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    [self initData];
}

- (void)initUI{
    self.tabBarController.tabBar.hidden = YES;
    [self setTitle:@"创建群聊"];
    self.view.backgroundColor = [UIColor whiteColor];
    tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    UIView *backBtnView = [CommonComponentMethods setLeftBarItems:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtnView];
    //底部按钮
    [CommonComponentMethods setBottonButton:self titleWithButton:@"创建群聊"];
    
}

- (void)initData{
    self.selectedArr = [[NSMutableArray alloc] init];
    self.selectedDic = [[NSMutableDictionary alloc] init];
    self.dataArr = [[NSMutableArray alloc] init];
    FMDBOperation *fmdb = [FMDBOperation sharedDatabaseInstance];
    self.dataArr = [fmdb searchFriendsFromRoster];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"CreateGroupChatIdentifier";
    CreateGroupChatCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[CreateGroupChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if ([self.selectedArr containsObject:indexPath]) {
        cell.backgroundColor = [UIColor greenColor];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    RosterListModel *model = self.dataArr[indexPath.row];
    cell.textLabel.text = model.uid;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
    if ([self.selectedArr containsObject:indexPath]) {
        [self.selectedArr removeObject:indexPath];
        [self.selectedDic removeObjectForKey:indexPath];
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor whiteColor];
    } else {
        [self.selectedArr addObject:indexPath];
        [self.selectedDic setObject:self.dataArr[indexPath.row] forKey:indexPath];
        cell.selectedBackgroundView.backgroundColor = [UIColor greenColor];
        cell.backgroundColor = [UIColor greenColor];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (void)clickBackBtn{
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)clickBottonBtn{
    ChatRoomViewController *chatRoomVC = [[ChatRoomViewController alloc] init];
    NSString *groupName = CURRENTUSER;
    RosterListModel *model;
    NSString *key;
    NSArray *allkeys = [self.selectedDic allKeys];
    for (int i = 0; i < allkeys.count; i++) {
        key = [allkeys objectAtIndex:i];
        model = [self.selectedDic objectForKey:key];
        groupName = [groupName stringByAppendingFormat:@",%@",model.nick];
    }
//    NSEnumerator *enumerator = [self.selectedDic objectEnumerator];
//    while (model = [enumerator nextObject]) {
//        groupName = [groupName stringByAppendingFormat:@",%@",model.nick];
//    }
    RosterListModel *rosterModel = [[RosterListModel alloc] init];
    rosterModel.jid = [NSString stringWithFormat:@"%@@%@",[CommonMethods getGoupChatRoomID],SERVER_DOMAIN];
    rosterModel.uid = [CommonMethods getGoupChatRoomID];
    rosterModel.item_type = GROUP;
    rosterModel.domain = SERVER_DOMAIN;
    rosterModel.nick = groupName;
    rosterModel.resource = XMPP_RESOURCE;
    rosterModel.current_date = [CommonMethods setDateFormat:[NSDate date]];
    chatRoomVC.rosterListModel = rosterModel;
    
    XmppManager *xmppManager = [XmppManager sharedInstance];
    [xmppManager createGroupChat];
    
    [self.navigationController pushViewController:chatRoomVC animated:YES];
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
