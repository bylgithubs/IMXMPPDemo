//
//  ChatRoomPictureCell.m
//  IMXMPPDemo
//
//  Created by Civet on 2020/6/22.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "ChatRoomPictureCell.h"

@implementation ChatRoomPictureCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.pictureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.pictureBtn.frame = CGRectMake(0, 0, 60, 60);
    [self.contentView addSubview:self.pictureBtn];
    //单击
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapPressAction)];
    singleTap.numberOfTapsRequired = 1;
    [self.pictureBtn addGestureRecognizer:singleTap];
}

- (void)configData{
    [super configData];
    if (self.chatRoomModel.messageType == Picture) {
        UIImage *image;
        if (self.chatRoomModel.thumbnail != nil && ![self.chatRoomModel.thumbnail isEqualToString:@""]) {
            NSData *data = [self.chatRoomModel.thumbnail base64DecodedData];
            image = [UIImage imageWithData:data];
        } else {
            
        }
        NSString *fileName = self.chatRoomModel.content;
        NSString *savePath = CHAT_FILE_PATH(fileName);
        UIImage *localImage = [CommonMethods getImageFromPath:savePath];
        if (localImage) {
            image = localImage;
        }
        
        CGFloat imageWidth = CGImageGetWidth(image.CGImage);
        CGFloat imageHeight = CGImageGetHeight(image.CGImage);
        self.pictureBtn.frame = CGRectMake(self.frame.size.width - 200, 30, imageWidth, imageHeight);
        [self.pictureBtn setBackgroundImage:image forState:UIControlStateNormal];
        [self.pictureBtn.layer setMasksToBounds:YES];
        [self.pictureBtn.layer setCornerRadius:5];
        self.pictureBtn.layer.borderWidth = 0.5f;
        self.cellHeight = self.pictureBtn.frame.size.height + 40;
    }
}

- (void)singleTapPressAction{
    
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
