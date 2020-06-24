//
//  ChatRoomViewController.m
//  IMDemo
//
//  Created by Civet on 2020/4/15.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "ChatRoomViewController.h"
#import "KeyboardView.h"
#import "ChatRoomModel.h"
#import "ChatRecordModel.h"

@interface ChatRoomViewController ()<UITableViewDelegate,UITableViewDataSource,KeyboardViewDelegate,ChatRoomCellDelegate,CollectionViewDelegate,TZImagePickerControllerDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) KeyboardView *keyboard;
@property (nonatomic,strong) UITapGestureRecognizer *packUpKeyboard;
@property (nonatomic,strong) ChatRoomMenuView *chatRoomMenuView;
@property (nonatomic,strong) SuperChatRoomCell *currentCell;
@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,assign) BOOL isSelectOriginalPhoto;

@end

@implementation ChatRoomViewController

@synthesize tableView;
@synthesize chatRoomMenuView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    [self initData];
    //收起键盘手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    self.packUpKeyboard = tapGesture;
    [tableView addGestureRecognizer:self.packUpKeyboard];
    [self addNotification:YES];
}

- (void)initUI{
    self.tabBarController.tabBar.hidden = YES;
    if (self.rosterListModel!=nil) {
        [self.navigationItem setTitle:self.rosterListModel.nick];
    }
    //设置聊天室导航栏标题样式
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = [UIColor whiteColor];
    tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    UIView *backBtnView = [CommonComponentMethods setLeftBarItems:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtnView];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

- (void)initData{
    self.dataArr = [[NSMutableArray alloc] init];
    dispatch_queue_t getChatRoomMessageQueue = dispatch_queue_create("getChatRoomMessageQueue", NULL);
    dispatch_async(getChatRoomMessageQueue, ^{
        self.dataArr = [[FMDBOperation sharedDatabaseInstance] getChatRoomMessage:self.rosterListModel.uid];
        NSLog(@"============%@",[NSThread currentThread]);
        NSLog(@"============%@",self.dataArr);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self scrollToTableViewBottom];
        });
    });
}

- (void)addNotification:(BOOL)flag{
    if (flag) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:REFRESH_CHATROOM_MESSAGE object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:REFRESH_CHATROOM_MESSAGE object:nil];
    }
}

- (void)refreshTableView{
    [self initData];
    //[self scrollToTableViewBottom];
    //[tableView reloadData];
}

- (void)clickBackBtn{
    self.tabBarController.tabBar.hidden = NO;
//跳转回主界面
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[ChatRecordViewController class]] || [viewController isKindOfClass:[AddressViewController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
        }
    }
}

- (void)scrollToTableViewBottom{
    NSInteger sectionNumber = [tableView numberOfSections];  //有多少组
    if (sectionNumber<1) return;  //无数据时不执行 要不会crash
    NSInteger rowNumber = [tableView numberOfRowsInSection:sectionNumber-1]; //最后一组有多少行
    if (rowNumber<1) return;
    NSIndexPath *index = [NSIndexPath indexPathForRow:rowNumber-1 inSection:sectionNumber-1];  //取最后一行数据
    [tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"ChatRoomCell";
    
    ChatRoomModel *model = self.dataArr[indexPath.row];
    SuperChatRoomCell *Cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (model.messageType == Text) {
        static NSString *cellIdentifier = @"ChatRoomTextCell";
        Cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (Cell == nil) {
            Cell = [[ChatRoomTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
    }
    else if (model.messageType == Picture){
        static NSString *cellIdentifier = @"ChatRoomPictureCell";
        Cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (Cell == nil) {
            Cell = [[ChatRoomPictureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
    }
    else if(model.messageType == Audio){
        static NSString *cellIdentifier = @"ChatRoomAudioCell";
        Cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (Cell == nil) {
            Cell = [[ChatRoomAudioCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
    }
    Cell.delegate = self;
    Cell.chatRoomModel = model;
    [Cell configData];
    self.cellHeight = Cell.cellHeight;
    return Cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellHeight;
}

- (void)viewWillAppear:(BOOL)animated{
    [self addKeyBoard];
    [self changeTableViewHeight];
}

- (void)changeTableViewHeight{
    CGRect tableViewFrame = tableView.frame;
    //tableViewFrame.origin.y = NAVIGATION_AND_STATUSBAR_HEIGHT;
    tableViewFrame.size.height = self.keyboard.frame.origin.y - NAVIGATION_AND_STATUSBAR_HEIGHT;
    tableView.frame = tableViewFrame;
    
}

- (void)addKeyBoard{
    self.keyboard = [KeyboardView sharedInstance];
    self.keyboard.tag = 2020;
    self.keyboard.frame = CGRectMake(0, self.view.frame.size.height - 44 -SafeAreaBottom - 10, self.view.frame.size.width, 260);
    self.keyboard.delegate = self;
    self.keyboard.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.keyboard];
    
}

- (void)dismissKeyboard{
    [self.keyboard resignKeyboard];
}

-(void)KeyBoardViewHeightChange:(CGRect)keyboardFrame{
    [UIView animateWithDuration:0.25 animations:^{
        self.keyboard.frame = keyboardFrame;
    }];
    [self changeTableViewHeight];
}

- (void)KeyboardView:(KeyboardView *)keyboardView textFiledBegin:(UITextView *)textFiled{
    
}

//加号按钮
-(void)KeyBoardView:(KeyboardView *)keyBoardView addBtnPress:(UIButton *)sender{
    [keyBoardView showAddCollectionViewithkeyboardType];
}

//发送文本消息
-(void)KeyboardView:(KeyboardView *)keyboardView sendBtnClick:(UIButton *)sender text:(NSString *)text attribute:(NSAttributedString *)attr{
    NSString *string = text;
    if (text.length > 0) {
        if ([CommonMethods isEmptyString:text]) {
            return;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:DELETE_KEYBOARD_TEXT object:nil];
        ChatRoomModel *chatRoomModel = [[ChatRoomModel alloc] init];
        chatRoomModel.uId = self.rosterListModel.uid;
        chatRoomModel.roomId = self.rosterListModel.uid;
        chatRoomModel.userNick = self.rosterListModel.nick;
        chatRoomModel.messageFrom = CURRENTUSER;
        chatRoomModel.messageTo = self.rosterListModel.uid;
        chatRoomModel.messageType = Text;
        chatRoomModel.content = text;
        chatRoomModel.sendDate = [CommonMethods setDateFormat:[NSDate date]];
        
        [self sendMessageAndInsertDB:chatRoomModel messageType:Text isUploadFile:NO];
    }
}

//发送语音消息
-(void)KeyboardView:(KeyboardView *)keyboardView sendStatus:(BOOL)status{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = CHAT_MESSAGE_PATH;
    BOOL isExisted = [fileManager fileExistsAtPath:CHAT_MESSAGE_PATH];
    if (!isExisted) {
        [fileManager createDirectoryAtPath:CHAT_MESSAGE_PATH withIntermediateDirectories:YES attributes:nil error:nil];
    }
    static NSString *audioName = nil;
    
    AudioRecorder *audioRecorder = [AudioRecorder sharedInstance];
    if (status) {
        audioName = [NSString stringWithFormat:@"%@.aac",[CommonMethods getUUid]];
        NSString *audioPath = [CHAT_MESSAGE_PATH stringByAppendingPathComponent:audioName];
        [audioRecorder audioRecorderBegin:audioPath];
    } else {
        [audioRecorder audioRecorderStop];
        ChatRoomModel *chatRoomModel = [[ChatRoomModel alloc] init];
        chatRoomModel.uId = self.rosterListModel.uid;
        chatRoomModel.roomId = self.rosterListModel.uid;
        chatRoomModel.userNick = self.rosterListModel.nick;
        chatRoomModel.messageFrom = CURRENTUSER;
        chatRoomModel.messageTo = self.rosterListModel.uid;
        chatRoomModel.messageType = Audio;
        chatRoomModel.content = audioName;
        chatRoomModel.sendDate = [CommonMethods setDateFormat:[NSDate date]];
        [self sendMessageAndInsertDB:chatRoomModel messageType:Audio isUploadFile:NO];
    }
}

//发送和存储消息
- (void)sendMessageAndInsertDB:(ChatRoomModel *)chatRoomModel messageType:(enum MessageType)type isUploadFile:(BOOL)isUpload{
    dispatch_queue_t dispatchQueue = dispatch_queue_create("SendDataAndInsertDB", nil);
    dispatch_async(dispatchQueue, ^{
        ChatRecordModel *chatRecordModel = [[ChatRecordModel alloc] init];
        
        chatRecordModel.uId = chatRoomModel.uId;
        chatRecordModel.roomId = chatRoomModel.roomId;
        chatRecordModel.userNick = chatRoomModel.userNick;
        chatRecordModel.messageFrom = chatRoomModel.messageFrom;
        chatRecordModel.messageTo = chatRoomModel.messageTo;
        chatRecordModel.messageType = chatRoomModel.messageType;
        chatRecordModel.content = chatRoomModel.content;
        chatRecordModel.sendDate = chatRoomModel.sendDate;
        
        switch (type) {
            case Text:
                break;
            case Picture:
                chatRecordModel.content = @"[图片]";
                break;
            case Audio:
                chatRecordModel.content = @"[语音]";
                break;
                
            default:
                break;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            FMDBOperation *dbOperation = [FMDBOperation sharedDatabaseInstance];
            [dbOperation insertChatMessage:chatRoomModel];
            [dbOperation insertChatRecord:chatRecordModel];
            
            if (type == Text) {
                [self sendMessageToServer:chatRoomModel];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_CHATROOM_MESSAGE object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_CHAT_RECORD object:nil];
        });

    });
}

- (void)sendMessageToServer:(ChatRoomModel *)model{
    XmppManager *xmppManager = [XmppManager sharedInstance];
    
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:model.content];
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    NSString *to = [NSString stringWithFormat:@"%@@%@", model.uId,SERVER_DOMAIN];
    [message addAttributeWithName:@"from" stringValue:model.messageFrom];
    [message addAttributeWithName:@"to" stringValue:to];
    [message addAttributeWithName:@"sendDate" stringValue:model.sendDate];
    [message addChild:body];
    [xmppManager.xmppStream sendElement:message];
}

//响应单击事件
- (void)chatRoomCellContentSingleTapAction:(SuperChatRoomCell *)superCell type:(enum MessageType)type filePath:(NSString *)filePath{
    switch (type) {
        case Picture:
            [self entryPictureDetailViewController:superCell.chatRoomModel];
            break;
            
        default:
            break;
    }
}

- (void)entryPictureDetailViewController:(ChatRoomModel *)chatRoomModel{
    ImageScrollViewController *imageScrollVC = [[ImageScrollViewController alloc] init];
    
    NSData *data = [chatRoomModel.thumbnail base64DecodedData];
    UIImage *thumbnailImage = [UIImage imageWithData:data];
    
    NSString *orignalPicturePath = CHAT_FILE_PATH(chatRoomModel.content);
    UIImage *localImage = [CommonMethods getImageFromPath:orignalPicturePath];
    
    if (localImage != nil) {
        //[imageScrollVC setScrollViewContent:localImage];
        imageScrollVC.image = localImage;
    } else {
        //[imageScrollVC setScrollViewContent:thumbnailImage];
        imageScrollVC.image = thumbnailImage;
    }
    [self.navigationController pushViewController:imageScrollVC animated:YES];
}

- (void)chatRoomTableViewCellLongPress:(SuperChatRoomCell *)chatRoomCell type:(enum MessageType)type content:(NSString *)content{
    NSString *roomID = chatRoomCell.chatRoomModel.roomId;
    self.currentCell = chatRoomCell;
    chatRoomMenuView = [[ChatRoomMenuView alloc] initWithFrame:self.view.bounds viewController:self];
    self.chatRoomMenuView.delegate = self;
    //长按后调整键盘和tableView高度
    [self dismissKeyboard];
    [self changeTableViewHeight];
}

- (void)didSelectedItem:(NSMutableArray *)functionArr atIndexPath:(NSIndexPath *)indexPath{
    NSString *functionName = [functionArr objectAtIndex:indexPath.row];
    if ([functionName isEqualToString:@"删除"]) {
        [self deleteMessageCell];
    }
}

- (void)deleteMessageCell{
    NSString *jid = self.currentCell.chatRoomModel.jId;
    enum MessageType messageType = self.currentCell.chatRoomModel.messageType;
    if ([[FMDBOperation sharedDatabaseInstance] deleteChatRoomMessage:jid]) {
        [self.dataArr removeObject:self.currentCell.chatRoomModel];
        if (messageType == Audio) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *audioPath = [CHAT_MESSAGE_PATH stringByAppendingPathComponent:self.currentCell.chatRoomModel.content];
            if ([fileManager fileExistsAtPath:audioPath]) {
                BOOL flag = [fileManager removeItemAtPath:audioPath error:nil];
                if (flag) {
                    NSLog(@"录音删除成功");
                } else {
                    NSLog(@"录音删除失败");
                }
            }
        }
        [self reloadTableView];
    }
    
}

- (void)reloadTableView{
    [tableView reloadData];
}

//聊天collection
-(void)KeyBoardViewCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath cellTag:(NSInteger)tag{
    switch (tag) {
        case 1:
            [self pickImageFromPhotoAlbum];
            break;
        case 2:
            break;
        case 3:
            break;
        case 4:
            
            
            break;
        default:
            break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:RESIGNKEYBOARD object:nil];
}

- (NSMutableArray *)selectOriginImageArr{
    if (!_selectOriginImageArr) {
        _selectOriginImageArr = [[NSMutableArray alloc] init];
    }
    return _selectOriginImageArr;
}

- (void)pickImageFromPhotoAlbum{
    TZImagePickerController *imagePickerC = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerC.videoMaximumDuration = 10;//视频最大拍摄时间
    [imagePickerC setUiImagePickerControllerSettingBlock:^(UIImagePickerController *imagePickerController) {
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    }];
    
    [imagePickerC setPhotoPreviewPageUIConfigBlock:^(UICollectionView *collectionView, UIView *naviBar, UIButton *backButton, UIButton *selectButton, UILabel *indexLabel, UIView *toolBar, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel) {
        [doneButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }];
    
    // 是否显示可选原图按钮
    imagePickerC.allowPickingOriginalPhoto = NO;
    //设置是否可以选择图片/视频/原图
    imagePickerC.allowPickingImage = YES;
    imagePickerC.allowPickingVideo = YES;
    imagePickerC.allowPickingMultipleVideo = YES;
    imagePickerC.allowPickingOriginalPhoto = YES;
    imagePickerC.showSelectBtn = YES;
    
    //照片按时间升序排列
    imagePickerC.sortAscendingByModificationDate = YES;
//    imagePickerC.statusBarStyle = UIStatusBarStyleLightContent;
    // 这是一个navigation 只能present
    // 设置 模态弹出模式。 iOS 13默认非全屏
    imagePickerC.modalPresentationStyle = UIModalPresentationFullScreen;
    //访问相册手机授权
    [UserAuthorization getPhotoAlbumAuthorization:self completionBlock:^{
        [self presentViewController:imagePickerC animated:YES completion:nil];
    }];
}

// 选择照片的回调
-(void)imagePickerController:(TZImagePickerController *)picker
      didFinishPickingPhotos:(NSArray<UIImage *> *)photos
                sourceAssets:(NSArray *)assets
       isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    for (PHAsset *asset in assets) {
        _isSelectOriginalPhoto = isSelectOriginalPhoto;
        NSString *fileName = [asset valueForKey:@"filename"];
        if ([fileName hasSuffix:@"JPG"] || [fileName hasSuffix:@"PNG"] || [fileName hasSuffix:@"GIF"]) {
            if (isSelectOriginalPhoto) {
                NSMutableArray *photoArr = [photos mutableCopy];
                self.selectOriginImageArr = photoArr;
            }
            [self sendAndSavePictureData:asset];
        }
    }
}

- (void)sendAndSavePictureData:(PHAsset *)asset{
    ChatRoomModel *chatRoomModel = [[ChatRoomModel alloc] init];
    
    NSString *fileName = [asset valueForKey:@"filename"];
    
    chatRoomModel.uId = self.rosterListModel.uid;
    chatRoomModel.roomId = self.rosterListModel.uid;
    chatRoomModel.userNick = self.rosterListModel.nick;
    chatRoomModel.messageFrom = CURRENTUSER;
    chatRoomModel.messageTo = self.rosterListModel.uid;
    chatRoomModel.messageType = Picture;
    chatRoomModel.contactType = @"owner";
    chatRoomModel.content = fileName;
    chatRoomModel.isOriginalPic = _isSelectOriginalPhoto ;
    chatRoomModel.sendDate = [CommonMethods setDateFormat:[NSDate date]];
    
    chatRoomModel.imageAsset = asset;
    
    //从数组中取出原图 并获取原图的大小
    for ( UIImage *selectOriginalImage in self.selectOriginImageArr){
        CGSize size = selectOriginalImage.size;
        //原圖
        if (_isSelectOriginalPhoto)
        {
            if ((size.width * size.height) > 1000000)
            {
                double scal = sqrt(1000000/(size.width * size.height));
                size = CGSizeMake(size.width * scal, size.height * scal);
            }
            chatRoomModel.oriImageWidth = size.width;
            chatRoomModel.oriImageHeight = size.height;
        }
    }
    
    //获取图片
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeExact;
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        float imageSize = imageData.length;
        chatRoomModel.imageSize = imageSize;
        NSString *imageName = [chatRoomModel.content lastPathComponent];
        if (chatRoomModel.isOriginalPic) {
            UIImage *image = [UIImage imageWithData:imageData];
            UIImage *newImage = [UIImage changeImageOrientation:image];
            NSData *data = UIImageJPEGRepresentation(newImage, 1.0);
            chatRoomModel.imageSize = data.length;
            [CommonMethods saveOriginalImageToPath:CHAT_FILE_PATH(imageName) image:data];
        }
        if (chatRoomModel.messageType != Gif) {
            //取出asset中的图片
            UIImage *image = [UIImage imageWithData:imageData];
            CGImageRef ref = [image CGImage];
            UIImage *newImage = [UIImage imageWithCGImage:ref scale:1.0 orientation:orientation];
            //压缩到指定像素
            UIImage *newThumbnailImg = [newImage compressQualityWithPixelLimit:133]; //指定大小為133x133
            //压缩图片到d指定大小
            NSData *thumbnailData = [newThumbnailImg compressMidQualityWithLengthLimit:1024*2]; //压缩到2kb
            NSString *imageMessage = [thumbnailData base64EncodedString];
            chatRoomModel.thumbnail=imageMessage;
        }
        //插入DB
        [self sendMessageAndInsertDB:chatRoomModel messageType:chatRoomModel.messageType isUploadFile:YES];
    }];
}

- (void)dealloc{
    [self addNotification:NO];
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
