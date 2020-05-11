//
//  SuperAddressCell.m
//  IMDemo
//
//  Created by Civet on 2020/4/10.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "SuperAddressCell.h"

@implementation SuperAddressCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setCellContent{
    self.backgroundColor = [UIColor whiteColor];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
