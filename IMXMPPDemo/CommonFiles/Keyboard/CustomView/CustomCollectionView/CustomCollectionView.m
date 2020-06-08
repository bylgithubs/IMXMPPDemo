//
//  CustomCollectionView.m
//  IMXMPPDemo
//
//  Created by Civet on 2020/6/8.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "CustomCollectionView.h"

@interface CustomCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation CustomCollectionView

- (id)initWithFrame:(CGRect)frame collectionArray:(NSArray*)collectionArr tagArray:(NSArray *)tagArray itemInRow:(NSInteger)itemInRow itemInColumn:(NSInteger)itemInColumn
{
    self = [super initWithFrame:frame];
    if (self) {
        self.itemCollectionListArr = collectionArr;
        self.itemTagArray = tagArray;
        self.itemInRow = itemInRow;
        self.itemInColumn = itemInColumn;
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
