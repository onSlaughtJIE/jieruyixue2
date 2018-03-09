//
//  PatientController.m
//  JRMedical
//
//  Created by apple on 16/6/28.
//  Copyright © 2016年 ZC. All rights reserved.
//

#import "PatientController.h"
#import "PatientAskCell.h"
#import "PatientAskModel.h"
#import "PatientTiwenController.h"
#import "UITableView+EmpayData.h"

@interface PatientController ()<UITextViewDelegate>

{
    MBProgressHUD *HUD;
}


@end

@implementation PatientController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"患者咨询";
    
    self.tableView.backgroundColor = BG_Color;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"PatientAskCell" bundle:nil] forCellReuseIdentifier:@"askCell"];
    
    
    
    // 估算高度(平均高度)
    self.tableView.estimatedRowHeight = 120;
    // 自动测量
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提问" style:UIBarButtonItemStylePlain target:self action:@selector(askAction:)];
    
//    [self setRefresh];
    
    [self readData];
    
}

- (void)askAction:(UIBarButtonItem *)sender {
    
    PatientTiwenController *askVC = [[PatientTiwenController alloc] init];
    
    askVC.title = @"问题咨询";
    
    [self.navigationController pushViewController:askVC animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
}

#pragma mark - 患者咨询 > 获取问答列表
- (void)readData {
    

    
    /*
    NSString *urlS = [NSString stringWithFormat:@"%@/api/Post/CustomerQALst", Server_Int_Url];
    NSString *dataS = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCCurPage=%dZICBDYCPageSize=%d", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI, 0, 20, nil];
    NSString *dataEncrpyt = [TWDes encryptWithContent:dataS type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    NSDictionary *paraDic = @{kToken:token, kDatas:dataEncrpyt};
    
    [self showHudInView:self.view hint:@""];
    [AFManegerHelp POST:urlS parameters:paraDic success:^(id responseObjeck) {
        NSLog(@"CustomerQALst患者咨询列表 - %@", responseObjeck);
        [self hideHud];
        if ([responseObjeck[@"Success"] integerValue] == 1) {
            
            if (_page == 0) {
                [self.dataSource removeAllObjects];
            }
            
            NSArray *jsonArr = responseObjeck[@"JsonData"];
            
            for (NSDictionary *dic in jsonArr) {
                
                PatientAskModel *model = [[PatientAskModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataSource addObject:model];
            }
            
            if (_page == 0) {
                [self.askTableView.mj_header endRefreshing];
                
            } else {
                if (jsonArr.count == 0) {
                    [self.askTableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self.askTableView.mj_footer endRefreshing];
                }
            }
            
            [self.askTableView reloadData];
            
            
        }else {
            [self.askTableView.mj_header endRefreshing];
            [self showHint:responseObjeck[@"Msg"]];
        }
        
    } failure:^(NSError *error) {
        [self hideHud];
        [self.askTableView.mj_header endRefreshing];
        [self showHint:@"连接不到服务器"];
    }];
*/
    [self showLoadding:@"正在加载" time:20];
    [self loadDataApi:@"/api/Post/CustomerQALst" withParams:nil refresh:RefreshTypeBoth model:PatientAskModel.class];
    
    
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (self.dataSource == nil) {
        [tableView tableViewDisplayWitMsg:@"" ifNecessaryForRowCount:self.dataSource.count];
    }
    else {
        [tableView tableViewDisplayWitMsg:@"暂无信息!" ifNecessaryForRowCount:self.dataSource.count];
    }
    return self.dataSource.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PatientAskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"askCell" forIndexPath:indexPath];
    
    PatientAskModel *model = self.dataSource[indexPath.row];
    
    [cell setDataWithModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)showHUDWithText:(NSString *)showText
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = showText;
    HUD.mode = MBProgressHUDModeText;
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(0.8);
    } completionBlock:^{
        [HUD removeFromSuperview];
        HUD = nil;
    }];
}

/*
- (void)setRefresh {
    self.page = 0;
    __block typeof(self)weakself = self;
    self.askTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself.askTableView.mj_footer resetNoMoreData];
        weakself.page = 0;
        [weakself readData];
    }];
    
    self.askTableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        
        weakself.page += 1;
        [weakself readData];
        
    }];
    
    // 进入界面时刷新
    [self.askTableView.mj_header beginRefreshing];
}
*/


@end
