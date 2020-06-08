//
//  CustomCollectionView.h
//  IMXMPPDemo
//
//  Created by Civet on 2020/6/8.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@protocol CustomCollectionViewDelegate <NSObject>
@optional

-(void)CustomCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface CustomCollectionView : UIView

@property (nonatomic, strong) id<CustomCollectionViewDelegate> delegate;
@property (nonatomic, strong) UICollectionView *collctionView;
@property (nonatomic, strong) NSArray *itemCollectionListArr;
@property (nonatomic, strong) NSArray *itemimgArray;
@property (nonatomic, strong) NSArray *itemTagArray;
@property (nonatomic, assign) NSInteger itemInRow;
@property (nonatomic, assign) NSInteger itemInColumn;

- (id)initWithFrame:(CGRect)frame collectionArray:(NSArray*)collectionArr tagArray:(NSArray *)tagArray itemInRow:(NSInteger)itemInRow itemInColumn:(NSInteger)itemInColumn;

@end

NS_ASSUME_NONNULL_END
