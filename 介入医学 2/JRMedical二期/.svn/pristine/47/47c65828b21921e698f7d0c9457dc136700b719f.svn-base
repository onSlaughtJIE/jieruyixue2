//
//  VideoPlayVC.m
//  JRMedical
//
//  Created by a on 16/12/10.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "VideoPlayVC.h"
#import <MediaPlayer/MediaPlayer.h>

@interface VideoPlayVC ()

@property (nonatomic, strong) MPMoviePlayerController *playVideo;

@end

@implementation VideoPlayVC

- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeVisibleNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeHiddenNotification object:nil];
    
    [self.playVideo stop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setBarTintColor:RGB(74, 75, 77)];
    
    //设置标题大小
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.title = @"温馨提示:视频正在转码时,是不能观看的!";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftBarButtonItemClick)];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(begainFullScreen) name:UIWindowDidBecomeVisibleNotification object:nil];//进入全屏
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];//退出全屏
    
    self.view.backgroundColor = [UIColor blackColor];
        
    // 2.更加url创建视频变量
    _playVideo = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:self.url]];
    
    _playVideo.controlStyle = MPMovieControlStyleDefault;

    // 设置视频frame
    _playVideo.view.frame = CGRectMake(0, 0, Width_Screen, Height_Screen-64);
    
    [self.view addSubview:_playVideo.view];
    
    // 5.开启播放视频
    [_playVideo play];
}

//#pragma - mark  进入全屏
//-(void)begainFullScreen {
//    AppDelegate *appDelegate = APPDELEGETE;
//    appDelegate.allowRotation = YES;//为1时开启横屏 为0时关闭横屏
//}
//
//#pragma - mark 退出全屏
//-(void)endFullScreen {
//    
//    AppDelegate *appDelegate = APPDELEGETE;
//    appDelegate.allowRotation = NO;//为1时开启横屏 为0时关闭横屏
//    
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
//    
//    //强制归正：
//    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
//        SEL selector = NSSelectorFromString(@"setOrientation:");
//        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
//        [invocation setSelector:selector];
//        [invocation setTarget:[UIDevice currentDevice]];
//        int val = UIInterfaceOrientationPortrait;
//        [invocation setArgument:&val atIndex:2];
//        [invocation invoke];
//    }
//}

- (void)leftBarButtonItemClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
