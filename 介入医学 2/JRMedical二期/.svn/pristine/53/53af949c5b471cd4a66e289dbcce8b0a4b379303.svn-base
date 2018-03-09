//
//  PublishedPostVC.m
//  JRMedical
//
//  Created by a on 16/12/8.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "PublishedPostVC.h"

#import "KMButton.h"
#import "IQTextView.h"
#import "IQKeyboardManager.h"
#import "PostTypeVC.h"

#import "JRLoginViewController.h"

#import "UzysAssetsPickerController.h"
#import "imageShowCollectModel.h"
#import "ImageShowCollectCell.h"
#import "WechatShortVideoController.h"
#import <YYKit.h>

@interface PublishedPostVC ()<UzysAssetsPickerControllerDelegate,WechatShortVideoDelegate,UICollectionViewDelegate, UICollectionViewDataSource,UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UIScrollView *viewSV;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *lineView2;
@property (nonatomic, strong) UIImageView *rightImg;
@property (nonatomic, strong) UITextField *titleTF;
@property (nonatomic, strong) UILabel *postTypeLab;
@property (nonatomic, strong) IQTextView *textView;

@property (nonatomic, strong) NSMutableArray *typeListArray;
@property (nonatomic, strong) NSMutableArray *imgVideoList;

@property (nonatomic, assign) NSInteger curSelectdItem;

@property (nonatomic, strong) NSMutableArray *numPics;

//添加视频图片
@property (nonatomic, strong) UICollectionView *imageCollectView;
@property (nonatomic, strong) UIView *botView;
@property (nonatomic, strong) UIButton *selectImg;
@property (nonatomic, strong) UIButton *selectVideo;

@end

@implementation PublishedPostVC {
    
    CGFloat height;
    NSMutableArray *_spArray;
    NSMutableArray *_picArray;
    NSMutableArray *_passArray;
    
    NSString *_valueType;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PublishrdPostTypeRefreshDataAfterSorting" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发布帖子";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataSource = [NSMutableArray arrayWithCapacity:0];
    _picArray = [NSMutableArray arrayWithCapacity:0];
    _spArray = [NSMutableArray arrayWithCapacity:0];
    self.numPics = [NSMutableArray arrayWithCapacity:0];
    self.imgVideoList = [NSMutableArray arrayWithCapacity:0];
    
    self.curSelectdItem = 99999;//默认进入帖子类型不选中任何类型
    
    [self setNavBarButtonItem];//设置顶栏右侧按钮
    [self initView];//初始化视图
    
    //选择分类下的分类后刷新数据的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PublishrdPostTypeRefreshDataAfterSorting:) name:@"PublishrdPostTypeRefreshDataAfterSorting" object:nil];
    
    //监听键盘状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //添加帖子类型
    [self.postTypeLab bk_whenTapped:^{
        
        //此处判断是为了只请求一次数据即可
        if (self.typeListArray.count > 0) {
            PostTypeVC *ptVC = [PostTypeVC new];
            ptVC.typeListArray = self.typeListArray;
            ptVC.curSelectdItem = self.curSelectdItem;
            NSLog(@"%ld",self.curSelectdItem);
            BaseNavigationController *ptNC = [[BaseNavigationController alloc] initWithRootViewController:ptVC];
            [self presentViewController:ptNC animated:YES completion:nil];
        }
        else {
            [self requestCategoryData];//获取帖子类型
        }
    }];
}

#pragma mark - 选择分类下的分类后刷新数据的通知
- (void)PublishrdPostTypeRefreshDataAfterSorting:(NSNotification *)sender {
    
    //当前选择的 分类
    self.curSelectdItem = [sender.userInfo[@"CurSelectdItemPost"] integerValue];
    
    NSLog(@"%ld",self.curSelectdItem);
    
    NSDictionary *dic = self.typeListArray[self.curSelectdItem];
    
    self.postTypeLab.text = dic[@"Name"];
    self.postTypeLab.textColor = [UIColor blackColor];
    
    _valueType = dic[@"Value"];
}

#pragma mark - keyBoard已经上去
- (void)keyboardDidShow:(NSNotification *)notification
{
    
    // 拿到键盘弹出时间
    double duration = [notification.userInfo[
                                             UIKeyboardAnimationDurationUserInfoKey
                                             ] doubleValue];
    
    NSValue* aValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:keyboardRect fromView:[[UIApplication sharedApplication] keyWindow]];
    CGFloat keyboardHeight = keyboardFrame.size.height;
    height = keyboardHeight;
    
    [UIView animateWithDuration:duration animations:^{
        self.botView.frame = CGRectMake(0, Height_Screen-108-height, Width_Screen, 44);
    }];
}

#pragma mark - keyBoard已经下去
- (void)keyboardDidHide:(NSNotification *)notification {
    
    // 拿到键盘弹出时间
    double duration = [notification.userInfo[
                                             UIKeyboardAnimationDurationUserInfoKey
                                             ] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.botView.frame = CGRectMake(0, Height_Screen-108, Width_Screen, 44);
    }];
}

#pragma mark - 获取分类数据
- (void)requestCategoryData {
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCGroupCode=%@",@"SocialPost"];
    NSString *url = @"api/News/TypeList";
    
    [self showLoadding:@"" time:20];
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"获取分类 - %@",modelData);
        if (isSuccess) {
            
            NSArray *array = modelData[@"JsonData"];
            self.typeListArray = [NSMutableArray arrayWithArray:array];
            
            PostTypeVC *ptVC = [PostTypeVC new];
            ptVC.typeListArray = self.typeListArray;
            ptVC.curSelectdItem = self.curSelectdItem;
            BaseNavigationController *ptNC = [[BaseNavigationController alloc] initWithRootViewController:ptVC];
            [self presentViewController:ptNC animated:YES completion:nil];
        }
        else {
            NSString *msg  = [modelData objectForKey:@"Msg"];
            if (msg!=nil && ![msg isEqual:@""]) {
                [self showMessage:msg];
            }
            else {
                [self showMessage:[NSString stringWithFormat:@"请求失败 #%d",code]];
            }
        }
    }];
}

#pragma mark - 添加
- (void)navBarButtonItemClick {
    [self startPublishedPost];
}

#pragma mark - 初始化视图
- (void)initView {
    
    [self.view addSubview:self.viewSV];
    [self.viewSV addSubview:self.titleTF];
    [self.viewSV addSubview:self.lineView];
    [self.viewSV addSubview:self.lineView2];
    [self.viewSV addSubview:self.rightImg];
    [self.viewSV addSubview:self.postTypeLab];
    [self.viewSV addSubview:self.textView];
    [self.viewSV addSubview:self.imageCollectView];
    
    [self.view addSubview:self.botView];
    [self.botView addSubview:self.selectImg];
    [self.botView addSubview:self.selectVideo];
    
    self.viewSV.sd_layout.widthIs(Width_Screen).heightIs(Height_Screen);
    self.viewSV.contentSize = CGSizeMake(Width_Screen, Height_Screen);
    
    self.titleTF.sd_layout.topSpaceToView(self.viewSV,10).leftSpaceToView(self.viewSV,18).rightSpaceToView(self.viewSV,18).heightIs(40);
    
    self.lineView.sd_layout.topSpaceToView(self.titleTF,5).leftSpaceToView(self.viewSV,10).rightSpaceToView(self.viewSV,10).heightIs(0.6);
    
    self.rightImg.sd_layout.topSpaceToView(self.lineView,16).rightSpaceToView(self.viewSV,15).widthIs(10).heightIs(18);
    
    self.postTypeLab.sd_layout.topSpaceToView(self.lineView,5).leftSpaceToView(self.viewSV,18).rightSpaceToView(self.viewSV,10).heightIs(40);
    
    self.lineView2.sd_layout.topSpaceToView(self.postTypeLab,5).leftSpaceToView(self.viewSV,10).rightSpaceToView(self.viewSV,10).heightIs(0.6);
    
    self.textView.sd_layout.topSpaceToView(self.lineView2,10).leftSpaceToView(self.viewSV,10).rightSpaceToView(self.viewSV,10).heightIs(250);
    
    self.imageCollectView.sd_layout.topSpaceToView(self.textView,10).leftSpaceToView(self.viewSV,8).rightSpaceToView(self.viewSV,8).heightIs(80);
    
    self.selectImg.sd_layout.leftSpaceToView(self.botView,30).centerYEqualToView(self.botView).widthIs(30).heightIs(30);
    self.selectVideo.sd_layout.leftSpaceToView(self.selectImg,30).centerYEqualToView(self.botView).widthIs(30).heightIs(30);
}

#pragma mark - 懒加载
- (UIScrollView *)viewSV {
    if (!_viewSV) {
        _viewSV = [UIScrollView new];
        _viewSV.backgroundColor = [UIColor whiteColor];
    }
    return _viewSV;
}
- (UICollectionView *)imageCollectView {
    if (!_imageCollectView) {
        
        UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
        flowLayOut.itemSize = CGSizeMake(80, 80);
        flowLayOut.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
        flowLayOut.minimumLineSpacing = 5;
        flowLayOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _imageCollectView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayOut];
        _imageCollectView.delegate = self;
        _imageCollectView.dataSource = self;
        _imageCollectView.backgroundColor = [UIColor whiteColor];
        _imageCollectView.showsVerticalScrollIndicator = NO;
        _imageCollectView.showsHorizontalScrollIndicator = NO;
        [self.imageCollectView registerNib:[UINib nibWithNibName:@"ImageShowCollectCell" bundle:nil] forCellWithReuseIdentifier:@"itemCell"];
    }
    return _imageCollectView;
}
- (UITextField *)titleTF {
    if (!_titleTF) {
        _titleTF = [UITextField new];
        _titleTF.backgroundColor = [UIColor whiteColor];
        _titleTF.delegate = self;
        _titleTF.returnKeyType   = UIReturnKeyDone;
        _titleTF.placeholder = @"帖子标题";
        _titleTF.font = [UIFont systemFontOfSize:15];
    }
    return _titleTF;
}
- (UILabel *)postTypeLab {
    if (!_postTypeLab) {
        _postTypeLab = [UILabel new];
        _postTypeLab.text = @"帖子类型";
        _postTypeLab.userInteractionEnabled = YES;
        _postTypeLab.textColor = RGB(200, 200, 200);
        _postTypeLab.font = [UIFont systemFontOfSize:15];
    }
    return _postTypeLab;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = RGB(200, 200, 200);
    }
    return _lineView;
}
- (UIView *)lineView2 {
    if (!_lineView2) {
        _lineView2 = [UIView new];
        _lineView2.backgroundColor = RGB(200, 200, 200);
    }
    return _lineView2;
}
- (UIImageView *)rightImg {
    if (!_rightImg) {
        _rightImg = [UIImageView new];//12  22
        _rightImg.image = [UIImage imageNamed:@"yougengduo"];
    }
    return _rightImg;
}
- (UIButton *)selectImg {
    if (!_selectImg) {
        _selectImg = [UIButton buttonWithType:UIButtonTypeCustom];//50  50
        [_selectImg setImage:[UIImage imageNamed:@"tupian"] forState:UIControlStateNormal];
        _selectImg.tag = 1001;
        [_selectImg addTarget:self action:@selector(currentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectImg;
}
- (UIButton *)selectVideo {
    if (!_selectVideo) {
        _selectVideo = [UIButton buttonWithType:UIButtonTypeCustom];//50  50
        [_selectVideo setImage:[UIImage imageNamed:@"013shexiangji"] forState:UIControlStateNormal];
        _selectVideo.tag = 1002;
        [_selectVideo addTarget:self action:@selector(currentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectVideo;
}
- (UIView *)botView {
    if (!_botView) {
        _botView = [[UIView alloc] initWithFrame:CGRectMake(0, Height_Screen-108, Width_Screen, 44)];//50  50
        _botView.backgroundColor = BG_Color;
        _botView.layer.shadowColor = RGB(100, 100, 100).CGColor;//阴影颜色
        _botView.layer.shadowOffset = CGSizeMake(0 , 1);//偏移距离
        _botView.layer.shadowOpacity = 0.5;//不透明度
        _botView.layer.shadowRadius = 3.0;//半径
    }
    return _botView;
}
- (IQTextView *)textView {
    if (!_textView) {
        _textView = [IQTextView new];
        _textView.placeholder = @"详细内容";
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.layer.borderColor = RGB(200, 200, 200).CGColor;
        _textView.layer.cornerRadius = 5;
        _textView.clipsToBounds = YES;
        _textView.layer.borderWidth = 0.6;
        _textView.delegate = self;
    }
    return _textView;
}

#pragma mark -
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 设置顶栏右侧按钮
- (void)setNavBarButtonItem {
    
    KMButton *imgBtn = [KMButton buttonWithType:UIButtonTypeSystem];
    imgBtn.spacing = 5;
    imgBtn.kMButtonType = KMButtonLeft;
    imgBtn.size = CGSizeMake(65, 44);
    imgBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [imgBtn setTitle:@"发送" forState:UIControlStateNormal];
    [imgBtn setImage:[UIImage imageNamed:@"fatiez"] forState:UIControlStateNormal];
    [imgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [imgBtn setTintColor:[UIColor whiteColor]];
    [imgBtn addTarget:self action:@selector(navBarButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imgBtn];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self.textView isExclusiveTouch]) {
        [_textView resignFirstResponder];
    }
}

#pragma mark - UICollectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ImageShowCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"itemCell" forIndexPath:indexPath];
    
    imageShowCollectModel *model = self.dataSource[indexPath.row];
    
    [cell setDataForSubViewWithModel:model];
    
    [cell.picDeleteBtn addTarget:self action:@selector(deleChooosedPic:) forControlEvents:(UIControlEventTouchUpInside)];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击图片item");
}

- (void)deleChooosedPic:(UIButton *)sender {
    
    NSLog(@"移除选择的图片");
    
    ImageShowCollectCell *cell = (ImageShowCollectCell *)sender.superview.superview;
    
    NSIndexPath *indexPath = [self.imageCollectView indexPathForCell:cell];
    
    imageShowCollectModel *model = self.dataSource[indexPath.row];
    
    // 从数据源清除
    [self.dataSource removeObject:model];
    // 刷新UI
    [self.imageCollectView reloadData];
}

#pragma mark-----触发事件------
- (void)currentBtnClick:(UIButton *)sender {
    
    if (self.dataSource.count == 9) {
        return [self showMessage:@"最多只能添加9个附件!"];
    }
    
    if (sender.tag == 1001) {//添加图片按钮
        
        UzysAssetsPickerController *picker = [[UzysAssetsPickerController alloc] init];
        picker.delegate = self;
        picker.maximumNumberOfSelectionVideo = 0;
        
        switch (self.dataSource.count) {
            case 0:
                picker.maximumNumberOfSelectionPhoto = 9;
                break;
            case 1:
                picker.maximumNumberOfSelectionPhoto = 8;
                break;
            case 2:
                picker.maximumNumberOfSelectionPhoto = 7;
                break;
            case 3:
                picker.maximumNumberOfSelectionPhoto = 6;
                break;
            case 4:
                picker.maximumNumberOfSelectionPhoto = 5;
                break;
            case 5:
                picker.maximumNumberOfSelectionPhoto = 4;
                break;
            case 6:
                picker.maximumNumberOfSelectionPhoto = 3;
                break;
            case 7:
                picker.maximumNumberOfSelectionPhoto = 2;
                break;
            case 8:
                picker.maximumNumberOfSelectionPhoto = 1;
                break;
            default:
                break;
        }
        
        [self presentViewController:picker animated:YES completion:^{}];
    }
    else if (sender.tag == 1002) {//选择视频按钮
        WechatShortVideoController *wechatShortVideoController = [[WechatShortVideoController alloc] init];
        wechatShortVideoController.isLong = YES;
        wechatShortVideoController.delegate = self;
        [self presentViewController:wechatShortVideoController animated:YES completion:^{}];
    }
}

#pragma mark---------选择图片------------
- (void)uzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [self showLoadding:@"" time:20];
    
    [_picArray removeAllObjects];
    
    [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        ALAsset *representation = obj;
        UIImage *img = [UIImage imageWithCGImage:representation.defaultRepresentation.fullResolutionImage
                                           scale:representation.defaultRepresentation.scale
                                     orientation:(UIImageOrientation)representation.defaultRepresentation.orientation];
        UIImage *newImg =  [self fixOrientation:img];
        [_picArray addObject:newImg];
        NSLog(@"添加图片--%@", _picArray);
        *stop = NO;
    }];
    [self.hud hide:YES];
    [self chooPicSucceed];
}

- (void)uzysAssetsPickerControllerDidExceedMaximumNumberOfSelection:(UzysAssetsPickerController *)picker {
    NSLog(@"嘿嘿");
}

- (void)chooPicSucceed {
    
    [self showLoadding:@"正在处理" time:1000];
    
    if (self.numPics.count > 0) {
        [self.numPics removeAllObjects];
    }
    
    for (UIImage *image in _picArray) {
        [self uploadImage:image];//上传图片
    }
}

- (void)finishWechatShortVideoCapture:(NSURL *)filePath {
    [self yaSuoShiPinWithfilepath:filePath];
}

- (UIImage *)firstFrameWithVideoURL:(NSURL *)url size:(CGSize)size
{
    // 获取视频第一帧
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    generator.appliesPreferredTrackTransform = YES;
    generator.maximumSize = CGSizeMake(size.width, size.height);
    NSError *error = nil;
    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(0, 10) actualTime:NULL error:&error];
    if (error == nil)
    {
        return [UIImage imageWithCGImage:img];
    }
    return nil;
}


- (void)yaSuoShiPinWithfilepath:(NSURL *)filepath {
    NSString *outPath = [self creatSandBoxFilePathIfNoExist];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:filepath options:nil];
    AVAssetExportSession *exportSession= [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    exportSession.shouldOptimizeForNetworkUse = YES;
    exportSession.outputURL = [NSURL fileURLWithPath:outPath];
    exportSession.outputFileType = AVFileTypeMPEG4;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        int exportStatus = exportSession.status;
        //       NSLog(@"%d",exportStatus);
        switch (exportStatus)
        {
            case AVAssetExportSessionStatusFailed:
            {
                // log error to text view
                NSError *exportError = exportSession.error;
                NSLog (@"AVAssetExportSessionStatusFailed: %@", exportError);
                break;
            }
            case AVAssetExportSessionStatusCompleted:
            {
                //                NSLog(@"视频转码成功");
                NSData *data = [NSData dataWithContentsOfFile:outPath];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:^{
                        [self uploadVideo:data];//上传视频
                    }];
                });
            }
        }
    }];
}

- (NSString *)creatSandBoxFilePathIfNoExist {
    
    //沙盒路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSLog(@"databse--->%@",documentDirectory);
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];// 用时间, 给文件重新命名, 防止视频存储覆盖,
    [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    //创建目录
    NSString *createPath = [NSString stringWithFormat:@"%@/Video", pathDocuments];
    // 判断文件夹是否存在，如果不存在，则创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    } else {
        NSLog(@"FileImage is exists.");
    }
    NSString *resultPath = [createPath stringByAppendingPathComponent:[NSString stringWithFormat:@"outputJFVideo-%@.mov", [formater stringFromDate:[NSDate date]]]];
    
    return resultPath;
}

- (UIImage *)fixOrientation:(UIImage *)aImage {
    UIImageOrientation imageOrientation = aImage.imageOrientation;
    if(imageOrientation != UIImageOrientationUp)
    {
        //原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
        // 以下为调整图片角度的部分
        UIGraphicsBeginImageContext(aImage.size);
        [aImage drawInRect:CGRectMake(0, 0, aImage.size.width, aImage.size.height)];
        aImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        // 调整图片角度完毕
    }
    return aImage;
}

#pragma mark - 发帖
- (void)startPublishedPost {
    
    [self.titleTF endEditing:YES];
    [self.textView endEditing:YES];
    
    if ([self.titleTF.text isEqualToString:@""] || self.titleTF.text == nil) {
        return [self showMessage:@"帖子标题不能为空"];
    }
    
    if ([self.postTypeLab.text isEqualToString:@"帖子类型"] || self.postTypeLab.text == nil) {
        return [self showMessage:@"请选择帖子类型"];
    }
    
    if ([self.dataSource count] > 0 ||  ![self.textView.text isEqualToString:@""]) {
        
        //将上传的 图片 视频 资源 转成json上传
        NSString *imgVideoJsonStr = @"";
        if ([self.dataSource count] > 0) {
            [self.imgVideoList removeAllObjects];
            for (imageShowCollectModel *collectModel in self.dataSource) {
                
                if ([collectModel.type isEqualToString:@"pic"]) {
                    //图片
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    [dic setObject:collectModel.ImgUri forKey:@"ImagePic"];
                    [dic setObject:@"0" forKey:@"Type"];
                    [dic setObject:@"" forKey:@"Uri"];
                    [self.imgVideoList addObject:dic];
                }
                else {
                    //视频
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    [dic setObject:collectModel.ImgUri forKey:@"ImagePic"];
                    [dic setObject:@"1" forKey:@"Type"];
                    [dic setObject:collectModel.videoUrl forKey:@"Uri"];
                    [self.imgVideoList addObject:dic];
                }
            }
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.imgVideoList options:0 error:nil];
            imgVideoJsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        
        NSString *params = [NSString stringWithFormat:@"ZICBDYCContent=%@ZICBDYCDictType=%@ZICBDYCTitle=%@ZICBDYCPicList=%@",self.textView.text,_valueType,self.titleTF.text,imgVideoJsonStr];
        NSString *url = @"api/Post/CreatePost";
        
        [self showLoadding:@"正在发布" time:1000];
        
        [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
            NSLog(@"发帖提交图片/视频 - responseObject - %@---%@", modelData, modelData[@"Msg"]);
            if (isSuccess) {
                NSDictionary *dic = modelData[@"JsonData"];
                
                NSLog(@"%@",_valueType);
                
                NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
                [dataDic setValue:_valueType forKey:@"ValueType"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"viewRefresh" object:nil userInfo:dataDic];
                
                NSString *message = nil;
                
                if ([dic[@"UMoney"] integerValue] > 0) {
                    message = [NSString stringWithFormat:@"获得%ld个U币!", (long)[dic[@"UMoney"] integerValue]];
                }
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发布成功"
                                                                    message:message
                                                                   delegate:self
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                [alertView show];
            }
            else {
                NSString *msg  = [modelData objectForKey:@"Msg"];
                if (msg!=nil && ![msg isEqual:@""]) {
                    [self showMessage:msg];
                }
                else {
                    [self showMessage:[NSString stringWithFormat:@"请求失败 #%d",code]];
                }
            }
        }];
    }
    else {
        [self showMessage:@"请完善帖子内容"];
    }
}

#pragma mark - 上传图片
- (void)uploadImage:(UIImage *)image {
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.01);
    NSString *strBase64 = [imageData base64EncodedString];
    
    NSString *url = [NSString stringWithFormat:@"%@Public/UploadImg",Server_Web_Url];
    NSString *paraStr = kTotalEncryptionInfo(@"");
    NSString *Datas = [TWDes encryptWithContent:paraStr type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    // 调接口需要的两个参数
    NSDictionary *paraDic = @{@"Token":token, kDatas:Datas,@"ImgBase64":strBase64};
        
    [HYBNetworking configRequestType:kHYBRequestTypePlainText];
    [HYBNetworking postWithUrl:url
                        params:paraDic
                       success:^(id response) {
                           
                           NSDictionary *responseObject = response;
                           
                           NSLog(@"提交图片 - responseObject - %@---%@", responseObject, responseObject[@"Msg"]);
                           
                           if ([responseObject[@"Success"] integerValue] == 1) {

                               NSDictionary *dic = responseObject[@"JsonData"];
                               
                               imageShowCollectModel *model = [[imageShowCollectModel alloc] init];
                               model.ImgUri = dic[@"ImgUri"];
                               model.WebSiteUri = dic[@"WebSiteUri"];
                               model.type = @"pic";
                               [self.dataSource addObject:model];
                               
                               [self.imageCollectView reloadData];
                               
                               [self.numPics addObject:@""];//记录已上传图片数量
                               
                               if (self.numPics.count == _picArray.count) {//判断:当前所选的上传图片数量和上传成功数量如果相同 才能结束 提示加载 图层 特殊情况除外 比如 请求失败
                                   [self.hud hide:YES];
                               }
                           }
                           else {
                               [self showMessage:responseObject[@"Msg"]];
                               
                               if ([responseObject[@"Code"] integerValue] == 3) {
                                   
                                   [UserInfo removeAccessToken];//移除token
                                   [UserInfo removeDevIdentity];//移除单点登录
                                   NSUserDf_Set(kNoLogin,JRIsLogin);//修改登录状态
                                   NSUserDf_Remove(kDoctor);//移除是否是医师信息
                                   [UserInfo removeUserInfo];//移除用户信息
                                   EMError *error = [[EMClient sharedClient] logout:YES];
                                   if (!error) {
                                       NSLog(@"环信退出成功");
                                   }
                                   NSUserDf_Set(nil, kHXName);
                                   NSUserDf_Set(nil, kHXPwd);
                                   dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5/*延迟执行时间*/ * NSEC_PER_SEC));
                                   dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                                       JRLoginViewController *loginVC = [[JRLoginViewController alloc] init];
                                       loginVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                                       [self presentViewController:loginVC animated:YES completion:nil];
                                   });
                                   
                                   return ;
                               }
                           }
                       }
                          fail:^(NSError *error) {
                              NSLog(@"%@",error);
                              [self showMessage:@"服务器开小差了~请稍后再试"];
                          }];
}

#pragma mark - 上传视频
- (void)uploadVideo:(NSData *)data {
    
    NSString *url = [NSString stringWithFormat:@"%@Public/UploadVideo",Server_Web_Url];
    NSString *paraStr = kTotalEncryptionInfo(@"");
    NSString *Datas = [TWDes encryptWithContent:paraStr type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    // 调接口需要的两个参数
    NSDictionary *paraDic = @{@"Token":token, kDatas:Datas};
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showLoadding:@"正在处理" time:1000];//必须放在主线程中进行 不然 会 蹦
    });
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
    
    [manager POST:url parameters:paraDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:data name:@"FatieImage" fileName:@"Video.mp4" mimeType:@"video/quicktime"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"提交视频 - responseObject - %@---%@", responseObject, responseObject[@"Msg"]);
        
        if ([responseObject[@"Success"] integerValue] == 1) {
            [self.hud hide:YES];
            NSDictionary *dic = responseObject[@"JsonData"];
            
            imageShowCollectModel *model = [[imageShowCollectModel alloc] init];
            model.WebSiteUri = dic[@"WebSiteUri"];
            model.type = @"video";
            model.ImgUri = dic[@"ImgUri"];
            model.videoUrl = dic[@"VideoUri"];
            [self.dataSource addObject:model];
            
            [self.imageCollectView reloadData];
        }
        else{
            [self showMessage:responseObject[@"Msg"]];
            
            if ([responseObject[@"Code"] integerValue] == 3) {
                
                [UserInfo removeAccessToken];//移除token
                [UserInfo removeDevIdentity];//移除单点登录
                NSUserDf_Set(kNoLogin,JRIsLogin);//修改登录状态
                NSUserDf_Remove(kDoctor);//移除是否是医师信息
                [UserInfo removeUserInfo];//移除用户信息
                EMError *error = [[EMClient sharedClient] logout:YES];
                if (!error) {
                    NSLog(@"环信退出成功");
                }
                NSUserDf_Set(nil, kHXName);
                NSUserDf_Set(nil, kHXPwd);
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5/*延迟执行时间*/ * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    JRLoginViewController *loginVC = [[JRLoginViewController alloc] init];
                    loginVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                    [self presentViewController:loginVC animated:YES completion:nil];
                });
                
                return ;
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        [self showMessage:@"服务器开小差了~请稍后再试"];
    }];
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
