//
//  AddressSideView.h
//  IMDemo
//
//  Created by Civet on 2020/4/14.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AddressSideViewDelegate <NSObject>

- (void)sideViewClick:(NSInteger)btnTag;

@end

@interface AddressSideView : UIView

@property (nonatomic,weak) id<AddressSideViewDelegate> delegate;

- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
