//
//  ZhiBoViewController.m
//  JRMedical
//
//  Created by ww on 2016/11/29.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "ZhiBoViewController.h"
#import "LiveTableViewCell.h"
#import "EasePublishModel.h"
#import "UCloudLiveViewController.h" // ucloud会议直播
#import <SDCycleScrollView.h>
#import "UITableView+EmpayData.h"

@interface ZhiBoViewController ()

@end

@implementation ZhiBoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    self.tableView.backgroundColor = BG_Color;
    self.tableView.separatorColor = BG_Color;
    [self.tableView registerNib:[UINib nibWithNibName:@"LiveTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    UIView *foot = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, Width_Screen, 60))];
    foot.backgroundColor = BG_Color;
    self.tableView.tableFooterView = foot;
    
    // 
    [self GetLiveVideoList];
    

}


#pragma mark - Table view datasource and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.dataSource == nil) {
        [tableView tableViewDisplayWitMsg:@"" ifNecessaryForRowCount:self.dataSource.count];
    }
    else {
        [tableView tableViewDisplayWitMsg:@"暂无相关信息!" ifNecessaryForRowCount:self.dataSource.count];
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EasePublishModel *model = self.dataSource[indexPath.row];
    
    LiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.layer.shadowColor = [UIColor blackColor].CGColor;// 阴影颜色
    cell.layer.shadowOffset = CGSizeMake(0, 0);// 偏移距离
    cell.layer.shadowOpacity = 0.5; // 不透明度
    cell.layer.shadowRadius = 5; // 半径
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setLiveTableViewCellWithModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 290;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EasePublishModel *model = self.dataSource[indexPath.row];
    // ucloud会议直播
    UCloudLiveViewController *ucloudVC = [[UCloudLiveViewController alloc] init];
    ucloudVC.model = model;

    
    [self.navigationController presentViewController:ucloudVC animated:YES completion:nil];
    
    
    
    
}


#pragma mark - 获取直播间列表
- (void)GetLiveVideoList {
    // Type	0回放，1直播，2预告
    NSString *url = @"api/LiveVideo/GetLiveVideoList";
    NSString *params = [NSString stringWithFormat:@"ZICBDYCType=%dZICBDYCVideoType=%@ZICBDYCLableValueLst=%@", 1, @"Meeting", @""];
    
    [self showLoadding:@"正在加载" time:20];
    [self loadDataApi:url withParams:params refresh:RefreshTypeBoth model:EasePublishModel.class];
    
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
