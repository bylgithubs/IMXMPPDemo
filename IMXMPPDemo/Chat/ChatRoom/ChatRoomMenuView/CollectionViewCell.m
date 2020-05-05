//
//  CollectionViewCell.m
//  IMDemo
//
//  Created by Civet on 2020/4/23.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.deleteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        self.deleteLabel.textAlignment = NSTextAlignmentCenter;
        self.deleteLabel.font = [UIFont systemFontOfSize:18];
        self.deleteLabel.textColor = [UIColor blueColor];
        [self.contentView addSubview:self.deleteLabel];
    }
    return self;
}

@end
