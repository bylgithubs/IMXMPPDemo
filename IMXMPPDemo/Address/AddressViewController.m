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
@property (nonatomic,strong) NSMutableDictionary *dataDic;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) AddressSegmentView *segmentView;
@property (nonatomic,strong) NSIndexPath *ClickCellIndex;
@property (nonatomic,assign) BOOL sideSwitch;
@property (nonatomic,strong) AddressDataModel *addressDataModel;


@end

@implementation AddressViewController

@synthesize tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataDic = [[NSMutableDictionary alloc] init];
    self.dataArr = [[NSMutableArray alloc] init];
    self.addressDataModel = [[AddressDataModel alloc] init];
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
}

- (void)initData{
    NSMutableArray *arr = self.rosterArr;
    //获取通讯录数据
    self.dataArr = self.rosterArr;
    //[self requestContactData];
}

#pragma mark notification
- (void)notificationRegister:(BOOL)flag{
    if (flag) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initData) name:ADDRESS_REFRESH_ROSTER_DATA object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:ADDRESS_REFRESH_ROSTER_DATA object:nil];
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
    NSLog(@"=========%@",self.dataDic);
    NSLog(@"=========%@",self.dataArr);
    addrCell.dataDic = self.dataDic;
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
    
    self.addressDataModel = self.dataArr[indexPath.row];
    //self.addressDataModel = [self.dataDic objectForKey:self.dataArr[indexPath.row]];
    NSLog(@"===========%@",self.addressDataModel);
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
        chatRoomVC.addressDataModel = self.addressDataModel;
        [self.navigationController pushViewController:chatRoomVC animated:YES];
    } else {
        DetailInformationViewController *detailInfoVC = [[DetailInformationViewController alloc] init];
        detailInfoVC.detailInfoModel = self.addressDataModel;
        [self.navigationController pushViewController:detailInfoVC animated:YES];
    }
}

- (void)dealloc{
    [self notificationRegister:NO];
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
