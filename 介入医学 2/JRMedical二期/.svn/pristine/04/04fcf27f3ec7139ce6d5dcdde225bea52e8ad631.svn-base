//
//  GroupMemberList.m
//  JRMedical
//
//  Created by apple on 16/6/26.
//  Copyright © 2016年 ZC. All rights reserved.
//

#import "GroupMemberList.h"
#import "GroupListModel.h"
#import "BaseTableViewCell.h"
#import "ChatViewController.h"
#import "MdetailController.h"
#import "YDetailController.h"


@interface GroupMemberList ()<UIAlertViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) EMGroup *group;
@property (nonatomic, assign) BOOL isOwner;
@property (nonatomic, strong) UIAlertView *alert;


@end

@implementation GroupMemberList


- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", _groupid);
    EMError *error = nil;
    self.group = [[EMClient sharedClient].groupManager fetchGroupInfo:_groupid includeMembersList:YES error:&error];
    if ([[[EMClient sharedClient] currentUsername] isEqualToString:_group.owner]) {
        NSLog(@"群主");
        _isOwner = YES;
    } else {
        _isOwner = NO;
    }
    self.title = @"群员列表";
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[BaseTableViewCell class] forCellReuseIdentifier:@"base"];
    
    [self getMemberMessag];
}


- (void)getMemberMessag{
//    EMError *error = nil;
//    EMGroup *group = [[EMClient sharedClient].groupManager fetchGroupInfo:_groupid includeMembersList:YES error:&error];
    NSArray *array = _group.occupants;
//    NSArray *array = @[@"1000250",@"1000233",@"1000251"];
    NSString *LisStr = [array componentsJoinedByString:@","];
    
    NSString *urlS = [NSString stringWithFormat:@"%@/api/IM/GetCustomerInfoByID", Server_Int_Url];
    NSString *dataS = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCID=%@", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI,LisStr, nil];
    NSString *dataEncrpyt = [TWDes encryptWithContent:dataS type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    NSDictionary *paraDic = @{kToken:token, kDatas:dataEncrpyt};
    
    [AFManegerHelp POST:urlS parameters:paraDic success:^(id responseObjeck) {
    
        NSLog(@"GroupMemberList - IM/GetCustomerInfoByID - %@", responseObjeck);
        
        if ([responseObjeck[@"Success"] integerValue] == 1) {
            NSArray *array = responseObjeck[@"JsonData"];
            for (NSDictionary *d in array) {
                GroupListModel *model = [[GroupListModel alloc]init];
                [model setValuesForKeysWithDictionary:d];
                [self.dataArray addObject:model];

            }
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"cuowu%@", error);
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupListModel *model = self.dataArray[indexPath.row];
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"base" forIndexPath:indexPath];
    cell.username = model.CustomerName;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.UserPic] placeholderImage:[UIImage imageNamed:@"chatListCellHead"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupListModel *model = self.dataArray[indexPath.row];
    
    if ([AFManegerHelp isYourFriendsWith:model.ID]) {
        
        // 是好友
        YDetailController *yVC = [[YDetailController alloc] init];
        yVC.userid = model.ID;
        [self.navigationController pushViewController:yVC animated:YES];
        
    } else {
        
        // 不是好友
        MdetailController *mdVC = [[MdetailController alloc]init];
        mdVC.userid = model.ID;
        [self.navigationController pushViewController:mdVC animated:YES];
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isOwner) {
        return YES;
    } else {
        return NO;
    }
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupListModel *model = self.dataArray[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        if ([model.ID isEqualToString:_group.owner]) {
            NSLog(@"你不能删除自己");
            _alert = [[UIAlertView alloc] initWithTitle:
                                                                @"你不能删除自己"
                                                                message:nil
                                                               delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [NSTimer scheduledTimerWithTimeInterval:0.9 target:self selector:@selector(dismissAlert) userInfo:nil repeats:NO];
            [_alert show];
        } else {
            [self.dataArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                EMError *error = nil;
                NSLog(@"删除了%@",model.ID );
                [[EMClient sharedClient].groupManager  removeOccupants:@[model.ID] fromGroup:_groupid error:&error];
            });
            
        }

        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
- (void)dismissAlert {
    
    [_alert dismissWithClickedButtonIndex:0 animated:YES];
    
    
    
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
