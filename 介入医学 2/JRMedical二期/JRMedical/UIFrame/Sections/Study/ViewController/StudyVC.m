//
//  StudyVC.m
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

#import "StudyVC.h"
#import <SDCycleScrollView.h>
#import "StudyCollectionCell.h"
#import "StudyCollectModel.h"
#import "StudyCellOne.h"
#import "StudyCellTwo.h"
#import "StudyCellThree.h"
#import "StudyVideoCell.h"
#import "StudyTabHeader.h"
#import "StudyTypeViewController.h"
#import "MedicalStoreController.h"
#import "SearchVC.h"
#import "MedicalMeetWebDetailVC.h"

#import "MedicalLiteratureTypeVC.h"
#import "BasicKnowledgeTypeVC.h"
#import "ClassicCaseTypeVC.h"
#import "StandardGuideTypeVC.h"
#import "NewsTypeVC.h"
#import "EquipmentSuppliesTypeVC.h"
#import "MedicalMeetTypeVC.h"
#import "VideoLectureVC.h"
#import "LearnWebController.h"
#import "LiveRootViewController.h"
#import "PublicNewsListModel.h"
#import "VideoSpecialDetailContentVC.h"
#import "PdfWebViewController.h"
#import "BingliRootViewController.h"
#import <YYKit.h>
#import "BingliModel.h"
#import "CommonWebVC.h"
#import "JPUSHService.h"


@interface StudyVC ()<UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) UITableView *sTableView;
@property (nonatomic, strong) UICollectionView *sCollectionView;
@property (nonatomic, strong) NSMutableArray *CollectDataSource; // 集合视图数据源

@property (nonatomic, strong) NSMutableArray *imagesArray; // 轮播图片
@property (nonatomic, strong) NSMutableArray *titlesArray; // 轮播标题
@property (nonatomic, strong) NSMutableArray *HrefArr;     // 轮播图跳转网址

@property (nonatomic, strong) NSMutableArray *bingliArr;   // 需要传输病例分类的数据

@end

@implementation StudyVC

-(void)viewWillAppear:(BOOL)animated{
    // 设置导航控制器的代理为self
    self.navigationController.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"学习园地";
    
    //添加一个view替换状态栏 颜色
    UIView *statusBar = [UIView new];
    statusBar.backgroundColor = Main_Color;
    statusBar.sd_layout.topEqualToView(self.view).widthIs(Width_Screen).heightIs(20);
    [self.view addSubview:statusBar];

    self.CollectDataSource = [NSMutableArray array];
    
    // 列表视图
    [self initsTableView];
    
    // 表头视图
    [self configHeaderView];
    
    //获取用户基本信息
    [self requestUserInfoData];

    //加载最新资讯
    [self requestLatestNewListData];
    
    //
    [self requestBingliPreData];
    
    // 设置别名
    [JPUSHService setAlias:NSUserDf_Get(kHXName) callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    NSLog(@"Alias - %@", NSUserDf_Get(kHXName));
}

- (void)configHeaderView {
    
    UIView *header = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, Width_Screen, Width_Screen/5*3+Height_SixteenToNine+2))];
    // 轮播图
    UIView *lunboView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width_Screen, Height_SixteenToNine)];
    [header addSubview:lunboView];
    
    self.imagesArray = [NSMutableArray array];
    self.titlesArray = [NSMutableArray array];
    self.HrefArr = [NSMutableArray array];
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:(CGRectMake(0, 0, Width_Screen, Height_SixteenToNine)) delegate:self placeholderImage:[UIImage imageNamed:@"jiazai"]];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    cycleScrollView.currentPageDotColor = Main_Color;
    cycleScrollView.pageDotColor = [UIColor whiteColor];
//    cycleScrollView.currentPageDotImage = [UIImage imageWithColor:Main_Color size:CGSizeMake(32, 6)];
//    cycleScrollView.pageDotImage = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(32, 6)];
    [lunboView addSubview:cycleScrollView];
    self.cycleScrollView = cycleScrollView;
    
    // 搜索框
//    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:(CGRectMake(5, 10, 250, 30))];
//    searchBar.placeholder = @"关键词/标题/病种/作者/综合搜索";
//    searchBar.alpha = 0.9;
//    searchBar.searchBarStyle = UISearchBarStyleMinimal;
//    searchBar.barTintColor = Main_Color;
//    [[UILabel appearanceWhenContainedIn:[UISearchBar class],nil]setTextColor:Main_Color];
//    searchBar.delegate = self;
//    [lunboView addSubview:searchBar];
//    [lunboView bringSubviewToFront:searchBar];
    
    UIImageView *search = [[UIImageView alloc] initWithFrame:(CGRectMake(5, 10, 230, 30))];
    search.image = [UIImage imageNamed:@"green_search"];
    search.userInteractionEnabled = YES;
    [search addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(main_search)]];
    [lunboView addSubview:search];
    
    // 消息铃铛
    UIImageView *xiaoxi = [[UIImageView alloc] initWithFrame:(CGRectMake(Width_Screen - 40, 12, 30, 30))];
    xiaoxi.image = [UIImage imageNamed:@"xiaoxi"];
    xiaoxi.userInteractionEnabled = YES;
    xiaoxi.hidden = YES;
    [xiaoxi bk_whenTapped:^{
        [self showMessage:@"功能正在建设中、敬请期待..."];
    }];
    [lunboView addSubview:xiaoxi];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:(CGRectMake(20, -2, 15, 15))];
    lab.text = @"10";
    lab.font = [UIFont systemFontOfSize:9];
    lab.backgroundColor = [UIColor redColor];
    lab.textColor = [UIColor whiteColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.layer.masksToBounds = YES;
    lab.layer.cornerRadius = 7.5;
    lab.hidden = YES;
    [xiaoxi addSubview:lab];
    
    // 集合视图
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumLineSpacing = 1; // 上下行间隔
    flowLayout.minimumInteritemSpacing = 0; // 左右item间隔
    
    
    if (Width_Screen == 375){
        flowLayout.itemSize = CGSizeMake((Width_Screen+1)/4, Width_Screen/5);
        self.sCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_cycleScrollView.frame), Width_Screen+1, Width_Screen/5*3+2) collectionViewLayout:flowLayout];
        
    } else if(Width_Screen == 414){
        flowLayout.itemSize = CGSizeMake((Width_Screen+2)/4, Width_Screen/5);
        self.sCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_cycleScrollView.frame), Width_Screen+2, Width_Screen/5*3+2) collectionViewLayout:flowLayout];
        
    } else {
        flowLayout.itemSize = CGSizeMake((Width_Screen)/4, Width_Screen/5);
        self.sCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_cycleScrollView.frame), Width_Screen, Width_Screen/5*3+2) collectionViewLayout:flowLayout];
    }
    
    self.sCollectionView.backgroundColor = BG_Color;
    self.sCollectionView.dataSource = self;
    self.sCollectionView.delegate = self;
    [self.sCollectionView registerNib:[UINib nibWithNibName:@"StudyCollectionCell" bundle:nil] forCellWithReuseIdentifier:kCollectCellIdentifier];
    [header addSubview:self.sCollectionView];
    // 集合视图数据
    [self addDataForCollect];
    
    self.sTableView.tableHeaderView = header;
}

- (void)initsTableView {
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, Width_Screen, Height_Screen) style:(UITableViewStylePlain)];
    tableview.contentInset = UIEdgeInsetsMake(0, 0, 69, 0);
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
        case 0: // 医学课件
        {
            StudyTypeViewController *typeVC = [[StudyTypeViewController alloc] init];
            [self.navigationController pushViewController:typeVC animated:YES];
        }
            break;
        case 1: // 视频讲座
        {
            VideoLectureVC *vLectureVC = [[VideoLectureVC alloc] init];
            [self.navigationController pushViewController:vLectureVC animated:YES];
        }
            break;
        case 2: // 医学文献
        {
            MedicalLiteratureTypeVC *mlTiteratypeVC = [[MedicalLiteratureTypeVC alloc] init];
            [self.navigationController pushViewController:mlTiteratypeVC animated:YES];
        }
            break;
        case 3: // 基础知识
        {
            BasicKnowledgeTypeVC *bKnowTypeVC = [[BasicKnowledgeTypeVC alloc] init];
            [self.navigationController pushViewController:bKnowTypeVC animated:YES];
        }
            break;
        case 4: // 医学会议
        {
            MedicalMeetTypeVC *mMeetTypeVC = [[MedicalMeetTypeVC alloc] init];
            [self.navigationController pushViewController:mMeetTypeVC animated:YES];
        }
            break;
        case 5: // 典型案例
        {
            ClassicCaseTypeVC *cCaseTypeVC = [[ClassicCaseTypeVC alloc] init];
            [self.navigationController pushViewController:cCaseTypeVC animated:YES];
        }
            break;
        case 6: // 规范指南
        {
            StandardGuideTypeVC *sGuideTypeVC = [[StandardGuideTypeVC alloc] init];
            [self.navigationController pushViewController:sGuideTypeVC animated:YES];
        }
            break;
        case 7: // 器械耗材
        {
            EquipmentSuppliesTypeVC *eSuppliesTypeVC = [[EquipmentSuppliesTypeVC alloc] init];
            [self.navigationController pushViewController:eSuppliesTypeVC animated:YES];
        }
            break;
        case 8: // 新闻资讯
        {
            NewsTypeVC *newsTypeVC = [[NewsTypeVC alloc] init];
            [self.navigationController pushViewController:newsTypeVC animated:YES];
        }
            break;
        case 9: // 医学商城
        {
            MedicalStoreController *storeVC = [[MedicalStoreController alloc] init];
            [self.navigationController pushViewController:storeVC animated:YES];
        }
            break;
        case 10: // 视频直播
        {
            LiveRootViewController *liveVC = [[LiveRootViewController alloc] init];
            [self.navigationController pushViewController:liveVC animated:YES];
        }
            break;
        
        default: // 病例分类
        {
            BingliRootViewController *bingliVC = [[BingliRootViewController alloc] init];
            bingliVC.picArr = self.bingliArr;
            [self.navigationController pushViewController:bingliVC animated:YES];
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
    
    NSLog(@"首页吧 model.Url - %@", model.Url);

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
        if (![Utils isBlankString:title]) {
            webVC.title = title;
        }
        webVC.url = url;
        [self.navigationController pushViewController:webVC animated:YES];
        
    }
 
}

#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)main_search {
    SearchVC *searchVC = [SearchVC new];
    searchVC.groupCode = @"";
    searchVC.searchType = @"1";
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)addDataForCollect {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"study" ofType:@"plist"];
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
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCOpeType=%@",@"study"];
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
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCType=%@",@"0"];
    NSString *url = @"api/News/RepeatPic";

    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"获取首页轮播图片 - %@", modelData);
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

#pragma mark - 获取个人信息
- (void)requestUserInfoData {
    
    NSString *params = @"";
    NSString *url = @"api/Customer/CustomerBasicData";
    
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"获取个人信息 - %@", modelData);
        if (isSuccess) {
            //存储用户信息
            [UserInfo updateUserInfo:modelData[@"JsonData"]];
            
            NSString *IsDoctor = modelData[@"JsonData"][@"IsReg"];
            NSUserDf_Set(IsDoctor, kDoctor);//是否是医师
            
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

// 病例分类 预加载
- (void)requestBingliPreData {
    
    self.bingliArr = [NSMutableArray array];
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCGroupCode=%@",@"CaseCatalogue"];
    NSString *url = @"api/Customer/GetDictList";
    
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"获取病例大分类 - %@", modelData);
        if (isSuccess) {
            
            NSArray *dataAry = modelData[@"JsonData"];
            
            for (NSDictionary *dic in dataAry) {
                BingliModel *model = [[BingliModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.bingliArr addObject:model];
            }
            
        }
        else {
            NSString *msg  = [modelData objectForKey:@"Msg"];
            if (msg!=nil && ![msg isEqual:@""]) {
//                [self showMessage:msg];
            }
            else {
//                [self showMessage:[NSString stringWithFormat:@"请求失败 #%d",code]];
            }
        }
    }];

    
}


- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    
    NSString *callbackString = [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode, tags, alias];
    
    NSLog(@"TagsAlias回调:%@", callbackString);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
