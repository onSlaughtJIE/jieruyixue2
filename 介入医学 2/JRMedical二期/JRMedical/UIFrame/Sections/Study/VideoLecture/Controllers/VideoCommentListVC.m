//
//  VideoCommentListVC.m
//  JRMedical
//
//  Created by a on 16/11/17.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "VideoCommentListVC.h"

#import "VideoCommentListCell.h"
#import "SpCommentModel.h"
#import "UITableView+EmpayData.h"

@interface VideoCommentListVC ()

@end

@implementation VideoCommentListVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 70, 0, 0);
    self.tableView.backgroundColor = BG_Color;
    [self.tableView registerClass:[VideoCommentListCell class] forCellReuseIdentifier:NSStringFromClass([VideoCommentListCell class])];
    self.tableView.scrollEnabled = NO;
    
    //评论成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PingLunSuccessClick) name:@"PingLunSuccess" object:nil];
    
    [self requestListDataArrray];//请求数据列表
}

#pragma mark - 评论成功的通知 再次请求刷新评论列表
-(void)PingLunSuccessClick {
    [self requestListDataArrray];
}

#pragma mark - 请求数据列表
- (void)requestListDataArrray {
    
    NSString *url = @"api/News/EvaluateList";
    NSString *params = [NSString stringWithFormat:@"ZICBDYCResourcesType=%@ZICBDYCResourcesID=%@",@"1",self.videoId];
    
    self.pageSize = 10;
    [self loadDataApi:url withParams:params refresh:RefreshTypeBoth model:SpCommentModel.class];
    
    //数据请求的回调
    self.baseFinishBlock = ^(NSArray *dataArray) {
        
        NSMutableDictionary *allInfoDic = [[NSMutableDictionary alloc] init];
        [allInfoDic setObject:@(dataArray.count) forKey:@"PingLunNum"];
        [allInfoDic setObject:dataArray forKey:@"PingLunAry"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeVideoPingLunDetailsHeight" object:nil userInfo:allInfoDic];
    };
}

#pragma mark - Table view datasource and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSource == nil) {
        [tableView tableViewDisplayWitMsg:@"" ifNecessaryForRowCount:self.dataSource.count];
    }
    else {
        [tableView tableViewDisplayWitMsg:@"" ifNecessaryForRowCount:self.dataSource.count];
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SpCommentModel *model = self.dataSource[indexPath.row];
    VideoCommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VideoCommentListCell class]) forIndexPath:indexPath];
    [cell setModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SpCommentModel *model = self.dataSource[indexPath.row];
    
    CGRect contentHeight = [Utils getTextRectWithString:model.ResourcesContent withWidth:Width_Screen-80 withFontSize:14.5];
    
    CGFloat height = 20+14+5+contentHeight.size.height;
    
    if (height < 60) {
        height = height + (60 - height);
    }
    
    return height;
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
