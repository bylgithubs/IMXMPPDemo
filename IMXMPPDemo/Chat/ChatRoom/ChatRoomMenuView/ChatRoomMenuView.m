//
//  ChatRoomMenuView.m
//  IMDemo
//
//  Created by Civet on 2020/4/23.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "ChatRoomMenuView.h"

@interface ChatRoomMenuView()<UIGestureRecognizerDelegate,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UIView *functionView;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UICollectionView *mainCollectionView;
@property (nonatomic,strong) NSMutableArray *functionTextArr;//存储collection底部文字
@property (nonatomic,strong) NSMutableDictionary *cellIdDic;//存放collection识别码

@end

@implementation ChatRoomMenuView
@synthesize mainCollectionView;

- (id)initWithFrame:(CGRect)frame viewController:(UIViewController *)vc{
    self = [super initWithFrame:frame];
    if (self) {
        [self addMenuView:vc];
    }
    return self;
}

- (NSMutableArray *)functionTextArr{
    if (!_functionTextArr) {
        _functionTextArr = [[NSMutableArray alloc] init];
        [_functionTextArr addObject:@"删除"];
    }
    return _functionTextArr;
}

- (NSMutableDictionary *)cellIdDic{
    if (!_cellIdDic) {
        _cellIdDic = [[NSMutableDictionary alloc] init];
    }
    return _cellIdDic;
}

- (void)addMenuView:(UIViewController *)vc{
    self.backgroundColor = [UIColor colorWithRed:119/255 green:136/255 blue:153/255 alpha:0.2];
    //self.alpha = 0.2;
    [vc.view addSubview:self];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitClick)];
    gesture.numberOfTapsRequired = 1;//点击数，默认为1；
    gesture.cancelsTouchesInView = NO;//取消第一响应；
    gesture.delegate = self;
    [self addGestureRecognizer:gesture];
    
    self.functionView = [[UIView alloc] init];
    CGFloat height = 80 + SafeAreaBottom;
    self.functionView.frame = CGRectMake(0, vc.view.bounds.size.height - height, SCREEN_WIDTH, height);
    self.functionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.functionView];
    
    self.functionView.transform = CGAffineTransformMakeTranslation(0.02, SCREEN_WIDTH);
    [UIView animateWithDuration:0.2 animations:^{
        self.functionView.transform = CGAffineTransformMakeTranslation(0.01, 0.01);
    }];
    [self initCollectionView];
}

- (void)initCollectionView{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.functionView addSubview:self.scrollView];
    self.scrollView.pagingEnabled = YES;
    
    CollectionViewFlowLayout *layout = [[CollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(SCREEN_WIDTH, 40);
    
    mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) collectionViewLayout:layout];
    mainCollectionView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:mainCollectionView];
    mainCollectionView.delegate = self;
    mainCollectionView.dataSource = self;
    mainCollectionView.pagingEnabled = YES;
    mainCollectionView.showsHorizontalScrollIndicator = NO;
    
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(0, CGRectGetMaxY(self.scrollView.frame), SCREEN_WIDTH, 1);
    line.backgroundColor = [UIColor grayColor];
    [self.functionView addSubview:line];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(0, CGRectGetMaxY(line.frame) + 1, SCREEN_WIDTH, 40);
    cancel.backgroundColor = [UIColor whiteColor];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(exitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.functionView addSubview:cancel];
    
    
}

- (void)exitClick{
    [UIView animateWithDuration:0.5 animations:^{
        self.functionView.transform = CGAffineTransformMakeTranslation(0.01, SCREEN_WIDTH);
        self.functionView.alpha = 1;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self.functionView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

#pragma mark 代理 collection

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.functionTextArr.count;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = [self.cellIdDic objectForKey:[NSString stringWithFormat:@"%@",indexPath]];
    if (identifier == nil) {
        identifier = [NSString stringWithFormat:@"%@",indexPath];
        [self.cellIdDic setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
        [mainCollectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:identifier];
    }
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSLog(@"======%@",self.functionTextArr);
    cell.deleteLabel.text = [self.functionTextArr objectAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(didSelectedItem:atIndexPath:)]) {
        [self.delegate didSelectedItem:_functionTextArr atIndexPath:indexPath];
    }
    [self exitClick];
}

//避免手势冲突，使didSelectItemAtIndexPath方法无效
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint point = [gestureRecognizer locationInView:self.functionView];
    BOOL result = CGRectContainsPoint(self.functionView.bounds, point);
    return !result;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
