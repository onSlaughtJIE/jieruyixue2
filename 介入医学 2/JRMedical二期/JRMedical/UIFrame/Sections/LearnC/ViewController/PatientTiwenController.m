//
//  PatientTiwenController.m
//  JRMedical
//
//  Created by apple on 16/7/4.
//  Copyright © 2016年 ZC. All rights reserved.
//

#import "PatientTiwenController.h"
#import "UzysAssetsPickerController.h"
#import "BRPlaceholderTextView.h"

@interface PatientTiwenController ()<UzysAssetsPickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UIAlertViewDelegate>
{
    MBProgressHUD *HUD;
    NSMutableArray *_totArray;
    NSMutableArray *_picArray;
    UIScrollView *_picScrollView;
    NSMutableArray *_spArray;
    NSURL *_videoUrl;
    NSData *_currentShiPin;
    NSMutableArray *_currentShiPinArr;
}

@property (weak, nonatomic) IBOutlet BRPlaceholderTextView *askTv;



@end



@implementation PatientTiwenController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = RGB(239, 240, 241);
    
    [self initSomeThing];
    
    self.askTv.maxTextLength = 10000;
    self.askTv.placeholder = @"请填写您想咨询的问题";
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submitAction:)];
    
    /*
    _picScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(15, 230, Width_Screen-30, 80)];
    _picScrollView.contentSize = CGSizeMake([_totArray count]*80+([_totArray count]-1)*5, 80);
    _picScrollView.backgroundColor = [UIColor whiteColor];
    _picScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_picScrollView];
    
    
    UIButton *addImageBtn = [[UIButton alloc] initWithFrame:(CGRectMake(15, CGRectGetMaxY(_picScrollView.frame) + 15, 80, 80))];
    [addImageBtn setBackgroundImage:[UIImage imageNamed:@"jiatu"] forState:(UIControlStateNormal)];
    addImageBtn.tag = 1001;
    [addImageBtn addTarget:self action:@selector(currentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addImageBtn];
    
    UIButton *addSpBtn = [[UIButton alloc] initWithFrame:(CGRectMake(CGRectGetMaxX(addImageBtn.frame)+10, CGRectGetMaxY(_picScrollView.frame) + 15, 80, 80))];
    [addSpBtn setBackgroundImage:[UIImage imageNamed:@"tian"] forState:(UIControlStateNormal)];
    addSpBtn.tag = 1002;
    [addSpBtn addTarget:self action:@selector(currentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addSpBtn];
    addSpBtn.hidden = YES;
     */
    
    
    
    
    
    
}


#pragma mark - 初始化
- (void)initSomeThing
{
//    _picArray = [NSMutableArray array];
//    _spArray = [NSMutableArray array];
//    _totArray = [NSMutableArray array];
//    
//    _currentShiPinArr  = [NSMutableArray array];
    
    self.askTv.returnKeyType = UIReturnKeyDone;
    self.askTv.delegate = self;
    
}

#pragma mark - 新增提问
- (void)submitAction:(id)sender {
    
    NSLog(@"提问!!");
    /*
    NSString *listUrl = [[NSString alloc] init];
    NSString *datasStr = [[NSString alloc] init];
    
    
        
    listUrl = [NSString stringWithFormat:@"%@/Admin/CustomerPost/CreateCustomerQA", Server_Int_Url];
    
    datasStr = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCQuestionContent=%@", kPrefixPara, UserDefaultsGet(kDevIdentityInfo), kDevSysInfo, kDevTypeInfo, kIMEI, _askTv.text];
    
    
    
    NSString *DataEncrypt = [TWDes encryptWithContent:datasStr type:kDesType key:kDesKey];
    
    // 调接口需要的两个参数
    NSDictionary *paraDic = @{kAccessTokenInfo : UserDefaultsGet(kAccessTokenInfo), kDatas:DataEncrypt};
    
    
    
    if ([_picArray count]> 0 || [_currentShiPinArr count] > 0 || _askTv.text) {
        
        NSMutableArray *passArray = [NSMutableArray array];
        for (int i = 0; i<[_picArray count]; i++) {
            PicOrVideoModel *model = [[PicOrVideoModel alloc] init];
            model.contentData = UIImageJPEGRepresentation([_picArray objectAtIndex:i], 0.01);
            model.contentName = @"FatieImage";
            model.passKey = @"pic.jpg";
            model.passType = @"image/jpeg";
            [passArray addObject:model];
        }
        
        for (int i = 0; i<[_currentShiPinArr count]; i++) {
            //NSData *videoData = [NSData dataWithContentsOfURL:_videoUrl];
            PicOrVideoModel *model = [[PicOrVideoModel alloc] init];
            model.contentData = [_currentShiPinArr objectAtIndex:i];
            model.contentName = @"FatieVideo"; // 视频名字
            model.passKey = @"Video.mp4";
            model.passType = @"video/quicktime";
            [passArray addObject:model];
            NSLog(@"shipin");
        }
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        if (_askTv.text.length > 0) {
            
            [SVProgressHUD showWithStatus:@"正在发布"];
            
            [manager POST:listUrl parameters:paraDic constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
                
                for (int i = 0; i < passArray.count; i++) {
                    
                    PicOrVideoModel *model = [passArray objectAtIndex:i];
                    
                    [formData appendPartWithFileData:model.contentData name:model.contentName fileName:model.passKey mimeType:model.passType];
                    
                }
                
                
            } success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
                
                NSLog(@"患者咨询 提交图片/视频 - responseObject - %@", responseObject);
                
                if ([responseObject[@"Success"] integerValue] == 1) {
                    
              
                    if (self.fromCaseVC == 8888) { // 病例库
                        
                        [SVProgressHUD dismissWithSuccess:@"提交成功"];
                        [self performSelector:@selector(back) withObject:nil afterDelay:1.5];
                        
                    }else { // 患者咨询
                        
                        [SVProgressHUD dismiss];
                        
                        NSString *message = nil;
                        
                        NSDictionary *dic = responseObject[@"JsonData"];
                        
                        if ([dic[@"UMoney"] integerValue] > 0) {
                            message = [NSString stringWithFormat:@"审核通过后,您将获得%ld个U币!", (long)[dic[@"UMoney"] integerValue]];
                        }
                        
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提交成功,提问需审核,请耐心等待"
                                                                            message:message
                                                                           delegate:self
                                                                  cancelButtonTitle:@"确定"
                                                                  otherButtonTitles:nil];
                        [alertView show];

                    }
                    
                  
                }else{
                    
                    [SVProgressHUD dismissWithError:@"服务器开了会儿小差,提交失败"];
                }
                
                
            } failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
                
                [SVProgressHUD dismissWithError:@"服务器开了会儿小差,提交失败"];
                
            }];
            
        } else {
            
            [self showHUDWithText:@"请填写完整信息"];
        }
        
        
    }
   
     */
    
    
    NSString *urlS = [NSString stringWithFormat:@"%@/api/Post/CreateCustomerQA", Server_Int_Url];
    NSString *dataS = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCQuestionContent=%@", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI, _askTv.text, nil];
    NSString *dataEncrpyt = [TWDes encryptWithContent:dataS type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    NSDictionary *paraDic = @{kToken:token, kDatas:dataEncrpyt};
    
    [self showHudInView:self.view hint:@""];
    [AFManegerHelp POST:urlS parameters:paraDic success:^(id responseObjeck) {
        NSLog(@"CreateCustomerQA - %@", responseObjeck);
        [self hideHud];
        if ([responseObjeck[@"Success"] integerValue] == 1) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提交成功,提问需审核,请耐心等待"
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
            [alertView show];
            
//            [self showHint:@"提交成功, 提问需审核, 请耐心等待" yOffset:-100];
            
//            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC));
//            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//                [self.navigationController popViewControllerAnimated:YES];
//            });
            
        } else {
            [self showHint:responseObjeck[@"Msg"]];
        }
        
    } failure:^(NSError *error) {
        [self hideHud];
        [self showHint:@"连接不到服务器"];
    }];
    
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];

}


#pragma mark---------选择图片------------
- (void)uzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    
    for (UIView *v in [_picScrollView subviews]) {
        [v removeFromSuperview];
    }
    [_totArray removeAllObjects];
    
    if([[assets[0] valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypePhoto"])
        //Photo
    {
        [_picArray removeAllObjects];
        [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ALAsset *representation = obj;
            UIImage *img = [UIImage imageWithCGImage:representation.defaultRepresentation.fullResolutionImage
                                               scale:representation.defaultRepresentation.scale
                                         orientation:(UIImageOrientation)representation.defaultRepresentation.orientation];
            UIImage *newImg =  [self fixOrientation:img];
            [_picArray addObject:newImg];
            NSLog(@"添加图片");
            *stop = NO;
        }];
    }
    
    else //Video
    {
        
        [_spArray removeAllObjects];
        
        [SVProgressHUD showWithStatus:@"正在导入视频"];
        
        [assets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ALAsset *alAsset = obj;
            
            UIImage *img = [UIImage imageWithCGImage:alAsset.defaultRepresentation.fullResolutionImage
                                               scale:alAsset.defaultRepresentation.scale
                                         orientation:(UIImageOrientation)alAsset.defaultRepresentation.orientation];
            [_spArray addObject:img];
            
            ALAssetRepresentation *representation = alAsset.defaultRepresentation;
            NSURL *movieURL = representation.url;
            
            //清除上次该路径保存的文件
            NSURL *uploadURL = [NSURL fileURLWithPath:[[NSTemporaryDirectory() stringByAppendingPathComponent:@"test"] stringByAppendingString:[NSString stringWithFormat:@"%lu.mmov", (unsigned long)idx]]];
            
            //            NSLog(@"%@", NSHomeDirectory());
            //            NSLog(@"%@", NSTemporaryDirectory());
            //            NSLog(@"**********uploadURL - %@", uploadURL);
            NSFileManager *manager = [NSFileManager defaultManager];
            [manager removeItemAtURL:uploadURL error:nil];
            
            //输出文件到上边设定的路径
            AVAsset *asset      = [AVURLAsset URLAssetWithURL:movieURL options:nil];
            AVAssetExportSession *session =
            [AVAssetExportSession exportSessionWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
            
            session.outputFileType  = AVFileTypeQuickTimeMovie;
            session.outputURL       = uploadURL;
            
            
            [session exportAsynchronouslyWithCompletionHandler:^{
                NSLog(@"进来了");
                [SVProgressHUD dismissWithSuccess:@"导入成功"];
                //                _videoUrl = uploadURL;
                
                if (session.status == AVAssetExportSessionStatusCompleted)
                {
                    DLog(@"output Video URL %@",uploadURL);
                }
                //                _currentShiPin = [NSData dataWithContentsOfURL:_videoUrl];
                [_currentShiPinArr addObject:[NSData dataWithContentsOfURL:uploadURL]];
            }];
            
        }];
    }
    
    [self chooPicSucceed];
    
}

- (void)uzysAssetsPickerControllerDidExceedMaximumNumberOfSelection:(UzysAssetsPickerController *)picker
{
    NSLog(@"嘿嘿");
}

- (void)chooPicSucceed
{
    [_totArray addObjectsFromArray:_picArray];
    [_totArray addObjectsFromArray:_spArray];
    

    _picScrollView.contentSize = CGSizeMake([_totArray count]*80+([_totArray count]-1)*5, 80);
    for (int i = 0; i<[_totArray count]; i++) {
        UIButton *picBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        picBtn.frame = CGRectMake((5+80)*i, 0, 80, 80);
//        picBtn.tag = 1000 + i;
//        [picBtn addTarget:self action:@selector(currentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [picBtn setBackgroundImage:[_totArray objectAtIndex:i] forState:UIControlStateNormal];
        [_picScrollView addSubview:picBtn];
    }
}

#pragma mark-----触发事件------
- (void)currentBtnClick:(UIButton *)sender
{

    int addPicTag = 1001;
    int addSpTag = 1002;
    if (sender.tag == addPicTag) {//添加图片按钮
        UzysAssetsPickerController *picker = [[UzysAssetsPickerController alloc] init];
        picker.delegate = self;
        picker.maximumNumberOfSelectionVideo = 0;
        picker.maximumNumberOfSelectionPhoto = 21;
        [self presentViewController:picker animated:YES completion:^{}];
    }else if (sender.tag == addSpTag) {//选择视频按钮
        UzysAssetsPickerController *picker = [[UzysAssetsPickerController alloc] init];
        picker.delegate = self;
        picker.maximumNumberOfSelectionVideo = 10;
        picker.maximumNumberOfSelectionPhoto = 0;
        [self presentViewController:picker animated:YES completion:^{}];
    } 

    
}

- (UIImage *)fixOrientation:(UIImage *)aImage
{
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


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
    
}



-(void)showHUDWithText:(NSString *)showText
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = showText;
    HUD.mode = MBProgressHUDModeText;
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1.5);
    } completionBlock:^{
        [HUD removeFromSuperview];
        HUD = nil;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
