//
//  SuperChatRoomCell.m
//  IMDemo
//
//  Created by Civet on 2020/4/16.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "SuperChatRoomCell.h"

@implementation SuperChatRoomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        [self initUI];
        //长按事件
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapClick:)];
        [self addGestureRecognizer:longTap];
    }
    return self;
}

- (void)initUI{
    self.userName = [[UILabel alloc] init];
    [self.userName setTextColor:[UIColor orangeColor]];
    
    self.messageContent = [[UILabel alloc] init];
    
    self.messageContent.numberOfLines = 0;
    
//    self.userName.backgroundColor = [UIColor greenColor];
//    self.messageContent.backgroundColor = [UIColor blueColor];
    
    [self addSubview:self.userName];
    [self addSubview:self.messageContent];
}

- (void)configData{
    ChatRoomModel *model = self.chatRoomModel;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    self.userName.text = model.messageFrom;
    self.messageContent.text = model.content;
    
    if (![CURRENTUSER isEqualToString:model.messageFrom]) {
        self.userName.frame = CGRectMake(5, 5, width/5, height/4);
        self.messageContent.frame = CGRectMake(5, 10 + height/4, width - 20, height/1.8);
        self.userName.textAlignment = NSTextAlignmentLeft;
        self.messageContent.textAlignment = NSTextAlignmentLeft;
    } else {
        self.userName.frame = CGRectMake(SCREEN_WIDTH - width/5 - 10, 5, width/5, height/4);
        self.messageContent.frame = CGRectMake(20, 10 + height/4, width-30, height/1.8);
        self.userName.textAlignment = NSTextAlignmentRight;
        self.messageContent.textAlignment = NSTextAlignmentRight;
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
