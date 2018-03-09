//
//  GroupSearchViewController.m
//  JRMedical
//
//  Created by ww on 2016/12/21.
//  Copyright © 2016年 idcby. All rights reserved.
//
#define kGroupCell @"groupCell"
#import "GroupSearchViewController.h"
#import "GroupSearchModel.h"
#import "GroupTableViewCell.h"
#import "GroupApplyJoinController.h"
#import "ChatViewController.h"

@interface GroupSearchViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *groupSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *groupSearchTab;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIAlertView *alertView;

@end

@implementation GroupSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"搜索群组";
    self.groupSearchBar.delegate = self;
    self.groupSearchBar.placeholder = @"请输入群名称搜索群组";
    
    // 找群cell
    [self.groupSearchTab registerNib:[UINib nibWithNibName:@"GroupTableViewCell" bundle:nil] forCellReuseIdentifier:@"groupCell"];
    //
    self.dataSource = [NSMutableArray array];
    
    // 进入成为第一响应者
    [self.groupSearchBar becomeFirstResponder];
    
    
}


#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupCell" forIndexPath:indexPath];
    GroupSearchModel *model = self.dataSource[indexPath.row];
    [cell setValueWithGroupSearchModle:model];
    return cell;
        
 
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GroupSearchModel *model = self.dataSource[indexPath.row];
    
    if (model.GroupCategory == 2) {
        
        // 社会群(不需要先加群)
        
        ChatViewController *chatVC = [[ChatViewController alloc]
                                      initWithConversationChatter:model.GroupID conversationType:EMConversationTypeGroupChat];
        chatVC.title = model.GroupName;
        chatVC.userid = model.GroupID;
        [self.navigationController pushViewController:chatVC animated:YES];
        
    } else {
        
        GroupApplyJoinController *applyVC = [[GroupApplyJoinController alloc] initWithGroupId:model.GroupID];
        applyVC.imageStr = model.Pic;
        applyVC.title = model.GroupName;
        [self.navigationController pushViewController:applyVC animated:YES];
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}


#pragma mark - UISearchBar Delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    self.groupSearchBar.showsCancelButton = YES;
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    NSLog(@"键盘点击搜索");
    self.groupSearchBar.showsCancelButton = NO;
    [self.groupSearchBar resignFirstResponder];
    // 综合查询接口
    [self groupSearch];
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    NSLog(@"取消搜索");
    self.groupSearchBar.showsCancelButton = NO;
    [self.groupSearchBar resignFirstResponder];
    
    [self.dataSource removeAllObjects];
    [self.groupSearchTab reloadData];
    self.groupSearchTab.backgroundView = nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.groupSearchBar.showsCancelButton = NO;
}

// 群组综合查询
- (void)groupSearch {

    NSInteger page = 0;
    NSString *urlS = [NSString stringWithFormat:@"%@/api/IM/GetGroup", Server_Int_Url];
    NSString *dataS = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@  ZICBDYCKeyword=%@ZICBDYCCurPage=%ldZICBDYCPageSize=%@", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI, _groupSearchBar.text, page, @200, nil];
    NSString *dataEncrpyt = [TWDes encryptWithContent:dataS type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    NSDictionary *paraDic = @{kToken:token, kDatas:dataEncrpyt};
    [SVProgressHUD show];
    
    [AFManegerHelp POST:urlS parameters:paraDic success:^(id responseObjeck) {
        
        [self.dataSource removeAllObjects];
        NSLog(@"群组综合查询 - %@", responseObjeck);
        if ([responseObjeck[@"Success"]integerValue] == 1) {
            
            [SVProgressHUD dismiss];
            NSArray *array = responseObjeck[@"JsonData"];
            for (NSDictionary *d in array) {
                GroupSearchModel *model = [[GroupSearchModel alloc]init];
                [model setValuesForKeysWithDictionary:d];
                [self.dataSource addObject:model];
            }
            
            if (self.dataSource.count == 0) {
                UILabel *label = [[UILabel alloc]initWithFrame:(CGRectMake(0, 0, Width_Screen, 40))];
                label.text = @"无相关群组";
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = [UIColor lightGrayColor];
                self.groupSearchTab.backgroundView = label;
                
            } else {
                self.groupSearchTab.backgroundView = nil;
            }
            
            [self.groupSearchTab reloadData];
            
        }else {
            [SVProgressHUD dismiss];
            NSLog(@"%@", responseObjeck[@"Msg"]);
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"搜索官方群 - 错误信息%@", error);
    }];

    
    
}

/*
// 查找官方群接口
- (void)searchPublicGroupWithType:(NSString *)type {
    NSLog(@"type - %@", type);
    NSInteger page = 0;
    NSString *urlS = [NSString stringWithFormat:@"%@/api/IM/GetIMListByGroup", Server_Int_Url];
    NSString *dataS = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@  ZICBDYCGroupType=%@ZICBDYCKeyword=%@ZICBDYCCurPage=%ldZICBDYCPageSize=%@", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI, @"", _groupSearchBar.text, page, @200, nil];
    NSString *dataEncrpyt = [TWDes encryptWithContent:dataS type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    NSDictionary *paraDic = @{kToken:token, kDatas:dataEncrpyt};
    [SVProgressHUD show];
    
    [AFManegerHelp POST:urlS parameters:paraDic success:^(id responseObjeck) {
        
        [self.dataSource removeAllObjects];
        NSLog(@"搜索官方群 - %@", responseObjeck);
        if ([responseObjeck[@"Success"]integerValue] == 1) {
            
            [SVProgressHUD dismiss];
            NSArray *array = responseObjeck[@"JsonData"];
            for (NSDictionary *d in array) {
                GroupModel *model = [[GroupModel alloc]init];
                [model setValuesForKeysWithDictionary:d];
                [self.dataSource addObject:model];
            }
     
            [self.groupSearchTab reloadData];
            
        }else {
            [SVProgressHUD dismiss];
            NSLog(@"%@", responseObjeck[@"Msg"]);
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"搜索官方群 - 错误信息%@", error);
    }];

}

// 查找学术群
- (void)searchStudyGroupWithType:(NSString *)type {
    
    NSLog(@"type - %@", type);
    NSInteger page = 0;
    NSString *urlS = [NSString stringWithFormat:@"%@/api/IM/GetStudyListByGroup", Server_Int_Url];
    NSString *dataS = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@  ZICBDYCGroupType=%@ZICBDYCKeyword=%@ZICBDYCCurPage=%ldZICBDYCPageSize=%@", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI, @"", _groupSearchBar.text, page, @200, nil];
    NSString *dataEncrpyt = [TWDes encryptWithContent:dataS type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    NSDictionary *paraDic = @{kToken:token, kDatas:dataEncrpyt};
    [SVProgressHUD show];
    
    [AFManegerHelp POST:urlS parameters:paraDic success:^(id responseObjeck) {
        
        [self.dataSource removeAllObjects];
        NSLog(@"搜索学术群 - %@", responseObjeck);
        if ([responseObjeck[@"Success"]integerValue] == 1) {
            
            [SVProgressHUD dismiss];
            NSArray *array = responseObjeck[@"JsonData"];
            for (NSDictionary *d in array) {
                GroupModel *model = [[GroupModel alloc]init];
                [model setValuesForKeysWithDictionary:d];
                [self.dataSource addObject:model];
            }
            
            [self.groupSearchTab reloadData];
            
        }else {
            [SVProgressHUD dismiss];
            NSLog(@"%@", responseObjeck[@"Msg"]);
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"搜索学术群 - 错误信息%@", error);
    }];
}

// 查找私有群
- (void)searchPrivateGroup {
    
    NSString *urlS = [NSString stringWithFormat:@"%@/api/IM/PrivateGroupLst", Server_Int_Url];
    NSString *dataS = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCkey=%@", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI, _groupSearchBar.text, nil];
    NSString *dataEncrpyt = [TWDes encryptWithContent:dataS type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    NSDictionary *paraDic = @{kToken:token, kDatas:dataEncrpyt};
    [SVProgressHUD show]; // 菊花转

    [AFManegerHelp POST:urlS parameters:paraDic success:^(id responseObjeck) {
        
        [self.dataSource removeAllObjects];
        NSLog(@"搜索私有群---%@", responseObjeck);
        if ([responseObjeck[@"Success"]integerValue] == 1) {
            
            [SVProgressHUD dismiss];
            NSArray *array = responseObjeck[@"JsonData"];
            for (NSDictionary *d in array) {
                SheHuiModel *model = [[SheHuiModel alloc]init];
                [model setValuesForKeysWithDictionary:d];
                [self.dataSource addObject:model];
            }

            [self.groupSearchTab reloadData];
            
        } else {
            [SVProgressHUD dismiss];
            NSLog(@"%@", responseObjeck[@"Msg"]);
        }
        
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"搜索私有群错误信息-%@", error);
    }];

    
}
 
 */
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
