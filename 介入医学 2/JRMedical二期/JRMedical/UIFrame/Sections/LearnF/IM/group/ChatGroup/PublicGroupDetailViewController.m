/************************************************************
  *  * Hyphenate CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2016 Hyphenate Inc. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of Hyphenate Inc.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from Hyphenate Inc.
  */

#import "PublicGroupDetailViewController.h"
#import "LearnFVC.h" 
#import "ChatViewController.h"

#import "UIImageView+WebCache.h"
#import "GroupOwnerCell.h"
#import "GroupZuWeiCell.h"
#import "GZuWeiModel.h"

@interface PublicGroupDetailViewController ()<UIAlertViewDelegate>

@property (strong, nonatomic) NSString *groupId;
@property (strong, nonatomic) EMGroup *group;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIView *footerView;
@property (strong, nonatomic) UIButton *footerButton;

@property (strong, nonatomic) UILabel *nameLabel;

@property (nonatomic, strong) NSString *ownerName;
@property (nonatomic, strong) NSMutableArray *dataSource;


@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) BOOL isFlick;

@property (nonatomic,strong) NSIndexPath *expandIndapth;

@end

@implementation PublicGroupDetailViewController

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        self.dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

- (instancetype)initWithGroupId:(NSString *)groupId
{
    self = [self initWithStyle:UITableViewStylePlain];
    if (self) {
        _groupId = groupId;
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getGroupMessage];
    
    
    self.tableView.delaysContentTouches = NO;

    
    // Uncomment the following line to preserve selection between presentations.
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    
    _footerButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    
    _footerButton.frame = CGRectMake(40, 20, _footerView.frame.size.width - 80, 40);
    
    _footerButton.layer.cornerRadius = 5;
    _footerButton.layer.masksToBounds = YES;
   
    [_footerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_footerButton setBackgroundColor:[UIColor colorWithRed:87 / 255.0 green:186 / 255.0 blue:205 / 255.0 alpha:1.0]];
    [self.tableView.tableFooterView addSubview:_footerButton];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GroupOwnerCell" bundle:nil] forCellReuseIdentifier:@"GroupOwnerCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GroupZuWeiCell" bundle:nil] forCellReuseIdentifier:@"GroupZuWeiCell"];
    

    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:(UIBarButtonItemStylePlain) target:self action:@selector(popViewControllerAnimated)];
    
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    [self fetchGroupInfo];
}
- (void)popViewControllerAnimated {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter

- (UIView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
        _headerView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
//        imageView.image = [UIImage imageNamed:@"groupPublicHeader"];
        [imageView sd_setImageWithURL:[NSURL URLWithString:_imageStr] placeholderImage:[UIImage imageNamed:@"groupPublicHeader"]];
        [_headerView addSubview:imageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, _headerView.frame.size.width - 80 - 10, 50)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.text = (_group.subject && _group.subject.length) > 0 ? _group.subject : _group.groupId;
        _nameLabel.numberOfLines = 0;
        
        [_headerView addSubview:_nameLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _headerView.frame.size.height - 0.5, Width_Screen, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [_headerView addSubview:line];
    }
    
    return _headerView;
}

- (UIView *)footerView
{
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width_Screen, 80)];
        _footerView.backgroundColor = [UIColor whiteColor];
//
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(5, 0, _footerView.frame.size.width - 10, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [_footerView addSubview:line];
    }

    return _footerView;
}
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
        
        NSLog(@"PublicGroupDetailViewController - 获取用户昵称 - %@", responseObjeck);

        if ([responseObjeck[@"Success"] integerValue] == 1) {
            NSArray *array = responseObjeck[@"JsonData"];
            for (NSDictionary *d in array) {
                weakSelf.ownerName = d[@"CustomerName"];

            }
        }
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"cuoxu%@", error);
    }];
}



- (void)getGroupMessage {
    [self.dataSource removeAllObjects];
    NSString *urlS = [NSString stringWithFormat:@"%@/api/IM/GetGroupInfo", Server_Int_Url];
    NSString *dataS = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCGroupID=%@", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI,_groupId, nil];
    NSString *dataEncrpyt = [TWDes encryptWithContent:dataS type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    NSDictionary *paraDic = @{kToken:token, kDatas:dataEncrpyt};
    
    [AFManegerHelp POST:urlS parameters:paraDic success:^(id responseObjeck) {
        
        NSLog(@"PublicGroupDetailViewController - IM/GetGroupInfo - %@", responseObjeck);

        NSArray *array = responseObjeck[@"JsonData"];
        NSDictionary *dic = [array firstObject];
        NSArray *memArray = dic[@"GroupOrganizing"];
        for (NSDictionary *d in memArray) {
            GZuWeiModel *model = [[GZuWeiModel alloc]init];
            [model setValuesForKeysWithDictionary:d];
            [self.dataSource addObject:model];
        }
        if (_dataSource.count < 6) {
            self.height = (Width_Screen - 30) / 5 + 10;
        }
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"cuoxu*%@", error);
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GroupOwnerCell";

    if (indexPath.row == 0) {
        GroupOwnerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.titleLabel.text = NSLocalizedString(@"group.owner", @"Owner");
        cell.desLabel.text = _ownerName;
        return cell;
    }
    else if (indexPath.row == 1) {
        GroupOwnerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.titleLabel.text = NSLocalizedString(@"group.describe", @"Describe");
        cell.desLabel.text = _group.description;
        return cell;
    } else {
    
        GroupZuWeiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupZuWeiCell" forIndexPath:indexPath];
        cell.dataSource = _dataSource;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.collectionView reloadData];
        return cell;
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 40;
    }
    else if (indexPath.row == 1) {
        CGRect rect  = [_group.description boundingRectWithSize:CGSizeMake(Width_Screen - 80, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
        return rect.size.height > 30 ? (10 + rect.size.height) : 40;
    } else if (indexPath.row == 2) {
        if (_isFlick) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
            [dic setValue:@"nihao" forKey:@"ture"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changefangxian" object:nil userInfo:dic];
            
            if (_dataSource.count % 5 == 0) {
                return (CGFloat)((_dataSource.count / 5) *((Width_Screen - 30) / 5) + 57 );
            } else {
                return (CGFloat)(((_dataSource.count / 5) + 1) *( (Width_Screen - 30) / 5) + 62);
            }
        } else {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
            [dic setValue:@"buhao" forKey:@"ture"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changefangxian" object:nil userInfo:dic];
            return (Width_Screen - 30) / 5 + 60;
        }
    } else {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        _isFlick = !_isFlick;
        [self.tableView beginUpdates];
//        _isFlick = YES;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
        
    }
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
//        NSArray *groupList = [[EMClient sharedClient].groupManager getAllGroups];
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
    [self showHudInView:self.view hint:NSLocalizedString(@"loadData", @"Load data...")];
    __weak PublicGroupDetailViewController *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        EMGroup *group = [[EMClient sharedClient].groupManager fetchGroupInfo:weakSelf.groupId includeMembersList:NO error:&error];
//        [self getUSerMessageWith:group.owner];
        [self getUSerMessageWith:group.groupId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                weakSelf.group = group;
                [weakSelf reloadSubviewsInfo];
            }
            [weakSelf hideHud];
        });
    });
}

- (void)reloadSubviewsInfo
{
    __weak PublicGroupDetailViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.nameLabel.text = (weakSelf.group.subject && weakSelf.group.subject.length) > 0 ? weakSelf.group.subject : weakSelf.group.groupId;
        if ([weakSelf isJoined:weakSelf.group]) {
            [weakSelf.footerButton setTitle:@"开始聊天" forState:UIControlStateNormal];
            [weakSelf.footerButton addTarget:self action:@selector(chatGroupAction:) forControlEvents:(UIControlEventTouchUpInside)];
            
            
        }
        else{
            [weakSelf.footerButton setTitle:@"加入群组" forState:UIControlStateNormal];
            [weakSelf.footerButton addTarget:self action:@selector(joinAction) forControlEvents:(UIControlEventTouchUpInside)];
        }
        [weakSelf.tableView reloadData];
    });
}




- (void)chatGroupAction:(UIButton *)sender {
#ifdef REDPACKET_AVALABLE
    RedPacketChatViewController *chatVC = [[RedPacketChatViewController alloc]
#else
    ChatViewController *chatVC = [[ChatViewController alloc]
#endif
    
                                  initWithConversationChatter:self.group.groupId
                                  conversationType:EMConversationTypeGroupChat];
    chatVC.title = self.group.subject;
    
    [self.navigationController pushViewController:chatVC animated:YES];

}

- (void)showMessageAlertView
{
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
    if (self.group.setting.style == EMGroupStylePublicJoinNeedApproval) {
        NSLog(@"**********1");
        [self showMessageAlertView];
        
    }
    else if (self.group.setting.style == EMGroupStylePublicOpenJoin)
    {   NSLog(@"**********2");
        [self joinGroup:_groupId];
    }
}

- (void)joinGroup:(NSString *)groupId
{
    
    [self showHudInView:self.view hint:NSLocalizedString(@"group.join.ongoing", @"join the group...")];
    __weak PublicGroupDetailViewController *weakSelf = self;
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
    
}
                                           
                                           

@end
