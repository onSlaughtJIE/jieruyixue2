//
//  XinxueListViewController.m
//  JRMedical
//
//  Created by ww on 2017/1/16.
//  Copyright © 2017年 idcby. All rights reserved.
//

#import "XinxueListViewController.h"
#import "MedicalCoursewareCell.h"
#import "PublicNewsListModel.h"
#import "UITableView+EmpayData.h"
#import <SDCycleScrollView.h>
#import "CaseCatalogueWebController.h"

@interface XinxueListViewController ()<UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *imagesArray; // 轮播图片
@property (nonatomic, strong) NSMutableArray *HrefArr;     // 轮播图跳转网址
@property (nonatomic, assign) CGFloat memoHeight;

@end

@implementation XinxueListViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setTableView];
    
    // 获取轮播图数据
    [self getLunBoData];
    // 创建轮播图
    [self setLunbo];
    
    // 列表数据
    [self requestList];
    // 计算简介高度
    [self getMemoHeight];
    
    
}

- (void)getMemoHeight {
    
    CGFloat contentW = Width_Screen - 20;
    UIFont *font = [UIFont systemFontOfSize:12];
    CGRect tmpRect = [self.memo boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil];
    CGFloat contentH = tmpRect.size.height+20;
    self.memoHeight = contentH;
}

- (void)setTableView {
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorColor = RGB(230, 230, 230);
    [self.tableView registerClass:[MedicalCoursewareCell class] forCellReuseIdentifier:NSStringFromClass([MedicalCoursewareCell class])];
    
    
}

- (void)setLunbo {
    
    UIView *backView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, Width_Screen, Height_SixteenToNine))];
    backView.backgroundColor = [UIColor whiteColor];
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:(CGRectMake(5, 5, Width_Screen-10, Height_SixteenToNine-10)) delegate:self placeholderImage:[UIImage imageNamed:@"jiazai"]];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    cycleScrollView.currentPageDotColor = Main_Color;
    cycleScrollView.pageDotColor = [UIColor whiteColor];
    cycleScrollView.imageURLStringsGroup = self.imagesArray;
    cycleScrollView.backgroundColor = [UIColor clearColor];
    [backView addSubview:cycleScrollView];
    
    self.tableView.tableHeaderView = backView;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    if (self.dataSource == nil) {
//        [tableView tableViewDisplayWitMsg:@"" ifNecessaryForRowCount:self.dataSource.count];
//    } else {
//        [tableView tableViewDisplayWitMsg:@"暂无相关数据!" ifNecessaryForRowCount:self.dataSource.count];
//    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PublicNewsListModel *model = self.dataSource[indexPath.row];
    
    MedicalCoursewareCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MedicalCoursewareCell class]) forIndexPath:indexPath];
    
    [cell setModel:model];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PublicNewsListModel *model = self.dataSource[indexPath.row];
    CaseCatalogueWebController *webVC = [[CaseCatalogueWebController alloc] init];
    webVC.model = model;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *sectionheader = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, Width_Screen, _memoHeight))];
    
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRectMake(10, 0, Width_Screen-20, _memoHeight))];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:12];
    label.text = self.memo;
    [sectionheader addSubview:label];
    
    return sectionheader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return self.memoHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}

#pragma mark - SDCycleScrollView Delegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
}

#pragma mark - 列表数据
- (void)requestList {
    
    NSString *url = @"api/CaseCatalogue/CaseCatalogueList";
    NSString *params = [NSString stringWithFormat:@"ZICBDYCLableID=%@", self.LableID];
    [self showLoadding:@"正在加载" time:20];
    [self loadDataApi:url withParams:params refresh:RefreshTypeBoth model:PublicNewsListModel.class];
    
}



#pragma mark - 获取首页轮播图片
- (void)getLunBoData {
    
    self.imagesArray = [NSMutableArray array];
    self.HrefArr = [NSMutableArray array];
    
    for (NSDictionary *dic in self.lunboArr) {
        
        NSString *uri = dic[@"Uri"];
        NSString *href = dic[@"Href"];
        [self.imagesArray addObject:uri];
        [self.HrefArr addObject:href];
        
    }
    
    
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
