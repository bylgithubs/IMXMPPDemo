//
//  ImageScrollViewController.m
//  IMXMPPDemo
//
//  Created by Civet on 2020/6/23.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "ImageScrollViewController.h"

@interface ImageScrollViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) AVPlayerViewController *avPlayVC;

@end

@implementation ImageScrollViewController
@synthesize scrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //定义并且创建一个滚动视图
    //可以对视图内容进行滚屏查看功能
    scrollView = [[UIScrollView alloc] init];
    //设置滚动视图的位置，使用矩形来定位视图位置
    scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    //是否按照整页来滚动视图
    scrollView.pagingEnabled = YES;
    //是否开启滚动效果
    scrollView.scrollEnabled = YES;
    //设置画布大小，画布显示在滚动视图内部，一般大于Frame的大小
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    //是否可以边缘弹动效果
    scrollView.bounces = YES;
    //开启横向弹动效果
    scrollView.alwaysBounceHorizontal = YES;
    //开启纵向弹动效果
    scrollView.alwaysBounceVertical = YES;
    //显示横向滚动条
    scrollView.showsHorizontalScrollIndicator = YES;
    //是否显示纵向滚动条
    scrollView.showsVerticalScrollIndicator = YES;
    //设置背景颜色
    scrollView.backgroundColor = [UIColor whiteColor];
    
    [self setScrollViewContent:self.image];
    
    [self.view addSubview:scrollView];
    
    if (!self.playBtn && self.mediaModel.messageType == Video) {
        self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.playBtn.frame = CGRectMake(SCREEN_WIDTH/2 - 40, SCREEN_HEIGHT/2 - 30, 80, 60);
        [self.playBtn setTitle:@"播放" forState:UIControlStateNormal];
        [self.playBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self.playBtn addTarget:self action:@selector(playVideoAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.playBtn];
    }
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction)];
    [self.view addGestureRecognizer:singleTap];
    
}

- (void)singleTapAction{
    [self.navigationController popViewControllerAnimated:YES];
}

//设置视图内容
- (void)setScrollViewContent:(UIImage *)image{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [scrollView addSubview:imageView];
}

- (void)playVideoAction{
    ChatRoomModel *model = _mediaModel;
    NSString *videoPath = CHAT_FILE_PATH(_mediaModel.localFileName);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handDeviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    AVPlayer *avPlayer = [AVPlayer playerWithURL:[NSURL fileURLWithPath:videoPath]];
    //视频控制器对象
    AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
    //控制器设置播放器对象
    playerViewController.player = avPlayer;
    //视图填充模式
    playerViewController.videoGravity = AVLayerVideoGravityResizeAspect;
    //是否显示播放控制条
    playerViewController.showsPlaybackControls = YES;
    self.avPlayVC = playerViewController;
    self.avPlayVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self presentViewController:self.avPlayVC animated:NO completion:nil];
    [self.avPlayVC.player play];
}

- (void)handDeviceOrientationDidChange:(UIInterfaceOrientation)ratation{
    UIDevice *currentDvc = [UIDevice currentDevice];
    switch (currentDvc.orientation) {
        case UIDeviceOrientationUnknown:
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
            break;
        default:
            break;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
