//
//  MyCollectionNewsVC.m
//  JRMedical
//
//  Created by a on 16/12/22.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "MyCollectionNewsVC.h"

#import "PublicNewsListModel.h"
#import "MyCollectionCell.h"
#import "UITableView+EmpayData.h"

#import "LearnWebController.h"
#import "PdfWebViewController.h"
#import "MedicalMeetWebDetailVC.h"
#import "VideoSpecialDetailContentVC.h"

#import <YYKit.h>

@interface MyCollectionNewsVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MyCollectionNewsVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cleanCollectionNews" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //进入详情点击收藏按钮后的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isCollectionNewsClick) name:@"cleanCollectionNews" object:nil];
    
    [self.view addSubview:self.tableView];
    
    [self showLoadding:@"正在加载" time:20];
    [self requestListDataArrray];
}

#pragma mark -  进入详情点击收藏按钮后的通知
- (void)isCollectionNewsClick {
    self.isStartRefresh = YES;
    [self requestListDataArrray];
}

#pragma mark - 请求数据列表
- (void)requestListDataArrray {
    
    NSString *url = @"api/Customer/MyCollectionLst";
    NSString *params = [NSString stringWithFormat:@"ZICBDYCType=%@",@"News"];
    
    self.pageSize = 10;//一次加载8条数据
    self.tableType = 1;//TableView表类
    self.baseTableView = self.tableView;//将本类表 赋值给父类去操作
    [self loadDataApi:url withParams:params refresh:RefreshTypeBoth model:PublicNewsListModel.class];
}

#pragma mark - Table view datasource and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSource == nil) {
        [tableView tableViewDisplayWitMsg:@"" ifNecessaryForRowCount:self.dataSource.count];
    }
    else {
        [tableView tableViewDisplayWitMsg:@"您还没有收藏任何资讯信息!" ifNecessaryForRowCount:self.dataSource.count];
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PublicNewsListModel *model = self.dataSource[indexPath.row];
    MyCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyCollectionCell class]) forIndexPath:indexPath];
    [cell setModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}

#pragma mark  点击cell的响应的代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PublicNewsListModel *model = self.dataSource[indexPath.row];
    
    if ([model.GroupCode isEqualToString:@"MedicalCourseware"]) {//医学课件
        PdfWebViewController *webVC = [[PdfWebViewController alloc] init];
        webVC.model = model;
        [self.navigationController pushViewController:webVC animated:YES];
    }
    else if ([model.GroupCode isEqualToString:@"MedicalCongress"]) {//医学会议
        MedicalMeetWebDetailVC *webVC = [[MedicalMeetWebDetailVC alloc] init];
        webVC.model = model;
        [self.navigationController pushViewController:webVC animated:YES];
    }
    else if ([model.GroupCode isEqualToString:@"VideoLecturesMajor"]) {//视频
        
        NSString *params = [NSString stringWithFormat:@"ZICBDYCNewID=%@",model.ID];
        NSString *url = @"api/News/GetNewDetailByID";
        [self showLoadding:@"" time:20];
        [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
            NSLog(@"视频详情 - %@", modelData);
            if (isSuccess) {
                
                NSDictionary *data = modelData[@"JsonData"];
                
                model.IsShouCang  = [data[@"IsShouCang"] boolValue];
                model.PingJiaJiLu  = [data[@"PingJiaJiLu"] boolValue];
                model.ShouCangJiLu  = [data[@"ShouCangJiLu"] boolValue];
                model.Url = data[@"Url"];
                model.LaiYuan = data[@"LaiYuan"];
                model.VideoSpecialTitle  = data[@"VideoSpecialTitle"];
                model.IsDianZan  = [data[@"IsDianZan"] boolValue];
                model.TuPian1 = data[@"TuPian1"];
                model.GroupCode = data[@"GroupCode"];
                model.TuPian2 = data[@"TuPian2"];
                model.VideoSpecialID = data[@"VideoSpecialID"];
                model.VideoDep = data[@"VideoDep"];
                model.LiuLanJiLu = [data[@"LiuLanJiLu"] floatValue];
                model.TuPian3 = data[@"TuPian3"];
                model.VideoDocDesc = data[@"VideoDocDesc"];
                model.DianZhanShuLiang = [data[@"DianZhanShuLiang"] floatValue];
                model.ID = data[@"ID"];
                model.BiaoTi = data[@"BiaoTi"];
                model.ImageNum = [data[@"ImageNum"] integerValue];
                model.FaBiaoShiJian = data[@"FaBiaoShiJian"];
                model.VideoDoctor = data[@"VideoDoctor"];
                model.VideoHos = data[@"VideoHos"];
                model.VideoDocPic = data[@"VideoDocPic"];
                model.VideoPost = data[@"VideoPost"];
                model.VideoUri = data[@"VideoUri"];
                
                VideoSpecialDetailContentVC *vSDContentVC = [[VideoSpecialDetailContentVC alloc] init];
                vSDContentVC.model = model;
                [self.navigationController pushViewController:vSDContentVC animated:YES];
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
    else {//其他
        LearnWebController *webVC = [[LearnWebController alloc] init];
        webVC.model = model;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

#pragma mark  表的删除代理方法 --- 取消关注
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"取消收藏";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // //左滑删除
        PublicNewsListModel *model = self.dataSource[indexPath.row];
        NSString *params = [NSString stringWithFormat:@"ZICBDYCResourcesType=%@ZICBDYCResourcesID=%@",@"1",model.ID];
        NSString *url = @"api/News/AddCollection";
        [self showLoadding:@"" time:20];
        [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
            NSLog(@"收藏 - %@", modelData);
            if (isSuccess) {
                // //左滑删除
                [self.dataSource removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, Width_Screen, Height_Screen-108) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
        _tableView.backgroundColor = BG_Color;
        [_tableView registerClass:[MyCollectionCell class] forCellReuseIdentifier:NSStringFromClass([MyCollectionCell class])];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
