//
//  XMLReader.h
//  IMXMPPDemo
//
//  Created by Civet on 2020/5/6.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RosterListModel.h"
#import "CommonMethods.h"

NS_ASSUME_NONNULL_BEGIN

@interface XMLReader : NSObject

+ (instancetype)sharedInstance;
- (NSMutableArray *)arrayWithXMLString:(NSString *)xmlString;

@end

NS_ASSUME_NONNULL_END
