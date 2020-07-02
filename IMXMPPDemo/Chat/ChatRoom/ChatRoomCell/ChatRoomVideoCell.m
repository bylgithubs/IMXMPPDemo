//
//  ChatRoomVideoCell.m
//  IMXMPPDemo
//
//  Created by Civet on 2020/7/2.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "ChatRoomVideoCell.h"

@implementation ChatRoomVideoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.videoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.videoBtn.frame = CGRectMake(0, 0, 80, 60);
    [self.contentView addSubview:self.videoBtn];
    //单击
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapPressAction)];
    singleTap.numberOfTapsRequired = 1;
    [self.videoBtn addGestureRecognizer:singleTap];
    [self.videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userName.mas_bottom);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-10);
        make.right.mas_equalTo(self.mas_right).mas_offset(-45);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(60);
    }];
}

- (void)configData{
    [super configData];
    if (self.chatRoomModel.messageType == Video) {
        UIImage *image;
        if (self.chatRoomModel.thumbnail != nil && ![self.chatRoomModel.thumbnail isEqualToString:@""]) {
            NSData *data = [self.chatRoomModel.thumbnail base64DecodedData];
            image = [UIImage imageWithData:data];
        } else {
            
        }
        //        NSString *fileName = self.chatRoomModel.content;
        //        NSString *savePath = CHAT_FILE_PATH(fileName);
        //        UIImage *localImage = [CommonMethods getImageFromPath:savePath];
        //        if (localImage) {
        //            image = localImage;
        //        }
        
//        CGFloat imageWidth = CGImageGetWidth(image.CGImage);
//        CGFloat imageHeight = CGImageGetHeight(image.CGImage);
        CGRect btnFrame = self.videoBtn.frame;
        btnFrame.size.width = 80;
        btnFrame.size.height = 60;
        ChatRoomModel *model = self.chatRoomModel;
        if (![CURRENTUSER isEqualToString:model.messageFrom]) {
            btnFrame.origin.x = 45;
        }
        self.videoBtn.frame = btnFrame;
        [self.videoBtn setBackgroundImage:image forState:UIControlStateNormal];
        [self.videoBtn.layer setMasksToBounds:YES];
        [self.videoBtn.layer setCornerRadius:5];
        self.videoBtn.layer.borderWidth = 0.5f;
        self.cellHeight = self.videoBtn.frame.size.height + 40;
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
