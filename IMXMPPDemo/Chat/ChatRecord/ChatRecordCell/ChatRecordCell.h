//
//  ChatRecordCell.h
//  IMDemo
//
//  Created by Civet on 2020/4/24.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatRecordCell : UITableViewCell

@property (nonatomic,strong) ChatRecordModel *chatRecordModel;

- (void)configData;

@end

NS_ASSUME_NONNULL_END
