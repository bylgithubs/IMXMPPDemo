//
//  AddressSegmentView.h
//  IMDemo
//
//  Created by Civet on 2020/4/14.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum{
    SegmentOne = 1,
    SegmentTwo = 2,
} ClickIndex;

@protocol SegmentViewDelegate <NSObject>

- (void)selectSegmentAction:(ClickIndex)index;

@end

@interface AddressSegmentView : UIView

@property (nonatomic,weak) id<SegmentViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
