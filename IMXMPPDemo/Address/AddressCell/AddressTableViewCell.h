//
//  AddressTableViewCell.h
//  IMDemo
//
//  Created by Civet on 2020/4/14.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "SuperAddressCell.h"
#import "AddressSideView.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddressTableViewCell : SuperAddressCell

@property (nonatomic,strong) NSMutableDictionary *dataDic;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) AddressSideView *sideView;

- (void)setCellContent;
- (void)addAddressSideView;

@end

NS_ASSUME_NONNULL_END
