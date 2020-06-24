//
//  ChatRoomPictureCell.m
//  IMXMPPDemo
//
//  Created by Civet on 2020/6/22.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "ChatRoomPictureCell.h"
@interface ChatRoomPictureCell()

//@property (nonatomic, strong) UIImage *thumbnailImage;
//@property (nonatomic, strong) UIImage *localImage;

@end

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
    [self.pictureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userName.mas_bottom);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-10);
        make.right.mas_equalTo(self.mas_right).mas_offset(-45);
    }];
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
//        NSString *fileName = self.chatRoomModel.content;
//        NSString *savePath = CHAT_FILE_PATH(fileName);
//        UIImage *localImage = [CommonMethods getImageFromPath:savePath];
//        if (localImage) {
//            image = localImage;
//        }
        
        CGFloat imageWidth = CGImageGetWidth(image.CGImage);
        CGFloat imageHeight = CGImageGetHeight(image.CGImage);
        CGRect btnFrame = self.pictureBtn.frame;
        btnFrame.size.width = imageWidth;
        btnFrame.size.height = imageHeight;
        ChatRoomModel *model = self.chatRoomModel;
        if (![CURRENTUSER isEqualToString:model.messageFrom]) {
            btnFrame.origin.x = 45;
        }
        self.pictureBtn.frame = btnFrame;
        [self.pictureBtn setBackgroundImage:image forState:UIControlStateNormal];
        [self.pictureBtn.layer setMasksToBounds:YES];
        [self.pictureBtn.layer setCornerRadius:5];
        self.pictureBtn.layer.borderWidth = 0.5f;
        self.cellHeight = self.pictureBtn.frame.size.height + 40;
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
