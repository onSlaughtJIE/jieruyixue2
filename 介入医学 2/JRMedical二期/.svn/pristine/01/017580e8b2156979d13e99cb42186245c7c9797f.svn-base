//
//  MyResumeVC.m
//  JRMedical
//
//  Created by a on 16/12/21.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "MyResumeVC.h"

#import "VPImageCropperViewController.h"//图片处理类
#import "KMImageBrowser.h"
#import <YYKit.h>

#import "JRLoginViewController.h"

#define Image_Width_Heaight (Width_Screen-15*4)/3

#define ORIGINAL_MAX_WIDTH 640.0f

@interface MyResumeVC ()<UIImagePickerControllerDelegate,VPImageCropperDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UIImageView *image1;
@property (nonatomic, strong) UIImageView *image2;
@property (nonatomic, strong) UIImageView *image3;
@property (nonatomic, strong) UIImageView *image4;
@property (nonatomic, strong) UIImageView *image5;
@property (nonatomic, strong) UIImageView *image6;

@property (nonatomic, strong) UIImageView *imageDele1;
@property (nonatomic, strong) UIImageView *imageDele2;
@property (nonatomic, strong) UIImageView *imageDele3;
@property (nonatomic, strong) UIImageView *imageDele4;
@property (nonatomic, strong) UIImageView *imageDele5;
@property (nonatomic, strong) UIImageView *imageDele6;

@property (nonatomic, strong) UIButton *postButton;

@property (nonatomic, strong) NSMutableArray *imageLists;
@property (nonatomic, strong) NSArray *getImageLists;

@end

@implementation MyResumeVC {
    
    NSInteger _imageType;
    
    NSString *_imageView1;
    NSString *_imageView2;
    NSString *_imageView3;
    NSString *_imageView4;
    NSString *_imageView5;
    NSString *_imageView6;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的简历";
    
    self.view.backgroundColor = BG_Color;
    
    self.imageLists = [NSMutableArray arrayWithCapacity:0];
    
    [self getMyResumeDataInfo];//获取简历资料
    
    [self initViewAutoLayout];
}

#pragma mark - 提交
- (void)postBtnClick {
    
    //将上传的 图片 资源 转成json上传
    NSString *imgVideoJsonStr = @"";
    
    if ([Utils isBlankString:_imageView1] &&
        [Utils isBlankString:_imageView2] &&
        [Utils isBlankString:_imageView3] &&
        [Utils isBlankString:_imageView4] &&
        [Utils isBlankString:_imageView5] &&
        [Utils isBlankString:_imageView6] ) {
        
       return [self showMessage:@"至少要上传一张简历哦!"];
    }
    
    [self.imageLists removeAllObjects];
    
    if ([Utils isBlankString:_imageView1] == NO) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:_imageView1 forKey:@"ImagePic"];
        [dic setObject:@"0" forKey:@"Type"];
        [dic setObject:@"" forKey:@"Uri"];
        [self.imageLists addObject:dic];
    }
    if ([Utils isBlankString:_imageView2] == NO) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:_imageView2 forKey:@"ImagePic"];
        [dic setObject:@"0" forKey:@"Type"];
        [dic setObject:@"" forKey:@"Uri"];
        [self.imageLists addObject:dic];
    }
    if ([Utils isBlankString:_imageView3] == NO) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:_imageView3 forKey:@"ImagePic"];
        [dic setObject:@"0" forKey:@"Type"];
        [dic setObject:@"" forKey:@"Uri"];
        [self.imageLists addObject:dic];
    }
    if ([Utils isBlankString:_imageView4] == NO) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:_imageView4 forKey:@"ImagePic"];
        [dic setObject:@"0" forKey:@"Type"];
        [dic setObject:@"" forKey:@"Uri"];
        [self.imageLists addObject:dic];
    }
    if ([Utils isBlankString:_imageView5] == NO) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:_imageView5 forKey:@"ImagePic"];
        [dic setObject:@"0" forKey:@"Type"];
        [dic setObject:@"" forKey:@"Uri"];
        [self.imageLists addObject:dic];
    }
    if ([Utils isBlankString:_imageView6] == NO) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:_imageView6 forKey:@"ImagePic"];
        [dic setObject:@"0" forKey:@"Type"];
        [dic setObject:@"" forKey:@"Uri"];
        [self.imageLists addObject:dic];
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.imageLists options:0 error:nil];
    imgVideoJsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCPicList=%@",imgVideoJsonStr];
    NSString *url = @"api/Customer/SaveResume";
    
    [self showLoadding:@"正在提交" time:20];
    
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSObject *modelData) {
        
        NSDictionary *dataDic = (NSDictionary *)modelData;
        NSLog(@"提交简历资料--------%@",dataDic);
        if (isSuccess) {
            NSString *message = nil;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提交成功"
                                                                message:message
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        else {
            NSString *msg  = [dataDic objectForKey:@"Msg"];
            if (msg!=nil && ![msg isEqual:@""]) {
                [self showMessage:msg];
            }else{
                [self showMessage:[NSString stringWithFormat:@"请求失败 #%d",code]];
            }
        }
    }];
}

#pragma mark - 获取简历资料
- (void)getMyResumeDataInfo {
    
    NSString *params = @"";
    NSString *url = @"api/Customer/MyResume";
    
    [self showLoadding:@"正在加载" time:20];
    
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"获取简历资料--------%@",modelData);
        if (isSuccess) {
            self.getImageLists = modelData[@"JsonData"];
            
            if (self.getImageLists.count == 1) {
                NSDictionary *dic = self.getImageLists[0];
                [self.image1 sd_setImageWithURL:[NSURL URLWithString:dic[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
                self.imageDele1.hidden = NO;
                _imageView1 = dic[@"ImgUri"];
            }
            else if (self.getImageLists.count == 2) {
                NSDictionary *dic = self.getImageLists[0];
                [self.image1 sd_setImageWithURL:[NSURL URLWithString:dic[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
                self.imageDele1.hidden = NO;
                _imageView1 = dic[@"ImgUri"];
                NSDictionary *dic1 = self.getImageLists[1];
                [self.image2 sd_setImageWithURL:[NSURL URLWithString:dic1[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
                self.imageDele2.hidden = NO;
                _imageView2 = dic1[@"ImgUri"];
            }
            else if (self.getImageLists.count == 3) {
                NSDictionary *dic = self.getImageLists[0];
                [self.image1 sd_setImageWithURL:[NSURL URLWithString:dic[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
                self.imageDele1.hidden = NO;
                _imageView1 = dic[@"ImgUri"];
                NSDictionary *dic1 = self.getImageLists[1];
                [self.image2 sd_setImageWithURL:[NSURL URLWithString:dic1[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
                self.imageDele2.hidden = NO;
                _imageView2 = dic1[@"ImgUri"];
                NSDictionary *dic2 = self.getImageLists[2];
                [self.image3 sd_setImageWithURL:[NSURL URLWithString:dic2[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
                self.imageDele3.hidden = NO;
                _imageView3 = dic2[@"ImgUri"];
            }
            else if (self.getImageLists.count == 2) {
                NSDictionary *dic = self.getImageLists[0];
                [self.image1 sd_setImageWithURL:[NSURL URLWithString:dic[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
                self.imageDele1.hidden = NO;
                _imageView1 = dic[@"ImgUri"];
                NSDictionary *dic1 = self.getImageLists[1];
                [self.image2 sd_setImageWithURL:[NSURL URLWithString:dic1[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
                self.imageDele2.hidden = NO;
                _imageView2 = dic1[@"ImgUri"];
                NSDictionary *dic2 = self.getImageLists[2];
                [self.image3 sd_setImageWithURL:[NSURL URLWithString:dic2[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
                self.imageDele3.hidden = NO;
                _imageView3 = dic2[@"ImgUri"];
                NSDictionary *dic3 = self.getImageLists[3];
                [self.image4 sd_setImageWithURL:[NSURL URLWithString:dic3[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
                self.imageDele4.hidden = NO;
                _imageView4 = dic3[@"ImgUri"];
            }
            else if (self.getImageLists.count == 2) {
                NSDictionary *dic = self.getImageLists[0];
                [self.image1 sd_setImageWithURL:[NSURL URLWithString:dic[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
                self.imageDele1.hidden = NO;
                _imageView1 = dic[@"ImgUri"];
                NSDictionary *dic1 = self.getImageLists[1];
                [self.image2 sd_setImageWithURL:[NSURL URLWithString:dic1[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
                self.imageDele2.hidden = NO;
                _imageView2 = dic1[@"ImgUri"];
                NSDictionary *dic2 = self.getImageLists[2];
                [self.image3 sd_setImageWithURL:[NSURL URLWithString:dic2[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
                self.imageDele3.hidden = NO;
                _imageView3 = dic2[@"ImgUri"];
                NSDictionary *dic3 = self.getImageLists[3];
                [self.image4 sd_setImageWithURL:[NSURL URLWithString:dic3[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
                self.imageDele4.hidden = NO;
                _imageView4 = dic3[@"ImgUri"];
                NSDictionary *dic4 = self.getImageLists[4];
                [self.image5 sd_setImageWithURL:[NSURL URLWithString:dic4[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
                self.imageDele5.hidden = NO;
                _imageView5 = dic4[@"ImgUri"];
            }
            else if (self.getImageLists.count == 2) {
                NSDictionary *dic = self.getImageLists[0];
                [self.image1 sd_setImageWithURL:[NSURL URLWithString:dic[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
                self.imageDele1.hidden = NO;
                _imageView1 = dic[@"ImgUri"];
                NSDictionary *dic1 = self.getImageLists[1];
                [self.image2 sd_setImageWithURL:[NSURL URLWithString:dic1[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
                self.imageDele2.hidden = NO;
                _imageView2 = dic1[@"ImgUri"];
                NSDictionary *dic2 = self.getImageLists[2];
                [self.image3 sd_setImageWithURL:[NSURL URLWithString:dic2[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
                self.imageDele3.hidden = NO;
                _imageView3 = dic2[@"ImgUri"];
                NSDictionary *dic3 = self.getImageLists[3];
                [self.image4 sd_setImageWithURL:[NSURL URLWithString:dic3[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
                self.imageDele4.hidden = NO;
                _imageView4 = dic3[@"ImgUri"];
                NSDictionary *dic4 = self.getImageLists[4];
                [self.image5 sd_setImageWithURL:[NSURL URLWithString:dic4[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
                self.imageDele5.hidden = NO;
                _imageView5 = dic4[@"ImgUri"];
                NSDictionary *dic5 = self.getImageLists[5];
                [self.image6 sd_setImageWithURL:[NSURL URLWithString:dic5[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
                self.imageDele6.hidden = NO;
                _imageView6 = dic5[@"ImgUri"];
            }
            
        }
        else {
            NSString *msg  = [modelData objectForKey:@"Msg"];
            if (msg!=nil && ![msg isEqual:@""]) {
                [self showMessage:msg];
            }else{
                [self showMessage:[NSString stringWithFormat:@"请求失败 #%d",code]];
            }
        }
    }];
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 选择图片
- (void)selectImageAlertController:(NSInteger)tag {
    
    _imageType = tag;
    
    //设置头像
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择简历图片更换方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
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


#pragma mark - 设置视图布局
- (void)initViewAutoLayout {
    
    //添加
    [self.image1 bk_whenTapped:^{
        if ([Utils isBlankString:_imageView1] == YES) {
            [self selectImageAlertController:100];
        }
        else {
            [KMImageBrowser showImage:self.image1];
        }
    }];
    [self.image2 bk_whenTapped:^{
        if ([Utils isBlankString:_imageView2] == YES) {
            [self selectImageAlertController:200];
        }
        else {
            [KMImageBrowser showImage:self.image2];
        }
    }];
    [self.image3 bk_whenTapped:^{
        if ([Utils isBlankString:_imageView3] == YES) {
            [self selectImageAlertController:300];
        }
        else {
            [KMImageBrowser showImage:self.image3];
        }
    }];
    [self.image4 bk_whenTapped:^{
        if ([Utils isBlankString:_imageView4] == YES) {
            [self selectImageAlertController:400];
        }
        else {
            [KMImageBrowser showImage:self.image4];
        }
    }];
    [self.image5 bk_whenTapped:^{
        if ([Utils isBlankString:_imageView5] == YES) {
            [self selectImageAlertController:500];
        }
        else {
            [KMImageBrowser showImage:self.image5];
        }
    }];
    [self.image6 bk_whenTapped:^{
        if ([Utils isBlankString:_imageView6] == YES) {
            [self selectImageAlertController:600];
        }
        else {
            [KMImageBrowser showImage:self.image6];
        }
    }];
    
    //删除
    [self.imageDele1 bk_whenTapped:^{
        self.image1.image = [UIImage imageNamed:@"addd"];
        self.imageDele1.hidden = YES;
        _imageView1 = nil;
    }];
    [self.imageDele2 bk_whenTapped:^{
        self.image2.image = [UIImage imageNamed:@"addd"];
        self.imageDele2.hidden = YES;
        _imageView2 = nil;
    }];
    [self.imageDele3 bk_whenTapped:^{
        self.image3.image = [UIImage imageNamed:@"addd"];
        self.imageDele3.hidden = YES;
        _imageView3 = nil;
    }];
    [self.imageDele4 bk_whenTapped:^{
        self.image4.image = [UIImage imageNamed:@"addd"];
        self.imageDele4.hidden = YES;
        _imageView4 = nil;
    }];
    [self.imageDele5 bk_whenTapped:^{
        self.image5.image = [UIImage imageNamed:@"addd"];
        self.imageDele5.hidden = YES;
        _imageView5 = nil;
    }];
    [self.imageDele6 bk_whenTapped:^{
        self.image6.image = [UIImage imageNamed:@"addd"];
        self.imageDele6.hidden = YES;
        _imageView6 = nil;
    }];
    
    [self.view addSubview:self.image1];
    [self.view addSubview:self.image2];
    [self.view addSubview:self.image3];
    [self.view addSubview:self.image4];
    [self.view addSubview:self.image5];
    [self.view addSubview:self.image6];
    
    [self.image1 addSubview:self.imageDele1];
    [self.image2 addSubview:self.imageDele2];
    [self.image3 addSubview:self.imageDele3];
    [self.image4 addSubview:self.imageDele4];
    [self.image5 addSubview:self.imageDele5];
    [self.image6 addSubview:self.imageDele6];
    
    [self.view addSubview:self.postButton];
    
    self.image1.sd_layout.topSpaceToView(self.view,50).leftSpaceToView(self.view,15).widthIs(Image_Width_Heaight).heightIs(Image_Width_Heaight);
    self.image2.sd_layout.topSpaceToView(self.view,50).leftSpaceToView(self.image1,15).widthIs(Image_Width_Heaight).heightIs(Image_Width_Heaight);
    self.image3.sd_layout.topSpaceToView(self.view,50).leftSpaceToView(self.image2,15).widthIs(Image_Width_Heaight).heightIs(Image_Width_Heaight);
    self.image4.sd_layout.topSpaceToView(self.image1,15).leftSpaceToView(self.view,15).widthIs(Image_Width_Heaight).heightIs(Image_Width_Heaight);
    self.image5.sd_layout.topSpaceToView(self.image2,15).leftSpaceToView(self.image4,15).widthIs(Image_Width_Heaight).heightIs(Image_Width_Heaight);
    self.image6.sd_layout.topSpaceToView(self.image3,15).leftSpaceToView(self.image5,15).widthIs(Image_Width_Heaight).heightIs(Image_Width_Heaight);
    
    self.imageDele1.sd_layout.topSpaceToView(self.image1,5).rightSpaceToView(self.image1,5).widthIs(Image_Width_Heaight/5).heightIs(Image_Width_Heaight/5);
    self.imageDele2.sd_layout.topSpaceToView(self.image2,5).rightSpaceToView(self.image2,5).widthIs(Image_Width_Heaight/5).heightIs(Image_Width_Heaight/5);
    self.imageDele3.sd_layout.topSpaceToView(self.image3,5).rightSpaceToView(self.image3,5).widthIs(Image_Width_Heaight/5).heightIs(Image_Width_Heaight/5);
    self.imageDele4.sd_layout.topSpaceToView(self.image4,5).rightSpaceToView(self.image4,5).widthIs(Image_Width_Heaight/5).heightIs(Image_Width_Heaight/5);
    self.imageDele5.sd_layout.topSpaceToView(self.image5,5).rightSpaceToView(self.image5,5).widthIs(Image_Width_Heaight/5).heightIs(Image_Width_Heaight/5);
    self.imageDele6.sd_layout.topSpaceToView(self.image6,5).rightSpaceToView(self.image6,5).widthIs(Image_Width_Heaight/5).heightIs(Image_Width_Heaight/5);
    
    self.postButton.sd_layout.topSpaceToView(self.image6,60).leftSpaceToView(self.view,15).rightSpaceToView(self.view,15).heightIs(45);
}

#pragma mark - 懒加载
- (UIImageView *)image1 {
    if (!_image1) {
        _image1 = [UIImageView new];
        _image1.image = [UIImage imageNamed:@"addd"];
        _image1.userInteractionEnabled = YES;
        _image1.clipsToBounds = YES;
        _image1.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _image1;
}
- (UIImageView *)image2 {
    if (!_image2) {
        _image2 = [UIImageView new];
        _image2.image = [UIImage imageNamed:@"addd"];
        _image2.userInteractionEnabled = YES;
        _image2.clipsToBounds = YES;
        _image2.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _image2;
}
- (UIImageView *)image3 {
    if (!_image3) {
        _image3 = [UIImageView new];
        _image3.image = [UIImage imageNamed:@"addd"];
        _image3.userInteractionEnabled = YES;
        _image3.clipsToBounds = YES;
        _image3.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _image3;
}
- (UIImageView *)image4 {
    if (!_image4) {
        _image4 = [UIImageView new];
        _image4.image = [UIImage imageNamed:@"addd"];
        _image4.userInteractionEnabled = YES;
        _image4.clipsToBounds = YES;
        _image4.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _image4;
}
- (UIImageView *)image5 {
    if (!_image5) {
        _image5 = [UIImageView new];
        _image5.image = [UIImage imageNamed:@"addd"];
        _image5.userInteractionEnabled = YES;
        _image5.clipsToBounds = YES;
        _image5.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _image5;
}
- (UIImageView *)image6 {
    if (!_image6) {
        _image6 = [UIImageView new];
        _image6.image = [UIImage imageNamed:@"addd"];
        _image6.userInteractionEnabled = YES;
        _image6.clipsToBounds = YES;
        _image6.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _image6;
}
- (UIImageView *)imageDele1 {
    if (!_imageDele1) {
        _imageDele1 = [UIImageView new];
        _imageDele1.image = [UIImage imageNamed:@"guanbi"];
        _imageDele1.userInteractionEnabled = YES;
        _imageDele1.hidden = YES;
    }
    return _imageDele1;
}
- (UIImageView *)imageDele2 {
    if (!_imageDele2) {
        _imageDele2 = [UIImageView new];
        _imageDele2.image = [UIImage imageNamed:@"guanbi"];
        _imageDele2.userInteractionEnabled = YES;
        _imageDele2.hidden = YES;
    }
    return _imageDele2;
}
- (UIImageView *)imageDele3 {
    if (!_imageDele3) {
        _imageDele3 = [UIImageView new];
        _imageDele3.image = [UIImage imageNamed:@"guanbi"];
        _imageDele3.userInteractionEnabled = YES;
        _imageDele3.hidden = YES;
    }
    return _imageDele3;
}
- (UIImageView *)imageDele4 {
    if (!_imageDele4) {
        _imageDele4 = [UIImageView new];
        _imageDele4.image = [UIImage imageNamed:@"guanbi"];
        _imageDele4.userInteractionEnabled = YES;
        _imageDele4.hidden = YES;
    }
    return _imageDele4;
}
- (UIImageView *)imageDele5 {
    if (!_imageDele5) {
        _imageDele5 = [UIImageView new];
        _imageDele5.image = [UIImage imageNamed:@"guanbi"];
        _imageDele5.userInteractionEnabled = YES;
        _imageDele5.hidden = YES;
    }
    return _imageDele5;
}
- (UIImageView *)imageDele6 {
    if (!_imageDele6) {
        _imageDele6 = [UIImageView new];
        _imageDele6.image = [UIImage imageNamed:@"guanbi"];
        _imageDele6.userInteractionEnabled = YES;
        _imageDele6.hidden = YES;
    }
    return _imageDele6;
}
- (UIButton *)postButton {
    if (!_postButton) {
        _postButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_postButton setTitle:@"提交" forState:UIControlStateNormal];
        [_postButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _postButton.backgroundColor = RGB(205, 32, 28);
        _postButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _postButton.clipsToBounds = YES;
        _postButton.layer.cornerRadius = 5;
        [_postButton addTarget:self action:@selector(postBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _postButton;
}

#pragma mark - 更新简历
#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    
    switch (_imageType) {
        case 100:
            self.image1.image = editedImage;
            break;
        case 200:
            self.image2.image = editedImage;
            break;
        case 300:
            self.image3.image = editedImage;
            break;
        case 400:
            self.image4.image = editedImage;
            break;
        case 500:
            self.image5.image = editedImage;
            break;
        case 600:
            self.image6.image = editedImage;
            break;
        default:
            break;
    }
    
    NSData *imageData = UIImageJPEGRepresentation(editedImage, 0.01);
    NSString *strBase64 = [imageData base64EncodedString];
    
    NSString *url = [NSString stringWithFormat:@"%@Public/UploadImg",Server_Web_Url];
    NSString *paraStr = kTotalEncryptionInfo(@"");
    NSString *Datas = [TWDes encryptWithContent:paraStr type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    
    // 调接口需要的两个参数
    NSDictionary *paraDic = @{@"Token":token, kDatas:Datas,@"ImgBase64":strBase64};
    
    [self showLoadding:@"正在处理" time:20];
    
    [HYBNetworking configRequestType:kHYBRequestTypePlainText];
    [HYBNetworking postWithUrl:url
                        params:paraDic
                       success:^(id response) {
                           
                           [self.hud hide:YES];
                           
                           NSDictionary *responseObject = response;
                           
                           NSLog(@"提交图片 - responseObject - %@---%@", responseObject, responseObject[@"Msg"]);
                           
                           if ([responseObject[@"Success"] integerValue] == 1) {
                               
                               NSDictionary *dic = responseObject[@"JsonData"];
                               
                               switch (_imageType) {
                                   case 100:
                                   {
                                       _imageView1 = dic[@"ImgUri"];
                                       [self.image1  setImageWithURL:[NSURL URLWithString:dic[@"WebSiteUri"]] placeholder:[UIImage imageNamed:@"jiazai"]];
                                       self.imageDele1.hidden = NO;
                                   }
                                       break;
                                   case 200:
                                   {
                                       _imageView2 = dic[@"ImgUri"];
                                       [self.image2 setImageWithURL:[NSURL URLWithString:dic[@"WebSiteUri"]] placeholder:[UIImage imageNamed:@"jiazai"]];
                                       self.imageDele2.hidden = NO;
                                   }
                                       break;
                                   case 300:
                                   {
                                       _imageView3 = dic[@"ImgUri"];
                                       [self.image3 setImageWithURL:[NSURL URLWithString:dic[@"WebSiteUri"]] placeholder:[UIImage imageNamed:@"jiazai"]];
                                       self.imageDele3.hidden = NO;
                                   }
                                       break;
                                   case 400:
                                   {
                                       _imageView4 = dic[@"ImgUri"];
                                       [self.image4 setImageWithURL:[NSURL URLWithString:dic[@"WebSiteUri"]] placeholder:[UIImage imageNamed:@"jiazai"]];
                                       self.imageDele4.hidden = NO;
                                   }
                                       break;
                                   case 500:
                                   {
                                       _imageView5 = dic[@"ImgUri"];
                                       [self.image5 setImageWithURL:[NSURL URLWithString:dic[@"WebSiteUri"]] placeholder:[UIImage imageNamed:@"jiazai"]];
                                       self.imageDele5.hidden = NO;
                                   }
                                       break;
                                   case 600:
                                   {
                                       _imageView6 = dic[@"ImgUri"];
                                       [self.image6 setImageWithURL:[NSURL URLWithString:dic[@"WebSiteUri"]] placeholder:[UIImage imageNamed:@"jiazai"]];
                                       self.imageDele6.hidden = NO;
                                   }
                                       break;
                                   default:
                                       break;
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
