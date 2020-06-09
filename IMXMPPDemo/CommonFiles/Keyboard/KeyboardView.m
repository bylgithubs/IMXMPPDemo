//
//  KeyboardView.m
//  IMDemo
//
//  Created by Civet on 2020/4/17.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "KeyboardView.h"
#import "CustomTextView.h"
#import "CustomCollectionView.h"

@interface KeyboardView()<UITextViewDelegate,UIGestureRecognizerDelegate,CustomCollectionViewDelegate>

@property (nonatomic,strong) UIView *toolView;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) CustomTextView *customTV;
@property (nonatomic,strong) UIButton *audioBtn;
@property (nonatomic,strong) UIButton *longPressRecord;
@property (nonatomic,strong) UIButton *functionBtn;
@property (nonatomic,strong) UIButton *sendBtn;
//@property (nonatomic,assign) CGFloat keyboardHeight;
@property (nonatomic,assign) CGRect keyboardFrame;
@property (nonatomic,assign) CGRect toolFrame;
@property (nonatomic,assign) BOOL switchFlag;
@property (nonatomic,assign) BOOL functionListSwitch;
@property (nonatomic,strong) CustomCollectionView *collectionView;
@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,assign) NSInteger collectionInRow;
@property (nonatomic,assign) NSInteger collectionInColumn;
//@property (nonatomic,assign) CGRect hideKeyboardFrame;

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
        [sharedInstance notificationRegister:YES];
        [sharedInstance initKeyboard];
    });
    
    return sharedInstance;
}

- (void)initKeyboard{
//    self.toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    self.switchFlag = YES;
    self.functionListSwitch = NO;
    self.keyboardFrame = self.frame;
    self.toolView = [[UIView alloc] init];
    
    
    self.toolView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.toolView.frame = CGRectMake(0, 0, self.keyboardFrame.size.width, 54);
    self.toolFrame = self.toolView.frame;
    [self addSubview:self.toolView];
//    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.mas_top);
//        make.left.mas_equalTo(self.mas_left);
//        make.height.mas_equalTo(54);
//        make.right.mas_equalTo(self.mas_right);
//    }];

    if (!self.audioBtn) {
        self.audioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.audioBtn.backgroundColor = [UIColor orangeColor];
        [self.audioBtn setTitle:@"开始语音" forState:UIControlStateNormal];
        [self.audioBtn addTarget:self action:@selector(switchAudioBtnAction) forControlEvents:UIControlEventTouchUpInside];
        self.audioBtn.frame = CGRectMake(5, 5, 80, 44);
        [self.toolView addSubview:self.audioBtn];
//        [self.audioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.toolView.mas_top).mas_offset(5);
//            make.left.mas_equalTo(self.toolView.mas_left).mas_offset(5);
//            make.height.mas_equalTo(44);
//            make.width.mas_equalTo(44*1.8);
//        }];
    }
    
    if (!self.customTV) {
//        self.customTV = [[CustomTextView alloc] initWithFrame:CGRectMake(10, 5, self.toolView.frame.size.width - 100, 40)];
        self.customTV = [[CustomTextView alloc] init];
        
        self.customTV.font = [UIFont systemFontOfSize:18];
        self.customTV.delegate = self;
        [self.toolView addSubview:self.customTV];
        [self.customTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.toolView.mas_top).mas_offset(5);
            make.left.mas_equalTo(self.audioBtn.mas_right).mas_offset(5);
            make.height.mas_equalTo(44);
            make.right.mas_equalTo(self.toolView.mas_right).mas_offset(-102);
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
        self.sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        self.sendBtn.frame = CGRectMake(toolFrame.size.width - 80, 5, 60, 40);
        [self.sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        self.sendBtn.backgroundColor = [UIColor whiteColor];
        [self.sendBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.sendBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.sendBtn.frame = CGRectMake(self.keyboardFrame.size.width - 44 - 5, 5, 44, 44);
        [self.toolView addSubview:self.sendBtn];
//        [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.toolView.mas_top).mas_offset(5);
//            make.width.mas_equalTo(44);
//            make.height.mas_equalTo(44);
//            make.right.mas_equalTo(self.toolView.mas_right).mas_offset(-5);
//        }];
    }
    
    if (!self.functionBtn) {
        self.functionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.functionBtn setTitle:@"十" forState:UIControlStateNormal];
        self.functionBtn.backgroundColor = [UIColor orangeColor];
        [self.functionBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.functionBtn addTarget:self action:@selector(addBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
        self.functionBtn.frame = CGRectMake(self.keyboardFrame.size.width - self.sendBtn.frame.size.width - 44 - 5 - 5, 5, 44, 44);
        [self.toolView addSubview:self.functionBtn];
//        [self.functionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.toolView.mas_top).mas_offset(5);
//            make.left.mas_equalTo(self.customTV.mas_right).mas_offset(5);
//            make.width.mas_equalTo(44);
//            make.height.mas_equalTo(44);
//
//        }];
    }
    
    
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.toolView.mas_bottom);
        make.left.mas_equalTo(self.mas_left);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.right.mas_equalTo(self.mas_right);
    }];
    self.scrollView.hidden = YES;
    
//    self.customKeyboardHeight = self.frame.size.height + 54;
//    openKeyboardFrame =  self.frame;
//    CGRect toolFrame = self.toolView.frame;
//    CGRect scrollView = self.scrollView.frame;
//    CGFloat height = SCREEN_HEIGHT;
//    openKeyboardFrame.origin.y = SCREEN_HEIGHT - self.toolView.frame.size.height - self.scrollView.frame.size.height - 44 - 10;
//    openKeyboardFrame.size.height = self.frame.size.height + self.toolFrame.size.height + self.scrollView.frame.size.height;
}

- (void)notificationRegister:(BOOL)flag{
    if (flag) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteTextViewData) name:DELETE_KEYBOARD_TEXT object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:DELETE_KEYBOARD_TEXT object:nil];
    }
}

- (void)switchAudioBtnAction{
    if (self.switchFlag) {
        [self.audioBtn setTitle:@"发送录音" forState:UIControlStateNormal];
    } else {
        [self.audioBtn setTitle:@"开始语音" forState:UIControlStateNormal];
    }
    if ([self.delegate respondsToSelector:@selector(KeyboardView:sendStatus:)]) {
        [self.delegate KeyboardView:self sendStatus:self.switchFlag];
    }
    self.switchFlag = !self.switchFlag;
}

- (void)addBtnClickAction{
    
    self.functionListSwitch = !self.functionListSwitch;
    if (self.functionListSwitch) {
        self.scrollView.hidden = NO;
        [self.functionBtn setTitle:@"键盘" forState:UIControlStateNormal];

        if([self.delegate respondsToSelector:@selector(KeyBoardView:addBtnPress:)])
        {
            [self.delegate KeyBoardView:self addBtnPress:self.functionBtn];
        }
        
        CGRect keyboardFrame = self.frame;
        CGFloat keyboardHeight = self.toolView.frame.size.height + keyboardFrame.size.width*self.collectionInRow/self.collectionInColumn;
        keyboardFrame.origin.y = SCREEN_HEIGHT - keyboardHeight;
        keyboardFrame.size.height = keyboardHeight;
        [self.customTV resignFirstResponder];
        if ([self.delegate respondsToSelector:@selector(KeyBoardViewHeightChange:)]) {
            [self.delegate KeyBoardViewHeightChange:keyboardFrame];
        }
    } else {
        self.scrollView.hidden = YES;
        [self.customTV becomeFirstResponder];
        [self.functionBtn setTitle:@"十" forState:UIControlStateNormal];
    }
}

- (void)sendBtnClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(KeyboardView:sendBtnClick:text:attribute:)]) {
        [self.delegate KeyboardView:self sendBtnClick:button text:self.customTV.text attribute:self.customTV.attributedText];
    }
}

- (void)deleteTextViewData{
    self.customTV.text = @"";
}

- (void)showSystemKeyboard:(BOOL)flag{
    if (flag) {
        self.scrollView.hidden = YES;
        self.functionListSwitch = NO;
        [self.functionBtn setTitle:@"十" forState:UIControlStateNormal];
    }
//    else {
//        self.scrollView.hidden = NO;
//        self.functionListSwitch = YES;
//        [self.functionBtn setTitle:@"键盘" forState:UIControlStateNormal];
//    }
}

- (void)keyboardHeightChange:(NSNotification *)notification{
    NSLog(@"==============");
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    CGRect customKeyboardFrame = self.frame;
    //CGRect toolFrame = self.toolView.frame;
    
    customKeyboardFrame.origin.y = keyboardRect.origin.y - self.toolFrame.size.height;
    customKeyboardFrame.size.height = keyboardRect.size.height + self.toolFrame.size.height;
    CGFloat height = SCREEN_HEIGHT;
    if (keyboardRect.origin.y < SCREEN_HEIGHT) {
        [self showSystemKeyboard:YES];
    }
    if ([self.delegate respondsToSelector:@selector(KeyBoardViewHeightChange:)]) {
        [self.delegate KeyBoardViewHeightChange:customKeyboardFrame];
    }
}

- (void)showAddCollectionViewithkeyboardType{
    [self initScroViewithkeyboard];
}

- (void)initScroViewithkeyboard{
    NSMutableArray *collectArr = [[NSMutableArray alloc] initWithCapacity:5];
    NSMutableArray *tagArr = [[NSMutableArray alloc] initWithCapacity:5];
    [collectArr addObject:@"照片"];
    [tagArr addObject:@"1"];
    [collectArr addObject:@"拍照"];
    [tagArr addObject:@"2"];
    [collectArr addObject:@"录像"];
    [tagArr addObject:@"3"];
    [collectArr addObject:@"地图"];
    [tagArr addObject:@"4"];
    
    self.currentIndex = 0;
    self.collectionInRow = 1;
    self.collectionInColumn = 4;
    //self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, self.bounds.size.width, self.bounds.size.height-44)];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    CGRect frame=CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    if (!self.collectionView) {
        CustomCollectionView *collectView = [[CustomCollectionView alloc] initWithFrame:frame collectionArray:collectArr tagArray:tagArr itemInRow:self.collectionInRow itemInColumn:self.collectionInColumn];
        collectView.delegate = self;
        self.collectionView = collectView;
        [self.scrollView addSubview:self.collectionView];
        [self addSubview:self.scrollView];
    }
    [self.collectionView.collectionView reloadData];
    
    
}
- (void)resignKeyboard{
    [self.customTV resignFirstResponder];
    [self resignFirstResponder];
    
}

-(void)CustomCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    NSIndexPath * index = [NSIndexPath indexPathForRow:indexPath.row inSection:self.currentIndex] ;
    if ([self.delegate respondsToSelector:@selector(KeyBoardViewCollectionView:didSelectItemAtIndexPath:cellTag:)]) {
        [self.delegate KeyBoardViewCollectionView:collectionView didSelectItemAtIndexPath:index cellTag:cell.tag];
    }
}


- (void)dealloc{
    [self notificationRegister:NO];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
