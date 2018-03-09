//
//  CaseLibraryDetailVC.m
//  JRMedical
//
//  Created by a on 16/12/21.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "CaseLibraryDetailVC.h"

#import "KMButton.h"
#import "CaseLibraryDetailView.h"

#define TopHeader_GuTai_Height 61//详情的固态高度
#define Img_Height(imgNum) (10+(((Width_Screen-20)/4*3)/3*2))*imgNum// 根据图片数量算图片的高度


@interface CaseLibraryDetailVC ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *tUrlArray;
@property (nonatomic, strong) NSMutableArray *hUrlArray;
@property (nonatomic, strong) NSMutableArray *videoUrlArray;

@end

@implementation CaseLibraryDetailVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeVisibleNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeHiddenNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置标题大小
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //设置标题大小
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.model.CaseTitle;
    self.view.backgroundColor = BG_Color;
    
    //将视频 和 图片 url  分离出来
    self.tUrlArray = [NSMutableArray arrayWithCapacity:0];
    self.hUrlArray = [NSMutableArray arrayWithCapacity:0];
    self.videoUrlArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < self.rTypeArray.count; i ++) {
        NSString *tUrl = self.picUrlArray[i];
        NSString *hUrl = self.picOriArray[i];
        //将视频 和 图片 url  分离出来
        if ([self.rTypeArray[i] integerValue] == 1) {
            [self.videoUrlArray addObject:hUrl];
        }
        else {
            [self.tUrlArray addObject:tUrl];
            [self.hUrlArray addObject:hUrl];
        }
    }
    
    [self.view addSubview:self.tableView];
    
    [self seTableViewHeader];//设置顶部帖子详情视图
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(begainFullScreen) name:UIWindowDidBecomeVisibleNotification object:nil];//进入全屏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];//退出全屏
}

#pragma - mark  进入全屏
-(void)begainFullScreen {
    AppDelegate *appDelegate = APPDELEGETE;
    appDelegate.allowRotation = YES;//为1时开启横屏 为0时关闭横屏
}

#pragma - mark 退出全屏
-(void)endFullScreen {
    
    AppDelegate *appDelegate = APPDELEGETE;
    appDelegate.allowRotation = NO;//为1时开启横屏 为0时关闭横屏
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    //强制归正：
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

#pragma mark - 设置顶部帖子详情视图
- (void)seTableViewHeader {
    
    CGRect titleWidth = [Utils getTextRectWithString:self.model.CaseTitle withWidth:Width_Screen-20 withFontSize:16];
    
    CGFloat height;
    if (self.videoUrlArray.count == 0 && self.tUrlArray.count == 0) {
        height = 40 + titleWidth.size.height;
    }
    else {
        height = TopHeader_GuTai_Height + titleWidth.size.height + Img_Height(self.model.List.count);
    }
    
    CaseLibraryDetailView *headerView = [[CaseLibraryDetailView alloc] initWithFrame:CGRectMake(0, 0, Width_Screen, height)];
    [headerView setTUrlArray:self.tUrlArray];
    [headerView setHUrlArray:self.hUrlArray];
    [headerView setVideoUrlArray:self.videoUrlArray];
    [headerView setModel:self.model];
    self.tableView.tableHeaderView = headerView; // 这句很关键
}

#pragma mark - datasource  delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width_Screen, Height_Screen-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = BG_Color;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 74, 0, 0);
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

@end
