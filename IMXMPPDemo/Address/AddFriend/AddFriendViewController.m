//
//  AddFriendViewController.m
//  IMXMPPDemo
//
//  Created by Civet on 2020/5/7.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "AddFriendViewController.h"

@interface AddFriendViewController ()<UITableViewDelegate,UITableViewDataSource,SearchFriendDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) SearchFriends *searchFriends;
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation AddFriendViewController
@synthesize tableView;
@synthesize searchFriends;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBarController.tabBar.hidden = YES;
    [self initUI];
    [self initData];
    tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(searchFriends.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-SafeAreaBottom);
        make.right.mas_equalTo(self.view.mas_right);
    }];
    tableView.backgroundColor = [UIColor grayColor];
}

- (void)initUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTitle:@"添加好友"];
    UIView *backBtnView = [CommonComponentMethods setLeftBarItems:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtnView];
    searchFriends = [[SearchFriends alloc] initWithFrame:CGRectMake(0, NAVIGATION_AND_STATUSBAR_HEIGHT, SCREEN_WIDTH , 50)];
    searchFriends.delegate = self;
    [self.view addSubview:searchFriends];
}

- (void)initData{
    self.dataArr = [[NSMutableArray alloc] init];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"AddFriendCell";
    AddFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[AddFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    RosterListModel *model = self.dataArr[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",model.uid];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (void)clickBackBtn{
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark searchFriendDelegate
- (void)searchFriendWithName:(NSString *)name{
    FMDBOperation *fmdb = [FMDBOperation sharedDatabaseInstance];
    self.dataArr = [fmdb searchFriendsFromRoster:name];
    [tableView reloadData];
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
