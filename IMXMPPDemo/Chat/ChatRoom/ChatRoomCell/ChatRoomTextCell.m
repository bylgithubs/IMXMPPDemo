//
//  ChatRoomTextCell.m
//  IMDemo
//
//  Created by Civet on 2020/4/16.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "ChatRoomTextCell.h"

@implementation ChatRoomTextCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.messageContent = [[UILabel alloc] init];
    self.messageContent.numberOfLines = 0;
    self.messageContent.font = [UIFont systemFontOfSize:20];
    //self.messageContent.backgroundColor = [UIColor blueColor];
    [self addSubview:self.messageContent];
}

- (void)configData{
    [super configData];
    ChatRoomModel *model = self.chatRoomModel;
    self.messageContent.text = model.content;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:20]};
    CGSize textSize = [self.messageContent.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20,SCREEN_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    if (![CURRENTUSER isEqualToString:model.messageFrom]) {
        
        [self.messageContent setFrame:CGRectMake(5, 40, textSize.width, textSize.height)];
    } else {
        [self.messageContent setFrame:CGRectMake(SCREEN_WIDTH - textSize.width - 10, 40, textSize.width, textSize.height)];
    }
    self.cellHeight = textSize.height + self.messageContent.frame.origin.y
    + 10;
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
