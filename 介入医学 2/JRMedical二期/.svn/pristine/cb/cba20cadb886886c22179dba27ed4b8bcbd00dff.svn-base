//
//  PostPingJiaVC.m
//  JRMedical
//
//  Created by a on 16/12/23.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "PostPingJiaVC.h"
#import "IQTextView.h"
#import "IQKeyboardManager.h"

#import "UzysAssetsPickerController.h"
#import "imageShowCollectModel.h"
#import "ImageShowCollectCell.h"
#import <YYKit.h>


#import "JRLoginViewController.h"

@interface PostPingJiaVC ()<UzysAssetsPickerControllerDelegate,UICollectionViewDelegate, UICollectionViewDataSource,UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UICollectionView *imageCollectView;

@property (weak, nonatomic) IBOutlet UIImageView *picImg;
@property (weak, nonatomic) IBOutlet UIScrollView *picScrollerView;
@property (weak, nonatomic) IBOutlet IQTextView *plTextView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *BotButton;

@property (weak, nonatomic) IBOutlet UIButton *xing1;
@property (weak, nonatomic) IBOutlet UIButton *xing2;
@property (weak, nonatomic) IBOutlet UIButton *xing3;
@property (weak, nonatomic) IBOutlet UIButton *xing4;
@property (weak, nonatomic) IBOutlet UIButton *xing5;

@property (nonatomic, strong) NSMutableArray *imgList;

@property (nonatomic, strong) NSMutableArray *numPics;

@end

@implementation PostPingJiaVC {
    
    NSString *_xingNum;
    
    NSMutableArray *_picArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    [self.plTextView endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"发布评价";
    
    self.view.backgroundColor = BG_Color;
    
    _xingNum = @"5";
    
    self.dataSource = [NSMutableArray arrayWithCapacity:0];
    self.imgList = [NSMutableArray arrayWithCapacity:0];
    self.numPics = [NSMutableArray arrayWithCapacity:0];
    _picArray = [NSMutableArray arrayWithCapacity:0];
    
    self.xing1.userInteractionEnabled = YES;
    self.xing2.userInteractionEnabled = YES;
    self.xing3.userInteractionEnabled = YES;
    self.xing4.userInteractionEnabled = YES;
    self.xing5.userInteractionEnabled = YES;
    
    //    xingxing_icon xingji
    [self.xing1 bk_whenTapped:^{
        
        _xingNum = @"1";
        
        [self.xing1 setTintColor:RGB(232, 78, 64)];
        [self.xing2 setTintColor:RGB(185, 182, 178)];
        [self.xing3 setTintColor:RGB(185, 182, 178)];
        [self.xing4 setTintColor:RGB(185, 182, 178)];
        [self.xing5 setTintColor:RGB(185, 182, 178)];
    }];
    
    [self.xing2 bk_whenTapped:^{
        
        _xingNum = @"2";
        
        [self.xing1 setTintColor:RGB(232, 78, 64)];
        [self.xing2 setTintColor:RGB(232, 78, 64)];
        [self.xing3 setTintColor:RGB(185, 182, 178)];
        [self.xing4 setTintColor:RGB(185, 182, 178)];
        [self.xing5 setTintColor:RGB(185, 182, 178)];
    }];
    
    [self.xing3 bk_whenTapped:^{
        
        _xingNum = @"3";
        
        [self.xing1 setTintColor:RGB(232, 78, 64)];
        [self.xing2 setTintColor:RGB(232, 78, 64)];
        [self.xing3 setTintColor:RGB(232, 78, 64)];
        [self.xing4 setTintColor:RGB(185, 182, 178)];
        [self.xing5 setTintColor:RGB(185, 182, 178)];
    }];
    
    [self.xing4 bk_whenTapped:^{
        
        _xingNum = @"4";
        
        [self.xing1 setTintColor:RGB(232, 78, 64)];
        [self.xing2 setTintColor:RGB(232, 78, 64)];
        [self.xing3 setTintColor:RGB(232, 78, 64)];
        [self.xing4 setTintColor:RGB(232, 78, 64)];
        [self.xing5 setTintColor:RGB(185, 182, 178)];
    }];
    
    [self.xing5 bk_whenTapped:^{
        
        _xingNum = @"5";
        
        [self.xing1 setTintColor:RGB(232, 78, 64)];
        [self.xing2 setTintColor:RGB(232, 78, 64)];
        [self.xing3 setTintColor:RGB(232, 78, 64)];
        [self.xing4 setTintColor:RGB(232, 78, 64)];
        [self.xing5 setTintColor:RGB(232, 78, 64)];
    }];
    
    self.BotButton.layer.shadowColor = RGB(100, 100, 100).CGColor;//阴影颜色
    self.BotButton.layer.shadowOffset = CGSizeMake(0 , 1);//偏移距离
    self.BotButton.layer.shadowOpacity = 0.5;//不透明度
    self.BotButton.layer.shadowRadius = 3.0;//半径
    
    self.topView.layer.shadowColor = RGB(100, 100, 100).CGColor;//阴影颜色
    self.topView.layer.shadowOffset = CGSizeMake(0 , 1);//偏移距离
    self.topView.layer.shadowOpacity = 0.5;//不透明度
    self.topView.layer.shadowRadius = 3.0;//半径
    
    [self.picScrollerView addSubview:self.imageCollectView];
    self.imageCollectView.sd_layout.topEqualToView(self.picScrollerView).leftEqualToView(self.picScrollerView).rightEqualToView(self.picScrollerView).bottomEqualToView(self.picScrollerView);
}

- (IBAction)postPingJiaClick:(id)sender {

    [self.plTextView endEditing:YES];
    
    if ([self.plTextView.text isEqualToString:@""] || self.plTextView.text == nil) {
        return [self showMessage:@"请输入您的评价内容"];
    }
    
    if ([_xingNum isEqualToString:@""] || _xingNum == nil) {
        return [self showMessage:@"您还没有对我们的产品打分哦!"];
    }
    
    //将上传的 图片 视频 资源 转成json上传
    NSString *imgVideoJsonStr = @"";
    if ([self.dataSource count] > 0) {
        [self.imgList removeAllObjects];
        for (imageShowCollectModel *collectModel in self.dataSource) {
            //图片
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:collectModel.ImgUri forKey:@"ImagePic"];
            [dic setObject:@"0" forKey:@"Type"];
            [dic setObject:@"" forKey:@"Uri"];
            [self.imgList addObject:dic];
        }
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.imgList options:0 error:nil];
        imgVideoJsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCContent=%@ZICBDYCID=%@ZICBDYCPicList=%@ZICBDYCCommodityID=%@ZICBDYCStartLevel=%@",self.plTextView.text,self.ID,imgVideoJsonStr,self.CommodityID,_xingNum];
    NSString *url = @"api/CommodityInfo/EvaluateCommodity";
    
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"评价商品提交图片/视频 - responseObject - %@---%@", modelData, modelData[@"Msg"]);
        if (isSuccess) {
            NSString *message = nil;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"评价成功"
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

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BianJiOrderDetail" object:nil userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)postImageClick:(id)sender {
    
    if (self.dataSource.count == 9) {
        return [self showMessage:@"最多只能添加9个附件!"];
    }
    
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

- (UICollectionView *)imageCollectView {
    if (!_imageCollectView) {
        
        UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
        flowLayOut.itemSize = CGSizeMake(60, 60);
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)xing1:(id)sender {
}
@end
