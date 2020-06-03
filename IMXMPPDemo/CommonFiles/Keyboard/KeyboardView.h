//
//  KeyboardView.h
//  IMDemo
//
//  Created by Civet on 2020/4/17.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN

@class KeyboardView;

@protocol KeyboardViewDelegate <NSObject>

- (void)KeyboardView:(KeyboardView *)keyboardView textFiledBegin:(UITextView *)textFiled;

@optional
//发送文本消息
-(void)KeyboardView:(KeyboardView *)keyboardView sendBtnClick:(UIButton *)sender text:(NSString *)text attribute:(NSAttributedString *)attr;
//发送语音消息
-(void)KeyboardView:(KeyboardView *)keyboardView sendStatus:(BOOL)status;
-(void)KeyBoardViewHeightChange:(CGRect)keyboardFrame;

@end

@interface KeyboardView : UIView

@property (nonatomic,weak) id<KeyboardViewDelegate> delegate;

+ (KeyboardView *)sharedInstance;
- (void)resignKeyboard;

@end

NS_ASSUME_NONNULL_END
