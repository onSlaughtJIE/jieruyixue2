//
//  GroupApplyJoinController.m
//  JRMedical
//
//  Created by ww on 2016/12/14.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "GroupApplyJoinController.h"
#import "GroupApplyTopCell.h"
#import "GroupApplyZuweiCell.h"
#import "GroupOrganizeModel.h"
#import "OrgDetailModel.h"
#import "ChatViewController.h"
#import "OrganizeDetailController.h"
#import "JRLoginViewController.h"

@interface GroupApplyJoinController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSString *_groupId;
    EMGroup *_group;
    BOOL _isDown;
}

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIButton *applyBtn;

@property (nonatomic, strong) NSString *ownerName;
@property (nonatomic, strong) UILabel *groupTitleLab;
@property (nonatomic, strong) NSString *Remark; // 群组简介

@end

@implementation GroupApplyJoinController

- (instancetype)initWithGroupId:(NSString *)groupId
{
    self = [self initWithStyle:UITableViewStyleGrouped];
    if (self) {
        _groupId = groupId;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"";
    
    _isDown = YES;
    
    [self setTableViewInfo];
    
    [self setTableHeaderView];
    
    [self setTableFooterView];
    
    self.dataSource = [NSMutableArray array];
    
    //
    [self getGroupMessage];
    
    [self fetchGroupInfo];
    
    NSLog(@"这是点击群组后的第一个页面");
    
}

- (void)setTableViewInfo {
    
    self.tableView.separatorColor  = [UIColor clearColor];
    self.tableView.backgroundColor = BG_Color;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GroupApplyTopCell" bundle:nil] forCellReuseIdentifier:@"sectionOneCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GroupApplyZuweiCell" bundle:nil] forCellReuseIdentifier:@"sectionTwoCell"];
}



#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section ==0) {
        return 1;
    } else {
        return self.dataSource.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        GroupApplyTopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sectionOneCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.Remark.length > 0) {
            cell.infoLabel.text = self.Remark;
        } else {
            cell.infoLabel.text = @"暂无群组简介信息";
        }
        [cell.infoLabel textAlign:^(ZWMaker *make) {
            make.addAlignType(textAlignType_top);
        }];
        
        cell.xialaImageView.image = [UIImage imageNamed:@"shuangxia"];
        cell.xialaImageView.userInteractionEnabled = YES;
        if (_isDown) {
            cell.xialaImageView.transform = CGAffineTransformIdentity;
        } else {
            cell.xialaImageView.transform = CGAffineTransformMakeRotation(M_PI_2*2);
        }
        
        return cell;
        
    } else {
        
        GroupOrganizeModel *model = self.dataSource[indexPath.row];
        
        GroupApplyZuweiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sectionTwoCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.zhichengLab.text = model.OrganizingTypeName;
        
        NSArray *array = model.InfoList;
        NSLog(@"sadf;a 内部array -- %@", array);        
        [cell setGroupApplyZuweiCellWithModelArr:array];
        
        return cell;
        
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (!_isDown) {
            CGFloat contentW = Width_Screen - 20;
            UIFont *font = [UIFont systemFontOfSize:12];
            CGRect tmpRect = [self.Remark boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil];
            CGFloat contentH = tmpRect.size.height+20;
            return contentH;
        } else{
            return 80;
        }
        
    } else {
        return 50;
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        _isDown = !_isDown;
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
        [tableView reloadSections:indexSet withRowAnimation:(UITableViewRowAnimationAutomatic)];
        
    } else {
        
        GroupOrganizeModel *model = self.dataSource[indexPath.row];
        NSArray *array = model.InfoList;
        NSString *title = model.OrganizingTypeName;
        
        OrganizeDetailController *detailVC = [[OrganizeDetailController alloc] init];
        detailVC.title = title;
        detailVC.dataArray = array;
        
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *header = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, Width_Screen, 40))];
    header.backgroundColor = BG_Color;
    
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRectMake(20, 10, 200, 20))];
    label.backgroundColor = BG_Color;
    label.textColor = Main_Color;
    label.font = [UIFont boldSystemFontOfSize:15];
    [header addSubview:label];
    
    if (section == 0) {
        label.text = @"简    介";
    } else {
        
        if (self.dataSource.count == 0) {
            label.text = @"";
        } else {
            label.text = @"组 委 会";
        }
        
    }
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
 
    return 0.01;
}


- (void)setTableFooterView {
    
    UIView *footerView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, Width_Screen, 150))];
    footerView.backgroundColor = BG_Color;
    
    self.applyBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _applyBtn.frame = CGRectMake(30, 10, Width_Screen-60, 40);
    _applyBtn.layer.cornerRadius = 5;
    _applyBtn.layer.masksToBounds = YES;
    _applyBtn.backgroundColor = RGB(230, 79, 70); // 背景颜色
    _applyBtn.tintColor = [UIColor whiteColor]; // 字体颜色
    [_applyBtn setTitle:@"申请加入" forState:(UIControlStateNormal)];
    _applyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [_applyBtn addTarget:self action:@selector(applyGroup:) forControlEvents:(UIControlEventTouchUpInside)];
    [footerView addSubview:_applyBtn];
    
    self.tableView.tableFooterView = footerView;
    
}

- (void)setTableHeaderView {
    
    UIView *headerView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, Width_Screen, 150))];
    self.tableView.tableHeaderView = headerView;
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:(CGRectMake(0, 0, Width_Screen, 150))];
    backImageView.image = [UIImage imageNamed:@"groupBackground"];
    [headerView addSubview:backImageView];
    
    
    UIImageView *groupImageView = [[UIImageView alloc] init];
    [backImageView addSubview:groupImageView];
    [groupImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backImageView);
        make.centerY.equalTo(backImageView).offset(-20);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    groupImageView.layer.cornerRadius = 30;
    groupImageView.layer.masksToBounds = YES;
    [groupImageView sd_setImageWithURL:[NSURL URLWithString:_imageStr] placeholderImage:[UIImage imageNamed:@"groupPublicHeader"]];
    
    self.groupTitleLab = [[UILabel alloc] init];
    [backImageView addSubview:_groupTitleLab];
    [_groupTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backImageView);
        make.centerY.equalTo(backImageView).offset(25);
        make.size.mas_equalTo(CGSizeMake(300, 20));
    }];
    _groupTitleLab.textColor = [UIColor whiteColor];
    _groupTitleLab.font = [UIFont boldSystemFontOfSize:15];
    _groupTitleLab.textAlignment = NSTextAlignmentCenter;
    _groupTitleLab.text = (_group.subject && _group.subject.length) > 0 ? _group.subject : _group.groupId;;
    
    
    
}

- (void)applyGroup:(UIButton *)sender {
    
    NSLog(@"申请加入群组");
    
}

#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView cancelButtonIndex] != buttonIndex) {
        UITextField *messageTextField = [alertView textFieldAtIndex:0];
        NSString *messageStr = @"";
        if (messageTextField.text.length > 0) {
            messageStr = messageTextField.text;
        }
        [self applyJoinGroup:_groupId withGroupname:_group.subject message:messageStr];
    }
}


#pragma mark - action

- (BOOL)isJoined:(EMGroup *)group
{
//    NSArray *array = [[EMClient sharedClient].groupManager getMyGroupsFromServerWithError:nil];
    if (group) {
        NSArray *groupList = [[EMClient sharedClient].groupManager getJoinedGroups];
        for (EMGroup *tmpGroup in groupList) {
            if (tmpGroup.isPublic == group.isPublic && [group.groupId isEqualToString:tmpGroup.groupId]) {
                return YES;
            }
        }
    }
    
    return NO;
}

- (void)fetchGroupInfo
{
    // 当前顶层窗口

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self showHudInView:window hint:NSLocalizedString(@"loadData", @"Load data...")];
    __weak GroupApplyJoinController *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        EMGroup *group = [[EMClient sharedClient].groupManager fetchGroupInfo:_groupId includeMembersList:NO error:&error];
//        [self getUSerMessageWith:group.groupId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                _group = group;
                [weakSelf reloadSubviewsInfo];
            } else {
                NSLog(@"join group - error - %@ - %d", error.errorDescription, error.code);
//                [self showHint:@"未获得群组信息,可能由于账号重复登录导致,请您重新登录"];
            }
            [weakSelf hideHud];
        });
    });
    
}

- (void)reloadSubviewsInfo
{
    
    __weak GroupApplyJoinController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.groupTitleLab.text = (_group.subject && _group.subject.length) > 0 ? _group.subject : _group.groupId;
        weakSelf.navigationItem.title = weakSelf.groupTitleLab.text;
//        NSLog(@"description - %@", _group.description);
        if ([weakSelf isJoined:_group]) {
            [weakSelf.applyBtn setTitle:@"开始聊天" forState:UIControlStateNormal];
            [weakSelf.applyBtn addTarget:self action:@selector(chatGroupAction:) forControlEvents:(UIControlEventTouchUpInside)];
            
            
        }
        else{
            [weakSelf.applyBtn setTitle:@"加入群组" forState:UIControlStateNormal];
            [weakSelf.applyBtn addTarget:self action:@selector(joinAction) forControlEvents:(UIControlEventTouchUpInside)];
        }
        [weakSelf.tableView reloadData];
    });
    
}




- (void)chatGroupAction:(UIButton *)sender {

   
   ChatViewController *chatVC = [[ChatViewController alloc]
                                 initWithConversationChatter:_group.groupId
                                 conversationType:EMConversationTypeGroupChat];
   chatVC.title = _group.subject;
   
   [self.navigationController pushViewController:chatVC animated:YES];

    
}
                                           
- (void)showMessageAlertView {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定加入该群组"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel")
                                          otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}
                                           
                                           
- (void)joinAction
{
    
    if (_group.setting.style == EMGroupStylePublicJoinNeedApproval) {
        NSLog(@"**********1");
        [self showMessageAlertView];
        
    }
    else if (_group.setting.style == EMGroupStylePublicOpenJoin)
    {   NSLog(@"**********2");
        [self joinGroup:_groupId];
    }
    
}
                                           
- (void)joinGroup:(NSString *)groupId {
    
    [self showHudInView:self.view hint:NSLocalizedString(@"group.join.ongoing", @"join the group...")];
    __weak GroupApplyJoinController *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        [[EMClient sharedClient].groupManager joinPublicGroup:groupId error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!error) {
                [weakSelf hideHud];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } else {
                [weakSelf showHint:NSLocalizedString(@"group.join.fail", @"again failed to join the group, please")];
            }
        });
    });
    
//    [self JPushWithGroupApplyWithGroupID:groupId];
}
                                           
                                           
- (void)applyJoinGroup:(NSString *)groupId withGroupname:(NSString *)groupName message:(NSString *)message
{
    [self showHudInView:self.view hint:NSLocalizedString(@"group.sendingApply", @"send group of application...")];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        /**
         *  申请入群通知
         */
        NSLog(@"申请入群通知%@", message);
        [[EMClient sharedClient].groupManager applyJoinPublicGroup:groupId message:message error:nil];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideHud];
            if (!error) {
                [weakSelf showHint:NSLocalizedString(@"group.sendApplyRepeat", @"application has been sent")];
            }
            else{
                [weakSelf showHint:error.errorDescription];
            }
        });
    });
    
    [self JPushWithGroupApplyWithGroupID:groupId];
}


- (void)getGroupMessage {
    
    NSString *urlS = [NSString stringWithFormat:@"%@/api/IM/GetGroupInfo", Server_Int_Url];
    NSString *dataS = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCGroupID=%@", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI, _groupId, nil];
    NSString *dataEncrpyt = [TWDes encryptWithContent:dataS type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    NSDictionary *paraDic = @{kToken:token, kDatas:dataEncrpyt};
    
    [AFManegerHelp POST:urlS parameters:paraDic success:^(id responseObjeck) {
        
        if ([responseObjeck[@"Success"] integerValue] == 1) {
            
            [self.dataSource removeAllObjects];
            
            NSLog(@"获取群组信息 - %@", responseObjeck);
            
            NSDictionary *jsonData = responseObjeck[@"JsonData"];
            self.Remark = jsonData[@"Remark"];
            
            NSArray *array = jsonData[@"TypeList"];
            
            for (NSDictionary *dic in array) {
                GroupOrganizeModel *model = [[GroupOrganizeModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataSource addObject:model];
            }
            
            [self.tableView reloadData];
            
        } else {
            
            [self showHint:responseObjeck[@"Msg"]];
            
            if ([responseObjeck[@"Code"] integerValue] == 3) {
                
                [UserInfo removeAccessToken];//移除token
                [UserInfo removeDevIdentity];//移除单点登录
                NSUserDf_Set(kNoLogin,JRIsLogin);//修改登录状态
                NSUserDf_Remove(kDoctor);//移除是否是医师信息
                [UserInfo removeUserInfo];//移除用户信息
                EMError *error = [[EMClient sharedClient] logout:YES];
                if (!error) {
                    NSLog(@"环信退出成功");
                }
                NSUserDf_Set(nil, kHXName);
                NSUserDf_Set(nil, kHXPwd);
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5/*延迟执行时间*/ * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    JRLoginViewController *loginVC = [[JRLoginViewController alloc] init];
                    loginVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                    [self presentViewController:loginVC animated:YES completion:nil];
                });
                
                return ;
            }
            
            NSLog(@"cuowu%@", responseObjeck[@"Msg"]);
        }
        
        
        
    } failure:^(NSError *error) {
        NSLog(@"cuowu**%@", error);
    }];
}


// 暂时不用
/**
 *  获取用户昵称
 */
- (void)getUSerMessageWith:(NSString *)str {
    
    __weak typeof(self)weakSelf = self;
    NSString *urlS = [NSString stringWithFormat:@"%@/api/IM/GetGroupInfo", Server_Int_Url];
    NSString *dataS = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCGroupID=%@", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI,str, nil];
    NSString *dataEncrpyt = [TWDes encryptWithContent:dataS type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    NSDictionary *paraDic = @{kToken:token, kDatas:dataEncrpyt};
    
    [AFManegerHelp POST:urlS parameters:paraDic success:^(id responseObjeck) {
        
        NSLog(@"获取用户昵称 - %@", responseObjeck);

        if ([responseObjeck[@"Success"] integerValue] == 1) {
            NSArray *array = responseObjeck[@"JsonData"];
            for (NSDictionary *d in array) {
                weakSelf.ownerName = d[@"CustomerName"];

            }
        }
        [self.tableView reloadData];
        
        
    } failure:^(NSError *error) {
        NSLog(@"cuowu%@", error);
    }];
}

- (void)JPushWithGroupApplyWithGroupID:(NSString *)groupId {
    
    
    NSString *urlS = [NSString stringWithFormat:@"%@/api/im/JPushByGroupID", Server_Int_Url];
    NSString *dataS = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCGroupID=%@", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI, groupId, nil];
    NSString *dataEncrpyt = [TWDes encryptWithContent:dataS type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    NSDictionary *paraDic = @{kToken:token, kDatas:dataEncrpyt};
    
    [AFManegerHelp POST:urlS parameters:paraDic success:^(id responseObjeck) {
        NSLog(@"JPushWithGroupApplyWithGroupID - %@", responseObjeck);
        [self hideHud];
        if ([responseObjeck[@"Success"] integerValue] == 1) {
            
        }
        
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"cuowu%@", error);
    }];
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
