//
//  AddressViewController.h
//  IMXMPPDemo
//
//  Created by Civet on 2020/5/5.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressTableViewCell.h"
#import <Contacts/Contacts.h>
#import "AddressDataModel.h"
#import <Masonry/Masonry.h>
#import "ChatRoomViewController.h"
#import "DetailInformationViewController.h"
#import "LoginInformationModel.h"
#import "AddFriendViewController.h"


NS_ASSUME_NONNULL_BEGIN

@interface AddressViewController : UIViewController

@property (nonatomic,strong) NSMutableArray *rosterArr;

@end

NS_ASSUME_NONNULL_END
