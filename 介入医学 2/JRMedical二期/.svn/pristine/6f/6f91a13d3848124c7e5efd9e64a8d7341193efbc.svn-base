//
//  HuiFangPlayViewController.m
//  JRMedical
//
//  Created by ww on 2016/11/29.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "HuiFangPlayViewController.h"

@interface HuiFangPlayViewController ()<UIAlertViewDelegate>
{
    UIButton *_closeButton;
}
@property (nonatomic, strong) UIView *viewAvPlayer; //播放视图
@property (nonatomic, strong) AVPlayer *avPlayer;
@property (nonatomic, strong) AVPlayerLayer *layer;

@end

@implementation HuiFangPlayViewController

- (BOOL)shouldAutorotate

{
    
    return NO;
    
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations

{
    
    return UIInterfaceOrientationMaskLandscape;
    
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation

{
    
    return UIInterfaceOrientationLandscapeRight;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BG_Color;
    
    self.title = self.VideoName;
    
    NSLog(@"VideoUri - %@", self.VideoUri);
    
    if (self.VideoUri.length > 0) {
        [self configAVPlayer];
        
    } else {
    
        [self showMessage:@"暂无视频资源"];
        [self performSelector:@selector(back) withObject:nil afterDelay:1.5];
    
    }
    
    
    
    
}

- (void)back {
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)LiveClose {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"退出观看?"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    [alertView show];
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    
    
    
}

- (void)configAVPlayer {
    
    NSLog(@"KScreenWidth - %f, KScreenHeight - %f", KScreenWidth, KScreenHeight); // 375 667
    
    self.viewAvPlayer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width)];
    self.viewAvPlayer.backgroundColor = [UIColor clearColor];
    //设置播放的url
    NSString *playString = self.VideoUri;
    NSURL *url = [NSURL URLWithString:playString];
    //设置播放的项目
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
    //初始化player对象
    self.avPlayer = [[AVPlayer alloc] initWithPlayerItem:item];
    //设置播放页面
    self.layer = [AVPlayerLayer playerLayerWithPlayer:_avPlayer];
    //设置播放页面的大小
    _layer.frame = CGRectMake(0, 0, self.viewAvPlayer.frame.size.width, self.viewAvPlayer.frame.size.height);
    _layer.backgroundColor = BG_Color.CGColor;
    //设置播放窗口和当前视图之间的比例显示内容
    _layer.videoGravity = AVLayerVideoGravityResizeAspect;
    //添加播放视图到self.view
    [self.viewAvPlayer.layer addSublayer:_layer];
    //设置播放的默认音量值
    self.avPlayer.volume = 1.0f;
    //开始播放
    [self.avPlayer play];
    
    [self.view addSubview:self.viewAvPlayer];
    
    
    //
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeButton.frame = CGRectMake(KScreenHeight - 40.f, 15, 30.f, 30.f);
    // live_close
    [_closeButton setImage:[UIImage imageNamed:@"live_close"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(LiveClose) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_closeButton];
    
}

- (void)dealloc
{

    [self stopAVPlayer];
    
}

- (void)stopAVPlayer
{
    if (self.avPlayer.rate == 1) {
        [self.avPlayer pause];
    }
    self.avPlayer = nil;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
