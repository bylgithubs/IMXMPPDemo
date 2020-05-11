//
//  AddressViewController.m
//  IMXMPPDemo
//
//  Created by Civet on 2020/5/5.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "AddressViewController.h"
#import "AddressSegmentView.h"

@interface AddressViewController ()<UITableViewDelegate,UITableViewDataSource,SegmentViewDelegate,AddressSideViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
//@property (nonatomic,strong) NSMutableDictionary *dataDic;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) AddressSegmentView *segmentView;
@property (nonatomic,strong) NSIndexPath *ClickCellIndex;
@property (nonatomic,assign) BOOL sideSwitch;
@property (nonatomic,strong) UIButton *loginOutBtn;
@property (nonatomic,strong) UIButton *addFriendBtn;
@property (nonatomic,strong) LoginInformationModel *loginInfoModel;


@end

@implementation AddressViewController

@synthesize tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.dataDic = [[NSMutableDictionary alloc] init];
    self.dataArr = [[NSMutableArray alloc] init];
    tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource =self;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    self.ClickCellIndex = nil;
    self.sideSwitch = false;
    
    [self initUI];
    [self initData];
    [self notificationRegister:YES];
}

- (void)initUI{
    self.segmentView = [[AddressSegmentView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 75, (44 - 30)/2, 150, 30)];
    self.navigationItem.titleView = self.segmentView;
    self.segmentView.delegate = self;
    
    self.loginOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginOutBtn.frame = CGRectMake(0, 0, 50, 30);
    [self.loginOutBtn setTitle:@"登出" forState:UIControlStateNormal];
    self.loginOutBtn.backgroundColor = [UIColor blueColor];
    [self.loginOutBtn addTarget:self action:@selector(loginOutClickAction) forControlEvents:UIControlEventTouchUpInside];
    [self.loginOutBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.loginOutBtn];
    
    self.addFriendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addFriendBtn.frame = CGRectMake(0, 0, 80, 30);
    [self.addFriendBtn setTitle:@"添加好友" forState:UIControlStateNormal];
    self.addFriendBtn.backgroundColor = [UIColor blueColor];
    [self.addFriendBtn addTarget:self action:@selector(addFriendClickAction) forControlEvents:UIControlEventTouchUpInside];
    [self.addFriendBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.addFriendBtn];
}

- (void)initData{
    NSMutableArray *arr = self.rosterArr;
    self.dataArr = self.rosterArr;
}

- (void)AddFriend:(NSNotification *)noti{
    [self.dataArr addObject:noti.object];
    self.sideSwitch = NO;
    [tableView reloadData];
}

- (void)DeleteFriend{
    [self.dataArr removeObjectAtIndex:self.ClickCellIndex.row];
    self.sideSwitch = NO;
    [tableView reloadData];
}

//- (void)operationTableViewData:(NSNotification *)noti{
//    NSString *operationType = noti.object;
//    if ([operationType isEqualToString:@"AddFriend"]) {
//
//    }
//    else if ([operationType isEqualToString:@"DeleteFriend"]) {
//
//    }
//
//}

#pragma mark notification
- (void)notificationRegister:(BOOL)flag{
    if (flag) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initData) name:ADDRESS_REFRESH_ROSTER_DATA object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddFriend:) name:ADDRESS_ADD_ROSTER_DATA object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DeleteFriend) name:ADDRESS_Delete_ROSTER_DATA object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:ADDRESS_REFRESH_ROSTER_DATA object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:ADDRESS_ADD_ROSTER_DATA object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:ADDRESS_Delete_ROSTER_DATA object:nil];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"=========%@",self.dataArr);
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"AddressIdentifier";
    AddressTableViewCell *addrCell = (AddressTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (addrCell == nil) {
        addrCell = [[AddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    addrCell.dataArr = self.dataArr;
    [addrCell setCellContent];
    if (self.ClickCellIndex.section == indexPath.section && self.ClickCellIndex.row == indexPath.row && self.sideSwitch) {
        [addrCell addAddressSideView];
        addrCell.sideView.delegate = self;
    }
    LoginInformationModel *model = self.dataArr[indexPath.row];
    addrCell.nameLabel.text = model.user;
    
    return addrCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"section======%ld,row======%ld",(long)indexPath.section,(long)indexPath.row);
    
    self.sideSwitch = !self.sideSwitch;
    
    self.ClickCellIndex = indexPath;
    
    self.loginInfoModel = self.dataArr[indexPath.row];

    [tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.ClickCellIndex.section == indexPath.section && self.ClickCellIndex.row == indexPath.row && self.sideSwitch) {
        return 100;
    }
    return 45;
}

- (void)selectSegmentAction:(ClickIndex)index{
    switch (index) {
        case SegmentOne:
            {
                tableView.hidden = NO;
                [tableView reloadData];
            }
            break;
         case SegmentTwo:
            {
                tableView.hidden = YES;
                self.view.backgroundColor = [UIColor grayColor];
            }
            break;
        default:
            break;
    }
}

- (void)sideViewClick:(NSInteger)btnTag{
    if (btnTag == 1) {
        ChatRoomViewController *chatRoomVC = [[ChatRoomViewController alloc] init];
        chatRoomVC.loginInfoModel = self.loginInfoModel;
        [self.navigationController pushViewController:chatRoomVC animated:YES];
    } else {
        DetailInformationViewController *detailInfoVC = [[DetailInformationViewController alloc] init];
        detailInfoVC.loginInfoModel = self.loginInfoModel;
        [self.navigationController pushViewController:detailInfoVC animated:YES];
    }
}

- (void)dealloc{
    [self notificationRegister:NO];
}

#pragma mark 登出点击事件
- (void)loginOutClickAction{
    [[NSNotificationCenter defaultCenter] postNotificationName:ADDRESS_LOGINOUT object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:XMPPMANAGER_DISCONNECTED_TO_SERVER object:nil];
}

#pragma mark 添加好友点击事件
- (void)addFriendClickAction{
    AddFriendViewController *addFriendVC = [[AddFriendViewController alloc] init];
    [self.navigationController pushViewController:addFriendVC animated:YES];
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
