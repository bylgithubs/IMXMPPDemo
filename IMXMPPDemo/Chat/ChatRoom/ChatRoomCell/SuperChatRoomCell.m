//
//  SuperChatRoomCell.m
//  IMDemo
//
//  Created by Civet on 2020/4/16.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "SuperChatRoomCell.h"

@implementation SuperChatRoomCell
@synthesize cellWidth;
@synthesize cellHeight;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        
        self.userName = [[UILabel alloc] init];
        [self.userName setTextColor:[UIColor orangeColor]];
        //self.userName.backgroundColor = [UIColor greenColor];
        [self addSubview:self.userName];
        //长按事件
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapClick:)];
        [self addGestureRecognizer:longTap];
    }
    return self;
}

- (void)configData{
    ChatRoomModel *model = self.chatRoomModel;
    cellWidth = self.frame.size.width;
    cellHeight = self.frame.size.height;
    self.userName.text = model.messageFrom;

    if (![CURRENTUSER isEqualToString:model.messageFrom]) {
        self.userName.textAlignment = NSTextAlignmentLeft;
        self.userName.frame = CGRectMake(5, 5, cellWidth/5, 30);
    } else {
        self.userName.textAlignment = NSTextAlignmentRight;
        self.userName.frame = CGRectMake(SCREEN_WIDTH - cellWidth/5 - 10, 5, cellWidth/5, 30);
    }
    

}

- (void)singleTapPressAction{
    if ([self.delegate respondsToSelector:@selector(chatRoomCellContentSingleTapAction:type:filePath:)])
    {
        [self.delegate chatRoomCellContentSingleTapAction:self type:self.chatRoomModel.messageType filePath:self.chatRoomModel.content];
    }
}

- (void)longTapClick:(UILongPressGestureRecognizer *)sender{
    NSLog(@"=========%ld",(long)sender.state);
    if (sender.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(chatRoomTableViewCellLongPress:type:content:)]) {
            [self.delegate chatRoomTableViewCellLongPress:self type:Text content:nil];
        }
    }
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
