//
//  MyCertificationVC.m
//  JRMedical
//
//  Created by a on 16/11/10.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "MyCertificationVC.h"

#import "MyCertificationCell.h"
#import "MyCertificationCellHeaderView.h"

//医院
#import "RenzhengHosChooseController.h"

//科室
#import "KeshiSelectController.h"
#import "KeshiSelectModel.h"

//职称
#import "ZhiChengChooseController.h"
#import "RenZhengKeshiModel.h"

//介入分类学科
#import "FenleiChooseController.h"

#import "KMImageBrowser.h"
#import "VPImageCropperViewController.h"//图片处理类

#import "KMButton.h"
#import "UIScrollView+UITouch.h"

#import "IQTextView.h"
#import "IQKeyboardManager.h"

#import <YYKit.h>

#import "JRLoginViewController.h"

#define ORIGINAL_MAX_WIDTH 640.0f

@interface MyCertificationVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,VPImageCropperDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UITextViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableDictionary *renZhengDic;

@end

@implementation MyCertificationVC {
    
    UITextField *_xingMingTF;
    UITextField *_yiYuanTF;
    UITextField *_keShiTF;
    UITextField *_zhiChengTF;
    UITextField *_jieRuTF;
    
    IQTextView *_shanChangTF;
    IQTextView *_chengGuoTF;
    
    UIImageView *_currUserPhotoImg;
    NSString *_photoAddress;
    
    NSString *_departmentID;//科室
    NSString *_postID;//职称
    NSString *_hospitalID;//医院
    NSString *_InterventionMsg;//介入分类
    
    NSString *_isnewHosptial;
    NSString *_NewHosptialName;//新增医院
    NSString *_AreaID;//区域ID
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"passHos" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"passHosShouShu" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的认证";
    
    self.renZhengDic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [self setNavBarButtonItem];//设置顶栏右侧按钮
    
    [self getRenZhengInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHosName:) name:@"passHos" object:nil];
    
    // passHosShouShu
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHosNameShoushu:) name:@"passHosShouShu" object:nil];
    
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .heightIs(Height_Screen-64)
    .widthIs(Width_Screen);
}

#pragma mark - 获取认证信息
- (void)getRenZhengInfo {
    
    NSString *params = @"";
    NSString *url = @"api/Customer/GetCustomerReg";
    [self showLoadding:@"正在读取资料,请稍等" time:20];
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"获取认证信息 - %@", modelData);
        if (isSuccess) {
            self.renZhengDic = modelData[@"JsonData"];
            
            _photoAddress = self.renZhengDic[@"WorkCard"];
            _departmentID = self.renZhengDic[@"DepartmentID"];
            _postID = self.renZhengDic[@"PostID"];
            _hospitalID = self.renZhengDic[@"HospitalID"];
            _InterventionMsg = self.renZhengDic[@"InterventionMsg"];
            
            [self.tableView reloadData];
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

#pragma mark - 选择的医院
- (void)changeHosName:(NSNotification *)sender {
    
    NSString *hosName = sender.userInfo[@"hosName"];
    
    _yiYuanTF.text = hosName;
    
    _AreaID = @"";
    
    _hospitalID = sender.userInfo[@"hosID"];
    
    _NewHosptialName = @"";
    
    _isnewHosptial = @"选择的医院";
}

#pragma mark - 手动输入医院
- (void)changeHosNameShoushu:(NSNotification *)sender {
    
    NSString *hosName = sender.userInfo[@"hosName"];
    
    _yiYuanTF.text = hosName;
    
    _AreaID = sender.userInfo[@"hosID"];
    
    _hospitalID = @"";
   
    _NewHosptialName = hosName;

    _isnewHosptial = @"手动输入的医院";
}

#pragma mark - 点击保存信息
- (void)navBarButtonItemClick {
    
    if ([Utils isBlankString:_photoAddress] == YES) {
        return [self showMessage:@"请上传您的工作证"];
    }
    
    if ([Utils isBlankString:_xingMingTF.text] == YES) {
        return [self showMessage:@"请输入您的真实姓名"];
    }
    
    if ([Utils isBlankString:_yiYuanTF.text] == YES) {
        return [self showMessage:@"请选择您所在的医院"];
    }
    
    if ([Utils isBlankString:_keShiTF.text] == YES) {
        return [self showMessage:@"请选择您所在的科室"];
    }
    
    if ([Utils isBlankString:_zhiChengTF.text] == YES) {
        return [self showMessage:@"请选择您的职称"];
    }
    
    if ([Utils isBlankString:_jieRuTF.text] == YES) {
        return [self showMessage:@"请选择您的介入学科"];
    }
    
    if ([Utils isBlankString:_shanChangTF.text] == YES) {
        return [self showMessage:@"请输入您擅长的领域"];
    }
    
    if ([Utils isBlankString:_chengGuoTF.text] == YES) {
        return [self showMessage:@"请输入您的成果"];
    }
    
    NSString *params;
    if ([_isnewHosptial isEqualToString:@"手动输入的医院"]) {
        params = [NSString stringWithFormat:@"ZICBDYCCustomerName=%@ZICBDYCDepartmentID=%@ZICBDYCPostID=%@ZICBDYCInterventionMsg=%@ZICBDYCHospitalID=%@ZICBDYCNewHosptialName=%@ZICBDYCAreaID=%@ZICBDYCSpecialtyMsg=%@ZICBDYCAchievementsMsg=%@ZICBDYCWorkCard=%@",_xingMingTF.text,_departmentID,_postID,_InterventionMsg,_hospitalID,_NewHosptialName,_AreaID,_shanChangTF.text,_chengGuoTF.text,_photoAddress];
    }
    else {
        params = [NSString stringWithFormat:@"ZICBDYCCustomerName=%@ZICBDYCDepartmentID=%@ZICBDYCPostID=%@ZICBDYCInterventionMsg=%@ZICBDYCHospitalID=%@ZICBDYCSpecialtyMsg=%@ZICBDYCAchievementsMsg=%@ZICBDYCWorkCard=%@",_xingMingTF.text,_departmentID,_postID,_InterventionMsg,_hospitalID,_shanChangTF.text,_chengGuoTF.text,_photoAddress];
    }
    
    NSLog(@"%@----",params);
    
    NSString *url = @"api/Customer/CustomerReg";
    
    [self showLoadding:@"正在上传资料" time:20];
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"上传认证信息 - %@", modelData);
        if (isSuccess) {
            
            NSString *message = nil;
            
            NSDictionary *dic = modelData[@"JsonData"];
            
            if ([dic[@"UMoney"] integerValue] > 0) {
                message = [NSString stringWithFormat:@"审核通过后,您将获得%ld个U币!", (long)[dic[@"UMoney"] integerValue]];
            }
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提交成功"
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
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view datasource and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyCertificationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyCertificationCell class]) forIndexPath:indexPath];
    [cell setIndexPath:indexPath];
    
    if (self.renZhengDic.count > 0) {
        [cell setRenZhengDic:self.renZhengDic];
    }
    
    cell.rightTF.delegate = self;
    cell.rightTV.delegate = self;
    
    switch (indexPath.row) {
        case 0:
            _xingMingTF = cell.rightTF;
            break;
        case 1:
            _yiYuanTF = cell.rightTF;
            break;
        case 2:
            _keShiTF = cell.rightTF;
            break;
        case 3:
            _zhiChengTF = cell.rightTF;
            break;
        case 4:
            _jieRuTF = cell.rightTF;
            break;
        case 5:
            _shanChangTF = cell.rightTV;
            break;
        case 6:
            _chengGuoTF = cell.rightTV;
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 5 || indexPath.row == 6) {
        return 120;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 190;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    MyCertificationCellHeaderView *headerView = [[MyCertificationCellHeaderView alloc] initWithFrame:self.tableView.tableHeaderView.frame];
    
    [headerView setRenZhengDic:self.renZhengDic];
    
    [headerView.workCertImg bk_whenTapped:^{
        //设置头像
        
        _currUserPhotoImg = headerView.workCertImg;
        
        [self selectImageAlertController];
    }];
    
    [headerView.lookImgBtn bk_whenTapped:^{
        //查看原图
        [KMImageBrowser showImage:headerView.workCertImg];
    }];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 1:
        {
            RenzhengHosChooseController *hosVC = [[RenzhengHosChooseController alloc] init];
            [self.navigationController pushViewController:hosVC animated:YES];
        }
            break;
        case 2:
        {
            KeshiSelectController *keshiVC = [KeshiSelectController new];
            keshiVC.title = @"选择科室";
            [self.navigationController pushViewController:keshiVC animated:YES];
            
            // 接受传来的值
            keshiVC.passKeshi = ^(KeshiSelectModel *model) {
                _keShiTF.text = model.Name;
                _departmentID = model.Value;
            };
        }
            break;
        case 3:
        {
            ZhiChengChooseController *zhiVC = [ZhiChengChooseController new];
            zhiVC.title = @"选择职称";
            [self.navigationController pushViewController:zhiVC animated:YES];
            
            zhiVC.passZhiCheng = ^(RenZhengKeshiModel *model) {
                _zhiChengTF.text = model.Name;
               _postID = model.Value;
            };
        }
            break;
        case 4:
        {
            FenleiChooseController *fenleiVC = [FenleiChooseController new];
            fenleiVC.title = @"选择介入分类";
            
            [self.navigationController pushViewController:fenleiVC animated:YES];
            
            fenleiVC.passFenLei = ^(NSMutableArray *arr) {
                
                NSString *pinjie = @"/";
                NSString *douhao = @",";
                _InterventionMsg = @"";
                NSString *jieruStr = @"";
                
                for (RenZhengKeshiModel *model in arr) {
                    
                    NSString *temp = [model.Value stringByAppendingString:douhao];
                    _InterventionMsg = [_InterventionMsg stringByAppendingString:temp];
                    
                    NSString *temp2 = [model.Name stringByAppendingString:pinjie];
                    jieruStr = [jieruStr stringByAppendingString:temp2];
                }
                
                _jieRuTF.text = jieruStr;
            };
        }
            break;
            
        default:
            break;
    }
}

- (void)selectImageAlertController {

    //设置头像
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择工作证更换方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }];
    
    UIAlertAction *cancelAction2 = [UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }];
    
    UIAlertAction *cancelAction3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:cancelAction];
    [alertController addAction:cancelAction2];
    [alertController addAction:cancelAction3];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor  = RGB(230, 230, 230);
        _tableView.backgroundColor = BG_Color;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [_tableView registerClass:[MyCertificationCell class] forCellReuseIdentifier:NSStringFromClass([MyCertificationCell class])];
    }
    return  _tableView;
}

#pragma mark - 设置顶栏右侧按钮
- (void)setNavBarButtonItem {
    
    KMButton *imgBtn = [KMButton buttonWithType:UIButtonTypeSystem];
    imgBtn.spacing = 5;
    imgBtn.kMButtonType = KMButtonLeft;
    imgBtn.size = CGSizeMake(65, 44);
    imgBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [imgBtn setTitle:@"保存" forState:UIControlStateNormal];
    [imgBtn setImage:[UIImage imageNamed:@"fatiez"] forState:UIControlStateNormal];
    [imgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [imgBtn setTintColor:[UIColor whiteColor]];
    [imgBtn addTarget:self action:@selector(navBarButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imgBtn];
}

#pragma mark - UITextFildDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 工作证
#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    
    _currUserPhotoImg.image = editedImage;
    
    NSData *imageData = UIImageJPEGRepresentation(editedImage, 0.01);
    NSString *strBase64 = [imageData base64EncodedString];
    
    NSString *url = [NSString stringWithFormat:@"%@Public/UploadImg",Server_Web_Url];
    NSString *paraStr = kTotalEncryptionInfo(@"");
    NSString *Datas = [TWDes encryptWithContent:paraStr type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    // 调接口需要的两个参数
    NSDictionary *paraDic = @{@"Token":token, kDatas:Datas,@"ImgBase64":strBase64};
    
    [self showLoadding:@"" time:20];
    
    [HYBNetworking configRequestType:kHYBRequestTypePlainText];
    [HYBNetworking postWithUrl:url
                        params:paraDic
                       success:^(id response) {
                           
                           [self.hud hide:YES];
                           
                           NSDictionary *responseObject = response;
                           
                           NSLog(@"提交图片 - responseObject - %@---%@", responseObject, responseObject[@"Msg"]);
                           
                           if ([responseObject[@"Success"] integerValue] == 1) {
                               
                               NSDictionary *dic = responseObject[@"JsonData"];
                               
                               _photoAddress = dic[@"ImgUri"];
                               [_currUserPhotoImg  sd_setImageWithURL:[NSURL URLWithString:dic[@"WebSiteUri"]] placeholderImage:[UIImage imageNamed:@"gongzuozheng"]];
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
    
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // present the cropper view controller
        VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgCropperVC.delegate = self;
        [self presentViewController:imgCropperVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
