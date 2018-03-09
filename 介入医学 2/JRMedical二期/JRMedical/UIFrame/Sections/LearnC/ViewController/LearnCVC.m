//
//  LearnCVC.m
//  JRMedical
//
//  Created by a on 16/11/4.
//  Copyright © 2016年 idcby. All rights reserved.
//
#define kCollectCellIdentifier @"collectCell"
#define kCellOne @"cellOne"
#define kCellTwo @"cellTwo"
#define kCellThree @"cellThree"
#define kCellVideo @"cellVideo"

#import "LearnCVC.h"
#import <SDCycleScrollView.h>
#import "StudyCollectionCell.h"
#import "StudyCollectModel.h"
#import "StudyCellOne.h"
#import "StudyCellTwo.h"
#import "StudyCellThree.h"
#import "StudyVideoCell.h"
#import "StudyTabHeader.h"
#import "FindExpertController.h"
#import "FamousHosViewController.h"
#import "ScienceEducationTypeVC.h"
#import "PublicNewsListModel.h"
#import "LearnWebController.h"
#import "VideoSpecialDetailContentVC.h"
#import "PdfWebViewController.h"
#import "MedicalMeetWebDetailVC.h"
#import <YYKit.h>

#import "HospitalExpertModel.h"
#import "KeShiModel.h"
#import "BingZhongModel.h"
#import "HosLevelModel.h"
#import "CommonWebVC.h"
#import "PatientController.h"

@interface LearnCVC ()<UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) UITableView *sTableView;
@property (nonatomic, strong) UICollectionView *sCollectionView;
@property (nonatomic, strong) NSMutableArray *TabDataSource; // 列表数据源
@property (nonatomic, strong) NSMutableArray *CollectDataSource; // 集合视图数据源

@property (nonatomic, strong) NSMutableArray *imagesArray; // 轮播图片
@property (nonatomic, strong) NSMutableArray *titlesArray; // 轮播标题
@property (nonatomic, strong) NSMutableArray *HrefArr;     // 轮播图跳转网址

@property (nonatomic, strong) NSMutableArray *areaArray;   // 地区
@property (nonatomic, strong) NSMutableArray *keShiArray;   // 科室
@property (nonatomic, strong) NSMutableArray *bingZhongArray;   // 病种
@property (nonatomic, strong) NSMutableArray *hosLevelArray; // 医院等级

@end

@implementation LearnCVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"医患之家";
    
    self.TabDataSource = [NSMutableArray array];
    self.CollectDataSource = [NSMutableArray array];
    
    self.areaArray = [NSMutableArray array];
    self.keShiArray = [NSMutableArray array];
    self.bingZhongArray = [NSMutableArray array];
    self.hosLevelArray = [NSMutableArray array];
    
    // 列表视图
    [self initsTableView];
    // 表头视图
    [self configHeaderView];
    //导航栏右边铃铛按钮
//    [self configRightBarBtnItem];
    
    //获取最新资讯
    [self requestLatestNewListData];
    
    // 医患之家
    [self requestAllDiQuData];
    [self requestAllKeShiData];
    [self requestAllBingZhongData];
    [self requestAllHosLevel];
}

//#pragma mark - 顶部铃铛点击事件
//- (void)navBarButtonItemClick {
//    [self showMessage:@"功能正在建设中、敬请期待..."];
//}

//- (void)configRightBarBtnItem {
//    
//    UIView *rightView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, 40, 40))];
//    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setImage:[UIImage imageNamed:@"xiaoxi"] forState:(UIControlStateNormal)];
//    [btn addTarget:self action:@selector(navBarButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
//    [rightView addSubview:btn];
//    
//    btn.sd_layout.rightEqualToView(rightView).centerYEqualToView(rightView).widthIs(32).heightIs(32);
//    
//    UILabel *lab = [[UILabel alloc] initWithFrame:(CGRectMake(22, -2, 15, 15))];
//    lab.text = @"10";
//    lab.font = [UIFont systemFontOfSize:9];
//    lab.backgroundColor = [UIColor redColor];
//    lab.textColor = [UIColor whiteColor];
//    lab.textAlignment = NSTextAlignmentCenter;
//    lab.layer.masksToBounds = YES;
//    lab.layer.cornerRadius = 7.5;
//    [btn addSubview:lab];
//    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
//    
//}

- (void)configHeaderView {
    
    UIView *header = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, Width_Screen, Width_Screen/5*1+200))];
    // 轮播图
    UIView *lunboView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width_Screen, 200)];
    [header addSubview:lunboView];
    
    self.imagesArray = [NSMutableArray array];
    self.titlesArray = [NSMutableArray array];
    self.HrefArr = [NSMutableArray array];
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:(CGRectMake(0, 0, Width_Screen, 200)) delegate:self placeholderImage:[UIImage imageNamed:@"jiazai"]];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    cycleScrollView.currentPageDotColor = Main_Color;
    cycleScrollView.pageDotColor = [UIColor whiteColor];
//    cycleScrollView.currentPageDotImage = [UIImage imageWithColor:Main_Color size:CGSizeMake(32, 6)];
//    cycleScrollView.pageDotImage = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(32, 6)];
    [lunboView addSubview:cycleScrollView];
    self.cycleScrollView = cycleScrollView;
    
    // 集合视图
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((Width_Screen-3)/4, Width_Screen/5);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumLineSpacing = 1;
    flowLayout.minimumInteritemSpacing = 1;
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_cycleScrollView.frame), Width_Screen, Width_Screen/5) collectionViewLayout:flowLayout];
    
    collectionView.backgroundColor = BG_Color;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerNib:[UINib nibWithNibName:@"StudyCollectionCell" bundle:nil] forCellWithReuseIdentifier:kCollectCellIdentifier];
    [header addSubview:collectionView];
    self.sCollectionView = collectionView;
    // 集合视图数据
    [self addDataForCollect];
    
    self.sTableView.tableHeaderView = header;
}

- (void)initsTableView {
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];

    tableview.contentInset = UIEdgeInsetsMake(0, 0, 108, 0);

    tableview.contentInset = UIEdgeInsetsMake(0, 0, 114, 0);

    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.showsVerticalScrollIndicator = NO;
    tableview.estimatedRowHeight = 100;
    tableview.separatorColor = RGB(230, 230, 230);
    tableview.separatorInset = UIEdgeInsetsMake(0, 8, 0, 0);
    tableview.rowHeight = UITableViewAutomaticDimension;
    tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [tableview registerNib:[UINib nibWithNibName:@"StudyCellOne" bundle:nil] forCellReuseIdentifier:kCellOne];
    [tableview registerNib:[UINib nibWithNibName:@"StudyCellTwo" bundle:nil] forCellReuseIdentifier:kCellTwo];
    [tableview registerNib:[UINib nibWithNibName:@"StudyCellThree" bundle:nil] forCellReuseIdentifier:kCellThree];
    [tableview registerNib:[UINib nibWithNibName:@"StudyVideoCell" bundle:nil] forCellReuseIdentifier:kCellVideo];
    [self.view addSubview:tableview];
    self.sTableView = tableview;
}

#pragma mark - UICollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.CollectDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    StudyCollectModel *model = self.CollectDataSource[indexPath.row];
    
    StudyCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectCellIdentifier forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.image.image = [UIImage imageNamed:model.imageName];
    cell.title.text = model.title;
    
    if (Width_Screen == 320) {
        cell.withConst.constant = 25;
        cell.heightConst.constant = 25;
    }
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0: // 医院专家
        {
            FindExpertController *findVC = [[FindExpertController alloc] init];
            findVC.areaArray = self.areaArray;
            findVC.keshiArray = self.keShiArray;
            findVC.bingzhongArray = self.bingZhongArray;
            [self.navigationController pushViewController:findVC animated:YES];
        }
            break;
        case 1: // 科普宣教
        {
            ScienceEducationTypeVC *sEducationTypeVC = [[ScienceEducationTypeVC alloc] init];
            [self.navigationController pushViewController:sEducationTypeVC animated:YES];
        }
            break;
        case 2: // 患者咨询
        {
            PatientController *paVC = [[PatientController alloc] init];
            [self.navigationController pushViewController:paVC animated:YES];
        }
            break;
        default: // 名院名医
        {
            FamousHosViewController *famousVC = [[FamousHosViewController alloc] init];
            famousVC.levelArray = self.hosLevelArray;
            famousVC.areaArray = self.areaArray;
            [self.navigationController pushViewController:famousVC animated:YES];

        }
            break;
    }
}


#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PublicNewsListModel *model = self.dataSource[indexPath.row];
    
    NSInteger imgNum = model.ImageNum;
    NSString *groupCode = model.GroupCode;
    
    if ([groupCode isEqualToString:@"VideoLecturesMajor"]) {//视频
        
        StudyVideoCell *cellVideo = [tableView dequeueReusableCellWithIdentifier:kCellVideo forIndexPath:indexPath];
        [cellVideo setModel:model];
        return cellVideo;
    }
    else {
        switch (imgNum) {
            case 0://没有图片
            {
                StudyCellTwo *cellTwo = [tableView dequeueReusableCellWithIdentifier:kCellTwo forIndexPath:indexPath];
                [cellTwo setModel:model];
                return cellTwo;
            }
                break;
            case 1://一张图片
            {
                StudyCellOne *cellOne = [tableView dequeueReusableCellWithIdentifier:kCellOne forIndexPath:indexPath];
                [cellOne setModel:model];
                return cellOne;
            }
                break;
            case 3://三张图片
            {
                StudyCellThree *cellThree = [tableView dequeueReusableCellWithIdentifier:kCellThree forIndexPath:indexPath];
                [cellThree setModel:model];
                return cellThree;
            }
                break;
                
            default:
                break;
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PublicNewsListModel *model = self.dataSource[indexPath.row];
    NSInteger imgNum = model.ImageNum;
    NSString *groupCode = model.GroupCode;
    
    if ([groupCode isEqualToString:@"VideoLecturesMajor"]) {//视频
        return 280;
    }
    else {
        switch (imgNum) {
                break;
            case 1://一张图片
            {
                return 95;
            }
                break;
            case 3://三张图片
            {
                return 180;
            }
                break;
            default://没有图片
            {
                return 95;
            }
                break;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [StudyTabHeader shareStudyHeaderView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PublicNewsListModel *model = self.dataSource[indexPath.row];
    
    NSString *groupCode = model.GroupCode;
    
    if ([groupCode isEqualToString:@"VideoLecturesMajor"]) {//视频
        VideoSpecialDetailContentVC *vSDContentVC = [[VideoSpecialDetailContentVC alloc] init];
        vSDContentVC.model = model;
        [self.navigationController pushViewController:vSDContentVC animated:YES];
    }
    else if ([groupCode isEqualToString:@"MedicalCourseware"])  {
        // 进入医学课件
        PdfWebViewController *webVC = [[PdfWebViewController alloc] init];
        webVC.model = model;
        [self.navigationController pushViewController:webVC animated:YES];
    }
    else if ([groupCode isEqualToString:@"MedicalCongress"]) {
        //医学会议
        MedicalMeetWebDetailVC *webVC = [[MedicalMeetWebDetailVC alloc] init];
        webVC.model = model;
        [self.navigationController pushViewController:webVC animated:YES];
    }
    else {
        LearnWebController *webVC = [[LearnWebController alloc] init];
        webVC.model = model;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

#pragma mark - SDCycleScrollView Delegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    NSString *url = self.HrefArr[index];
    NSString *title = self.titlesArray[index];
    if ([Utils isBlankString:url]) {
        NSLog(@"链接为空");
//        [self showMessage:@"暂无网址链接~"];
    } else {
        
        CommonWebVC *webVC = [[CommonWebVC alloc] init];
        webVC.url = url;
        if (![Utils isBlankString:title]) {
            webVC.title = title;
        }
        [self.navigationController pushViewController:webVC animated:YES];
        
    }

}

- (void)addDataForCollect {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"yihuan" ofType:@"plist"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
    NSArray *arrays = dic[@"collectionview"];
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in arrays) {
        StudyCollectModel *model = [[StudyCollectModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [array addObject:model];
    }
    
    [self.CollectDataSource addObjectsFromArray:array];
    [self.sCollectionView reloadData];
}

#pragma mark - 获取首页最新资讯
- (void)requestLatestNewListData {
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCOpeType=%@",@"DocAndPat"];
    NSString *url = @"api/News/LatestNewList";
    
    self.pageSize = 10;//一次加载8条数据
    self.tableType = 1;//TableView表类
    self.baseTableView = self.sTableView;//将本类表 赋值给父类去操作
    [self showLoadding:@"" time:20];
    [self loadDataApi:url withParams:params refresh:RefreshTypeBoth model:PublicNewsListModel.class];
    
    //数据请求的回调
    WeakSelf
    self.baseFinishBlock = ^(NSArray *dataArray) {
        
        [wself requestHomeLunBoData];
    };
}

#pragma mark - 获取首页轮播图片
- (void)requestHomeLunBoData {
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCType=%@",@"2"];
    NSString *url = @"api/News/RepeatPic";
    
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"获取医患之家轮播图片 - %@", modelData);
        if (isSuccess) {
            
            [self.imagesArray removeAllObjects];
            [self.titlesArray removeAllObjects];
            
            NSArray *dataAry = modelData[@"JsonData"];
            
            for (NSDictionary *dic in dataAry) {
                [self.imagesArray addObject:dic[@"Uri"]];
                [self.titlesArray addObject:dic[@"Title"]];
                [self.HrefArr addObject:dic[@"Href"]];
            }
            // 加载延迟
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.cycleScrollView.imageURLStringsGroup = self.imagesArray;
            });
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

#pragma mark - 以下为传入医院专家需要的数据
#pragma mark - 地区
- (void)requestAllDiQuData {
    
    NSString *params = @"";
    NSString *url = @"API/Hospital/AreaCity";
    
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"医院专家地区查询条件 - %@", modelData);
        if (isSuccess) {
            
            NSArray *dataAry = modelData[@"JsonData"];
            
            NSArray *data = [NSArray modelArrayWithClass:HospitalExpertModel.class json:dataAry];
            
            [self.areaArray addObjectsFromArray:data];
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

#pragma mark - 所有科室
- (void)requestAllKeShiData {
    
    NSString *params = @"";
    NSString *url = @"API/Hospital/HospitalDepType";
    
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"所有科室 - %@", modelData);
        if (isSuccess) {
            
            NSArray *dataAry = modelData[@"JsonData"];
            
            NSArray *data = [NSArray modelArrayWithClass:KeShiModel.class json:dataAry];
            
            [self.keShiArray addObjectsFromArray:data];
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

#pragma mark - 全部病种
- (void)requestAllBingZhongData {
    
    NSString *params = @"";
    NSString *url = @"API/Hospital/HospitalDisease";
    
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"全部病种 - %@", modelData);
        if (isSuccess) {
            
            NSArray *dataAry = modelData[@"JsonData"];
            
            NSArray *data = [NSArray modelArrayWithClass:BingZhongModel.class json:dataAry];
            
            [self.bingZhongArray addObjectsFromArray:data];
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

#pragma mark - 医院等级
- (void)requestAllHosLevel {
    
    NSString *params = @"";
    NSString *url = @"API/Hospital/HospitalCLevel";
    
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"医院等级 - %@", modelData);
        if (isSuccess) {
            
            NSArray *dataAry = modelData[@"JsonData"];

            NSArray *data = [NSArray modelArrayWithClass:HosLevelModel.class json:dataAry];

            [self.hosLevelArray addObjectsFromArray:data];
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
        
        NSLog(@"hosLevelArray - %@", self.hosLevelArray);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
