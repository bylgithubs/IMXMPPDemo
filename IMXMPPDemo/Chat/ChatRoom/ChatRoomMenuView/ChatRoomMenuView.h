//
//  ChatRoomMenuView.h
//  IMDemo
//
//  Created by Civet on 2020/4/23.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionViewFlowLayout.h"
#import "CollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CollectionViewDelegate <NSObject>

@required

- (void)didSelectedItem:(NSMutableArray *)functionArr atIndexPath:(NSIndexPath *)indexPath;

@end

@interface ChatRoomMenuView : UIView

@property (nonatomic,weak) id<CollectionViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame viewController:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
