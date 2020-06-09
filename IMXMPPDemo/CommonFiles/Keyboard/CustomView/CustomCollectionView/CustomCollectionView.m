//
//  CustomCollectionView.m
//  IMXMPPDemo
//
//  Created by Civet on 2020/6/8.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "CustomCollectionView.h"

@interface CustomCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, assign) CGRect collectionFrame;

@end

@implementation CustomCollectionView

static NSString * identifier = @"CustomCollectionCell";

-(UICollectionView *)collectionView{
    
    if (!_collectionView) {
        
        //自动网格布局
        CGFloat cellWidth = self.collectionFrame.size.width/self.itemInColumn - 20;
        CGFloat cellHeight = self.collectionFrame.size.width/self.itemInColumn - 20;
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(cellWidth, cellHeight);
        //设置单元格之间的间距
        flowLayout.minimumLineSpacing = 10;
        //网格布局
        CGRect collectionFrame = self.collectionFrame;
        collectionFrame.size.height = cellHeight*_itemInRow;
        self.collectionFrame = collectionFrame;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.collectionFrame collectionViewLayout:flowLayout];
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        //注册cell
        
        [_collectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:identifier];
        
        //设置数据源代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self addSubview:_collectionView];
    }
    
    return _collectionView;

}

- (id)initWithFrame:(CGRect)frame collectionArray:(NSArray*)collectionArr tagArray:(NSArray *)tagArray itemInRow:(NSInteger)itemInRow itemInColumn:(NSInteger)itemInColumn
{
    self = [super initWithFrame:frame];
    if (self) {
        self.collectionFrame = frame;
//        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
//        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        self.itemCollectionListArr = collectionArr;
        self.itemTagArray = tagArray;
        self.itemInRow = itemInRow;
        self.itemInColumn = itemInColumn;
//        self.collectionView.delegate = self;
//        self.collectionView.dataSource = self;
        //[self.collectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:@"CustomCollectionCell"];
    }
    
    return self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.itemCollectionListArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCollectionCell" forIndexPath:indexPath];
    NSString *str = [self.itemCollectionListArr objectAtIndex:indexPath.row];
    cell.itemLabel.text = [self.itemCollectionListArr objectAtIndex:indexPath.row];
    cell.tag = [[self.itemTagArray objectAtIndex:indexPath.row] intValue];
    
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
