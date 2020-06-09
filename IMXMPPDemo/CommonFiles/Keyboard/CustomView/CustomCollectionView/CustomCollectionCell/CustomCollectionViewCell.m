//
//  CustomCollectionViewCell.m
//  IMXMPPDemo
//
//  Created by Civet on 2020/6/8.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "CustomCollectionViewCell.h"

@implementation CustomCollectionViewCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,self.frame.size.height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.contentMode = UIViewContentModeCenter;
        label.numberOfLines=0;
        label.backgroundColor = [UIColor greenColor];
        label.textColor = [UIColor blueColor];
        self.itemLabel = label;
        [self addSubview:self.itemLabel];
        
    }
    return self;
}

@end
