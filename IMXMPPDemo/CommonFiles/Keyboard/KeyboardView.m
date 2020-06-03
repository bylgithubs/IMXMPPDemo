//
//  KeyboardView.m
//  IMDemo
//
//  Created by Civet on 2020/4/17.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "KeyboardView.h"
#import "CustomTextView.h"

@interface KeyboardView()<UITextViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIView *toolView;
@property (nonatomic,strong) CustomTextView *customTV;
@property (nonatomic,strong) UIButton *audioBtn;
@property (nonatomic,strong) UIButton *longPressRecord;
@property (nonatomic,strong) UIButton *sendBtn;
//@property (nonatomic,assign) CGFloat keyboardHeight;
@property (nonatomic,assign) CGRect toolFrame;
@property (nonatomic,assign) BOOL switchFlag;
//@property (nonatomic,assign) CGRect keyboardFrame;
//@property (nonatomic,assign) BOOL isShowKeyboard;

@end

@implementation KeyboardView
//@synthesize keyboardHeight;

static KeyboardView *sharedInstance = nil;

+ (KeyboardView *)sharedInstance{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.frame = CGRectMake(0, 0, SCREEN_WIDTH, 260);
        sharedInstance.backgroundColor = [UIColor grayColor];
        sharedInstance.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        [[NSNotificationCenter defaultCenter] addObserver:sharedInstance selector:@selector(keyboardHeightChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [sharedInstance initKeyboard];
    });
    
    return sharedInstance;
}

- (void)initKeyboard{
//    self.toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    self.switchFlag = YES;
    self.toolView = [[UIView alloc] init];
    
    self.toolFrame = self.toolView.frame;
    self.toolView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.toolView];
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.height.mas_equalTo(44);
        make.right.mas_equalTo(self.mas_right);
    }];

    if (!self.audioBtn) {
        self.audioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.audioBtn.backgroundColor = [UIColor orangeColor];
        [self.audioBtn setTitle:@"开始语音" forState:UIControlStateNormal];
        [self.audioBtn addTarget:self action:@selector(switchAudioBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.toolView addSubview:self.audioBtn];
        [self.audioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.toolView.mas_top).mas_offset(5);
            make.left.mas_equalTo(self.toolView.mas_left).mas_offset(10);
            make.height.mas_equalTo(44);
            make.width.mas_equalTo(44*2);
        }];
    }
    
    if (!self.customTV) {
//        self.customTV = [[CustomTextView alloc] initWithFrame:CGRectMake(10, 5, self.toolView.frame.size.width - 100, 40)];
        self.customTV = [[CustomTextView alloc] init];
        
        self.customTV.font = [UIFont systemFontOfSize:18];
        self.customTV.delegate = self;
        [self.toolView addSubview:self.customTV];
        [self.customTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.toolView.mas_top).mas_offset(5);
            make.left.mas_equalTo(self.audioBtn.mas_right).mas_offset(10);
            make.height.mas_equalTo(44);
            make.right.mas_equalTo(self.toolView.mas_right).mas_offset(-100);
        }];
    }
    
//    if (!self.longPressRecord) {
//        self.longPressRecord = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.longPressRecord.backgroundColor = [UIColor orangeColor];
//        [self.longPressRecord setTitle:@"长按录音" forState:UIControlStateNormal];
//        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapAction)];
//        longTap.delegate = self;
//        [self.longPressRecord addGestureRecognizer:longTap];
//        [self.toolView addSubview:self.longPressRecord];
//        self.longPressRecord.hidden = YES;
//        [self.longPressRecord mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.toolView.mas_top).mas_offset(5);
//            make.left.mas_equalTo(self.audioBtn.mas_right).mas_offset(10);
//            make.height.mas_equalTo(44);
//            make.right.mas_equalTo(self.toolView.mas_right).mas_offset(-100);
//        }];
//    }
    
    if (!self.sendBtn) {
        CGRect toolFrame = self.toolView.frame;
        self.sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.sendBtn.frame = CGRectMake(toolFrame.size.width - 80, 5, 60, 40);
        [self.sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        self.sendBtn.backgroundColor = [UIColor whiteColor];
        [self.sendBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.sendBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.toolView addSubview:self.sendBtn];
        [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.toolView.mas_top).mas_offset(5);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(44);
            make.right.mas_equalTo(self.toolView.mas_right).mas_offset(-20);
        }];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteTextViewData) name:DELETE_KEYBOARD_TEXT object:nil];
    }
}

- (void)switchAudioBtnAction{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = CHAT_MESSAGE_PATH;
    BOOL isExisted = [fileManager fileExistsAtPath:CHAT_MESSAGE_PATH];
    if (!isExisted) {
        [fileManager createDirectoryAtPath:CHAT_MESSAGE_PATH withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *audioPath = [CHAT_MESSAGE_PATH stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.aac",[CommonMethods getUUid]]];
    
    AudioRecorder *audioRecorder = [AudioRecorder sharedInstance];
    if (self.switchFlag) {
        [self.audioBtn setTitle:@"发送录音" forState:UIControlStateNormal];
        [audioRecorder audioRecorderBegin:audioPath];
    } else {
        [self.audioBtn setTitle:@"开始语音" forState:UIControlStateNormal];
        [audioRecorder audioRecorderStop];
    }

    self.switchFlag = !self.switchFlag;
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    AudioRecorder *audioRecorder = [AudioRecorder sharedInstance];
//    [audioRecorder audioRecorderPlay];
//}
- (void)sendBtnClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(KeyboardView:sendBtnClick:text:attribute:)]) {
        [self.delegate KeyboardView:self sendBtnClick:button text:self.customTV.text attribute:self.customTV.attributedText];
    }
}

- (void)deleteTextViewData{
    self.customTV.text = @"";
}


- (void)keyboardHeightChange:(NSNotification *)notification{
    NSLog(@"==============");
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    CGRect customKeyboardFrame = self.frame;
    //CGRect toolFrame = self.toolView.frame;
    
    customKeyboardFrame.origin.y = keyboardRect.origin.y - self.toolFrame.size.height - 44 - 10;
    customKeyboardFrame.size.height = keyboardRect.size.height + self.toolFrame.size.height;
    
    if ([self.delegate respondsToSelector:@selector(KeyBoardViewHeightChange:)]) {
        [self.delegate KeyBoardViewHeightChange:customKeyboardFrame];
    }
}

- (void)resignKeyboard{
    [self.customTV resignFirstResponder];
    [self resignFirstResponder];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DELETE_KEYBOARD_TEXT object:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
