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

#import "ChatGroupDetailViewController.h"
#import "EMRemarkImageView.h"
#import "ContactSelectionViewController.h"
#import "GroupSettingViewController.h"
#import "EMGroup.h"
#import "ContactView.h"
#import "GroupBansViewController.h"
#import "GroupSubjectChangingViewController.h"
#import "GroupJianJieChangeViewController.h"
#import "SearchMessageViewController.h"
#import "GroupMemberList.h"
#import "ChatViewController.h"

#import "GroupListModel.h"
#import "MdetailController.h"
#import "YDetailController.h"

#import "GDeslCell.h"
#import "MyNewCell.h"

#pragma mark - ChatGroupDetailViewController

#define kColOfRow 5
#define kContactSize 60

@interface ChatGroupDetailViewController ()<EMGroupManagerDelegate, EMChooseViewDelegate, UIActionSheetDelegate>

- (void)unregisterNotifications;
- (void)registerNotifications;

@property (nonatomic) GroupOccupantType occupantType;
@property (strong, nonatomic) EMGroup *chatGroup;

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIButton *addButton;

@property (strong, nonatomic) UIView *footerView;
@property (strong, nonatomic) UIButton *clearButton;
@property (strong, nonatomic) UIButton *exitButton;
@property (strong, nonatomic) UIButton *dissolveButton;
@property (strong, nonatomic) UIButton *configureButton;
@property (strong, nonatomic) UILongPressGestureRecognizer *longPress;
@property (strong, nonatomic) ContactView *selectedContact;
@property (nonatomic, strong)  NSMutableArray *imageArr;

@property (nonatomic, strong) NSMutableArray *memberArray;

@property (nonatomic, assign) NSInteger mmnum;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) CGFloat height;

- (void)dissolveAction;
- (void)clearAction;
- (void)exitAction;
- (void)configureAction;

@end

@implementation ChatGroupDetailViewController
- (NSMutableArray *)imageArr {
    if (_imageArr == nil) {
        self.imageArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _imageArr;
}

- (NSMutableArray *)memberArray {
    if (_memberArray == nil) {
        self.memberArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _memberArray;
}

- (void)registerNotifications {
    [self unregisterNotifications];
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
}

- (void)unregisterNotifications {
    [[EMClient sharedClient].groupManager removeDelegate:self];
}

- (void)dealloc {
    [self unregisterNotifications];
}

- (instancetype)initWithGroup:(EMGroup *)chatGroup
{
    self = [super init];
    if (self) {
        // Custom initialization
        _chatGroup = chatGroup;
        _dataSource = [NSMutableArray array];
        _occupantType = GroupOccupantTypeMember;
        [self registerNotifications];
    }
    return self;
}

- (instancetype)initWithGroupId:(NSString *)chatGroupId
{
    EMGroup *chatGroup = nil;
//    NSArray *groupArray = [[EMClient sharedClient].groupManager getAllGroups];
    NSArray *groupArray = [[EMClient sharedClient].groupManager getJoinedGroups];
    for (EMGroup *group in groupArray) {
        if ([group.groupId isEqualToString:chatGroupId]) {
            chatGroup = group;
            break;
        }
    }

    if (chatGroup == nil) {
        chatGroup = [EMGroup groupWithId:chatGroupId];
    }
    
    self = [self initWithGroup:chatGroup];
    if (self) {
        //
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
  
    EMError *error;
    EMGroup *group = [[EMClient sharedClient].groupManager fetchGroupInfo:self.chatGroup.groupId includeMembersList:YES error:&error];
   
    self.occupantType = GroupOccupantTypeMember;
    NSString *loginUsername = [[EMClient sharedClient] currentUsername];
    if ([self.chatGroup.owner isEqualToString:loginUsername]) {
        self.occupantType = GroupOccupantTypeOwner;
    }
    
    if (self.occupantType != GroupOccupantTypeOwner) {
        for (NSString *str in self.chatGroup.members) {
            if ([str isEqualToString:loginUsername]) {
                self.occupantType = GroupOccupantTypeMember;
                break;
            }
        }
    }
    
    NSArray *array = group.occupants;
    
    NSLog(@"%lu",(unsigned long)array.count);
    
    if (self.occupantType == GroupOccupantTypeOwner || (self.chatGroup.setting.style == EMGroupStylePrivateMemberCanInvite && self.occupantType == GroupOccupantTypeMember)) {
//            _height = (CGFloat)(((array.count + 1) % 4.f) * 60);
        NSLog(@"%lu", (array.count + 1) % 5);
            if ((array.count + 1) % 5 == 0) {
                NSLog(@"yaoqing");
                _height = (CGFloat)(((array.count + 1) / 5) * 60);
                NSLog(@"^^^^%.f", _height);
            } else {
                _height = (CGFloat)(((array.count / 5) + 1) * 60);
            }
        } else {
            if (array.count % 5 == 0) {
                NSLog(@"ddddyaoqing");
                _height = (CGFloat)((array.count / 5) * 60);
                NSLog(@"^^^^%.f", _height);
            } else {
                NSLog(@"ddd33333---%lu", array.count / 5);
                _height = (CGFloat)(((array.count / 5) + 1) * 60);
            };
        }
    [self.tableView registerNib:[UINib nibWithNibName :@"GDeslCell" bundle:nil] forCellReuseIdentifier:@"GDeslCell"];
//    [self configureCollectionView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gochatView:) name:@"groupdianji" object:nil];
    
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:(UIBarButtonItemStylePlain) target:self action:@selector(popViewControllerAnimated)];
    
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    self.tableView.tableFooterView = self.footerView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupBansChanged) name:@"GroupBansChanged" object:nil];
    
    
    [self fetchGroupInfo];
}

- (void)popViewControllerAnimated {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)gochatView:(NSNotification *)sender {

    NSInteger index = [sender.userInfo[@"key"] integerValue];
    GroupListModel *model = self.memberArray[index];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark - getter
/**
 *  群成员显示
 */
- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 0, Width_Screen - 20, kContactSize)];
        _scrollView.tag = 0;
        
        _addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kContactSize - 10, kContactSize - 10)];
        
        [_addButton setImage:[UIImage imageNamed:@"group_participant_add"] forState:UIControlStateNormal];
        
        [_addButton setImage:[UIImage imageNamed:@"group_participant_addHL"] forState:UIControlStateHighlighted];
        
        [_addButton addTarget:self action:@selector(addContact:) forControlEvents:UIControlEventTouchUpInside];
        
        
//        _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteContactBegin:)];
//        _longPress.minimumPressDuration = 0.5;
    }
    
    return _scrollView;
}

- (UIButton *)clearButton
{
    if (_clearButton == nil) {
        _clearButton = [[UIButton alloc] init];
        [_clearButton setTitle:NSLocalizedString(@"group.removeAllMessages", @"remove all messages") forState:UIControlStateNormal];
        [_clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_clearButton addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
        [_clearButton setBackgroundColor:[UIColor colorWithRed:87 / 255.0 green:186 / 255.0 blue:205 / 255.0 alpha:1.0]];
    }
    
    return _clearButton;
}

- (UIButton *)dissolveButton
{
    if (_dissolveButton == nil) {
        _dissolveButton = [[UIButton alloc] init];
        [_dissolveButton setTitle:NSLocalizedString(@"group.destroy", @"dissolution of the group") forState:UIControlStateNormal];
        [_dissolveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_dissolveButton addTarget:self action:@selector(dissolveAction) forControlEvents:UIControlEventTouchUpInside];
        [_dissolveButton setBackgroundColor: [UIColor colorWithRed:191 / 255.0 green:48 / 255.0 blue:49 / 255.0 alpha:1.0]];
    }
    
    return _dissolveButton;
}

- (UIButton *)exitButton
{
    if (_exitButton == nil) {
        _exitButton = [[UIButton alloc] init];
        [_exitButton setTitle:NSLocalizedString(@"group.leave", @"quit the group") forState:UIControlStateNormal];
        [_exitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_exitButton addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];
        [_exitButton setBackgroundColor:[UIColor colorWithRed:191 / 255.0 green:48 / 255.0 blue:49 / 255.0 alpha:1.0]];
    }
    
    return _exitButton;
}
//
- (UIView *)footerView
{
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 160)];
        _footerView.backgroundColor = [UIColor clearColor];
        
        self.clearButton.frame = CGRectMake(0, 20, _footerView.frame.size.width, 40);
        
        [_footerView addSubview:self.clearButton];
        
        self.dissolveButton.frame = CGRectMake(0, CGRectGetMaxY(self.clearButton.frame) + 20, _footerView.frame.size.width , 40);
        
        self.exitButton.frame = CGRectMake(0, CGRectGetMaxY(self.clearButton.frame) + 20, _footerView.frame.size.width, 40);
    }
    
    return _footerView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.occupantType == GroupOccupantTypeOwner){
        if (section == 0) {
            return 2;
        } else  {
            return 3;
        }
    } else {
        if (section == 0) {
            return 2;
        } else  {
            return 3;
        }
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSString *numStr = [NSString stringWithFormat:@"%i / %i", (int)[_chatGroup.occupants count], (int)_chatGroup.setting.maxUsersCount];
            cell.textLabel.text = [NSString stringWithFormat:@"成员人数（%@）", numStr];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row == 1 ) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:self.scrollView];
        }
        [cell.contentView addSubview:_collectionView];

    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"群设置";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (indexPath.row == 1) {
            
            cell.textLabel.text = @"群名称";
            NSString *nameStr = [NSString stringWithFormat:@"%@", _chatGroup.subject];
            cell.detailTextLabel.text = nameStr;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        } else if (indexPath.row == 2) { // 群简介
            GDeslCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GDeslCell" forIndexPath:indexPath];
            NSString *desStr = [NSString stringWithFormat:@"%@", _chatGroup.description];
            cell.desl.text = desStr;
            [cell.desl textAlign:^(ZWMaker *make) {
                make.addAlignType(textAlignType_top);
            }];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    

    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 50;
        } else {
           return _height + 35;
        }
        
    }
    if (indexPath.section == 1) {
        
        if (indexPath.row == 2) {
            return 80;
        } else {
            return 50;
        }
       
    }
    return 0;
}

//返回区头大小
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSLog(@"群员列表");
            GroupMemberList *listVC = [[GroupMemberList alloc]init];
            listVC.groupid = _chatGroup.groupId;
            [self.navigationController pushViewController:listVC animated:YES];
        }
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            GroupSettingViewController *settingController = [[GroupSettingViewController alloc] initWithGroup:_chatGroup];
            [self.navigationController pushViewController:settingController animated:YES];
        }
        else if (indexPath.row == 1)
        {   // 修改群名称
            GroupSubjectChangingViewController *changingController = [[GroupSubjectChangingViewController alloc] initWithGroup:_chatGroup];
            [self.navigationController pushViewController:changingController animated:YES];
        }
        else if (indexPath.row == 2)
        {
//            NSInteger style = self.chatGroup.setting.style;
//            if (style == 0 || style == 1) { // 私有群
//                
//                // 修改群简介
//                GroupJianJieChangeViewController *jianChangeVC = [[GroupJianJieChangeViewController alloc] initWithGroup:_chatGroup];
//                jianChangeVC.title = @"修改群简介";
//                [self.navigationController pushViewController:jianChangeVC animated:YES];
//                
//            }
            
            GroupJianJieChangeViewController *jianChangeVC = [[GroupJianJieChangeViewController alloc] initWithGroup:_chatGroup];
            [self.navigationController pushViewController:jianChangeVC animated:YES];
                
            
        }
    }


//    else if (indexPath.row == 5) {
//        SearchMessageViewController *bansController = [[SearchMessageViewController alloc] initWithConversationId:_chatGroup.groupId conversationType:EMConversationTypeGroupChat];
//        [self.navigationController pushViewController:bansController animated:YES];
//    }
//    else if (indexPath.row == 6) {
//        GroupBansViewController *bansController = [[GroupBansViewController alloc] initWithGroup:_chatGroup];
//        [self.navigationController pushViewController:bansController animated:YES];
//    }
    
    
}

#pragma mark - EMChooseViewDelegate
- (BOOL)viewController:(EMChooseViewController *)viewController didFinishSelectedSources:(NSArray *)selectedSources
{
    NSLog(@"nihao%@", selectedSources);
    
    NSInteger maxUsersCount = _chatGroup.setting.maxUsersCount;
    // _chatGroup.occupantsCount deprecated: Use - membersCount
    if (([selectedSources count] + _chatGroup.membersCount) > maxUsersCount) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"group.maxUserCount", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        [alertView show];
        
        return NO;
    }
    
    [self showHudInView:self.view hint:NSLocalizedString(@"group.addingOccupant", @"add a group member...")];
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *source = [NSMutableArray array];
        for (NSString *username in selectedSources) {
            [source addObject:username];
        }
         NSLog(@"----nihao%@", source);
        
        NSString *username = [[EMClient sharedClient] currentUsername];
        NSString *messageStr = [NSString stringWithFormat:NSLocalizedString(@"group.somebodyInvite", @"%@ invite you to join group \'%@\'"), username, weakSelf.chatGroup.subject];
        EMError *error = nil;
        
        weakSelf.chatGroup = [[EMClient sharedClient].groupManager addOccupants:source toGroup:weakSelf.chatGroup.groupId welcomeMessage:messageStr error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                [weakSelf reloadDataSource];
                
            }
            else
            {
                [weakSelf hideHud];
                [weakSelf showHint:error.errorDescription];
            }
        
        });
    });
    
    return YES;
}

- (void)groupBansChanged
{
    [self.dataSource removeAllObjects];

    NSString *str = [self.chatGroup.occupants componentsJoinedByString:@","];
    [self getUSerMessageWithOptions:str];
    
    [self refreshScrollView];
}


- (void)getUSerMessageWithOptions:(NSString *)str {
    //    /IM/GetCustomerInfoByID
    NSString *urlS = [NSString stringWithFormat:@"%@/api/IM/GetCustomerInfoByID", Server_Int_Url];
    NSString *dataS = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCID=%@", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI,str, nil];
    NSString *dataEncrpyt = [TWDes encryptWithContent:dataS type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    NSDictionary *paraDic = @{kToken:token, kDatas:dataEncrpyt};
    
    [AFManegerHelp POST:urlS parameters:paraDic success:^(id responseObjeck) {
        
        if ([responseObjeck[@"Success"] integerValue] == 1) {
            NSArray *array = responseObjeck[@"JsonData"];
            for (NSDictionary *d in array) {
                GroupListModel *model = [[GroupListModel alloc]init];
                [model setValuesForKeysWithDictionary:d];
                [self.memberArray addObject:model];

                [self.dataSource addObject:d[@"CustomerName"]];
                [self.imageArr addObject:d[@"UserPic"]];
                [self refreshScrollView];
            }
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"cuowu%@", error);
    }];
}




#pragma mark - EMGroupManagerDelegate

- (void)didReceiveAcceptedGroupInvitation:(EMGroup *)aGroup
                                  invitee:(NSString *)aInvitee
{
    if ([aGroup.groupId isEqualToString:self.chatGroup.groupId]) {
        [self fetchGroupInfo];
    }
}

#pragma mark - data

- (void)fetchGroupInfo
{
    __weak typeof(self) weakSelf = self;
    [self showHudInView:self.view hint:NSLocalizedString(@"loadData", @"Load data...")];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        EMGroup *group = [[EMClient sharedClient].groupManager fetchGroupInfo:weakSelf.chatGroup.groupId includeMembersList:YES error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideHud];
            self.title = _chatGroup.subject;
//            NSLog(@"----%lu", (unsigned long)_chatGroup.occupants.count);
            _mmnum = _chatGroup.occupants.count;
        });
        if (!error) {
            weakSelf.chatGroup = group;
            EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:group.groupId type:EMConversationTypeGroupChat createIfNotExist:YES];
            if ([group.groupId isEqualToString:conversation.conversationId]) {
                NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithDictionary:conversation.ext];
                [ext setObject:group.subject forKey:@"subject"];
                [ext setObject:[NSNumber numberWithBool:group.isPublic] forKey:@"isPublic"];
                conversation.ext = ext;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf reloadDataSource];
            });
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf showHint:NSLocalizedString(@"group.fetchInfoFail", @"failed to get the group details, please try again later")];
            });
        }
    });
}

- (void)reloadDataSource
{
    [self.dataSource removeAllObjects];
    
    self.occupantType = GroupOccupantTypeMember;
    NSString *loginUsername = [[EMClient sharedClient] currentUsername];
    if ([self.chatGroup.owner isEqualToString:loginUsername]) {
        self.occupantType = GroupOccupantTypeOwner;
    }
    
    if (self.occupantType != GroupOccupantTypeOwner) {
        for (NSString *str in self.chatGroup.members) {
            if ([str isEqualToString:loginUsername]) {
                self.occupantType = GroupOccupantTypeMember;
                break;
            }
        }
    }
    
    NSString *str = [self.chatGroup.occupants componentsJoinedByString:@","];
    [self getUSerMessageWithOptions:str];
//    [self.dataSource addObjectsFromArray:self.chatGroup.occupants];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshScrollView];
        [self refreshFooterView];
        [self hideHud];
    });
}

- (void)refreshScrollView
{
//    NSInteger maxmm;
//    maxmm = 5;
    
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    [self.scrollView removeGestureRecognizer:_longPress];
    [self.addButton removeFromSuperview];
    
    BOOL showAddButton = NO;
    if (self.occupantType == GroupOccupantTypeOwner) {
//        maxmm = 4;
//        [self.scrollView addGestureRecognizer:_longPress];
        [self.scrollView addSubview:self.addButton];
        showAddButton = YES;
    }
    else if (self.chatGroup.setting.style == EMGroupStylePrivateMemberCanInvite && self.occupantType == GroupOccupantTypeMember) {
//        maxmm = 4;
        [self.scrollView addSubview:self.addButton];
        showAddButton = YES;
    }
    
    int tmp = ([self.dataSource count] + 1) % kColOfRow;
    int row = (int)([self.dataSource count] + 1) / kColOfRow;
    row += tmp == 0 ? 0 : 1;
    self.scrollView.tag = row;
    self.scrollView.frame = CGRectMake(5, 10, self.tableView.frame.size.width - 20, row * kContactSize);
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, row * kContactSize);
//    self.scrollView.backgroundColor = [UIColor redColor];

   
    
    NSString *loginUsername = [[EMClient sharedClient] currentUsername];
    
    int i = 0;
    int j = 0;
    BOOL isEditing = self.addButton.hidden ? YES : NO;
    BOOL isEnd = NO;
    for (i = 0; i < row; i++) {
        for (j = 0; j < kColOfRow; j++) {
            NSInteger index = i * kColOfRow + j;
//
//            if ([self.dataSource count] < maxmm) {
//                maxmm = self.dataSource.count;
//            }
//            NSLog(@"maxmm----%ld", (long)maxmm);
            if (index < self.dataSource.count) {
                NSString *username = [self.dataSource objectAtIndex:index];
                NSString *imageurl = [self.imageArr objectAtIndex:index];
//                NSLog(@"我测试的名字%@", username);
//                NSLog(@"666666%@", imageurl);
                ContactView *contactView = [[ContactView alloc] initWithFrame:CGRectMake(j * kContactSize, i * kContactSize, kContactSize, kContactSize)];
                contactView.index = i * kColOfRow + j;
//                contactView
                [contactView.newimagev sd_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage:[UIImage imageNamed:@"chatListCellHead"]];
                
//                contactView.image = [UIImage imageNamed:@"chatListCellHead.png"];
               
                
                contactView.remark = username;
                if (![username isEqualToString:loginUsername]) {
                    contactView.editing = isEditing;
                }
                
                __weak typeof(self) weakSelf = self;
                [contactView setDeleteContact:^(NSInteger index) {
                    [weakSelf showHudInView:weakSelf.view hint:NSLocalizedString(@"group.removingOccupant", @"deleting member...")];
                    NSArray *occupants = [NSArray arrayWithObject:[weakSelf.dataSource objectAtIndex:index]];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
                        EMError *error = nil;
                        EMGroup *group = [[EMClient sharedClient].groupManager removeOccupants:occupants fromGroup:weakSelf.chatGroup.groupId error:&error];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf hideHud];
                            if (!error) {
                                weakSelf.chatGroup = group;
                                [weakSelf.dataSource removeObjectAtIndex:index];
                                
                                [weakSelf refreshScrollView];
                            }
                            else{
                                [weakSelf showHint:error.errorDescription];
                            }
                        });
                    });
                }];
                
                [self.scrollView addSubview:contactView];
                
            }
            else{
                if(showAddButton && index == self.dataSource.count)
                {
//                    NSLog(@"%ld", (long)index);
                    self.addButton.frame = CGRectMake(j * kContactSize + 5, i * kContactSize + 10, kContactSize - 10, kContactSize - 10);
                }
                
                isEnd = YES;
                break;
            }
        }
        
        if (isEnd) {
            break;
        }
    }
    
    [self.tableView reloadData];
}



- (void)refreshFooterView
{

    
    NSLog(@"chatGroup.setting.style - %u", self.chatGroup.setting.style);
    NSInteger style = self.chatGroup.setting.style;
    
    if (style == 0 || style == 1) { // 私有群
        
        if (self.occupantType == GroupOccupantTypeOwner) {
            
            [_exitButton removeFromSuperview];
            [_footerView addSubview:self.dissolveButton];
            
        }
        else{
            [_dissolveButton removeFromSuperview];
            [_footerView addSubview:self.exitButton];
        }
        
    } else {
        
        // 官方群的群主解散群组的权限, 放到后台, 前端不提供
        if (self.occupantType == GroupOccupantTypeOwner) {
            
            [_exitButton removeFromSuperview];
            [_dissolveButton removeFromSuperview];
            
        }
        else{
            [_dissolveButton removeFromSuperview];
            [_footerView addSubview:self.exitButton];
        }
        
        
    }
    
    
}

#pragma mark - action

- (void)tapView:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded)
    {
        if (self.addButton.hidden) {
            [self setScrollViewEditing:NO];
        }
    }
}

- (void)deleteContactBegin:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan)
    {
        NSString *loginUsername = [[EMClient sharedClient] currentUsername];
        for (ContactView *contactView in self.scrollView.subviews)
        {
            CGPoint locaton = [longPress locationInView:contactView];
            if (CGRectContainsPoint(contactView.bounds, locaton))
            {
                if ([contactView isKindOfClass:[ContactView class]]) {
                    if ([contactView.remark isEqualToString:loginUsername]) {
                        return;
                    }
                    _selectedContact = contactView;
                    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"delete", @"deleting member..."), NSLocalizedString(@"friend.block", @"add to black list"), nil];
                    [sheet showInView:self.view];
                }
            }
        }
    }
}

- (void)setScrollViewEditing:(BOOL)isEditing
{
    NSString *loginUsername = [[EMClient sharedClient] currentUsername];
    
    for (ContactView *contactView in self.scrollView.subviews)
    {
        if ([contactView isKindOfClass:[ContactView class]]) {
            if ([contactView.remark isEqualToString:loginUsername]) {
                continue;
            }
            
            [contactView setEditing:isEditing];
        }
    }
    
    self.addButton.hidden = isEditing;
}

- (void)addContact:(id)sender
{
    ContactSelectionViewController *selectionController = [[ContactSelectionViewController alloc] initWithBlockSelectedUsernames:_chatGroup.occupants];
    
    selectionController.delegate = self;
    [self.navigationController pushViewController:selectionController animated:YES];
}

//清空聊天记录
- (void)clearAction
{
    __weak typeof(self) weakSelf = self;
    [EMAlertView showAlertWithTitle:NSLocalizedString(@"prompt", @"Prompt")
                            message:NSLocalizedString(@"sureToDelete", @"please make sure to delete")
                    completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
                        if (buttonIndex == 1) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveAllMessages" object:weakSelf.chatGroup.groupId];
                        }
                    } cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel")
                  otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
    
}


//解散群组
- (void)dissolveAction
{
    __weak typeof(self) weakSelf = self;
    [self showHudInView:self.view hint:NSLocalizedString(@"group.destroy", @"dissolution of the group")];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        
        EMError *nerror = nil;
        NSArray *myGroups = [[EMClient sharedClient].groupManager getMyGroupsFromServerWithError:&nerror];
        if (!nerror) {
            NSLog(@"获取成功 -- %@",myGroups);
        }
        
        EMError *error = nil;
        [[EMClient sharedClient].groupManager destroyGroup:weakSelf.chatGroup.groupId error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideHud];
            if (error) {
                NSLog(@"%@", error.errorDescription);
                [weakSelf showHint:NSLocalizedString(@"group.destroyFail", @"dissolution of group failure")];
            }
            else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ExitGroup" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"qunzushuxin" object:nil userInfo:nil];
            }
        });
    });
}

//设置群组
- (void)configureAction {
    // todo
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        [[EMClient sharedClient].groupManager ignoreGroupPush:weakSelf.chatGroup.groupId ignore:weakSelf.chatGroup.isPushNotificationEnabled];
    });
}

//退出群组
- (void)exitAction
{
    __weak typeof(self) weakSelf = self;
    [self showHudInView:self.view hint:NSLocalizedString(@"group.leave", @"quit the group")];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        EMError *error = nil;
        [[EMClient sharedClient].groupManager leaveGroup:weakSelf.chatGroup.groupId error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideHud];
            if (error) {
                [weakSelf showHint:NSLocalizedString(@"group.leaveFail", @"exit the group failure")];
            }
            else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ExitGroup" object:nil];
            }
        });
    });
}

- (void)didIgnoreGroupPushNotification:(NSArray *)ignoredGroupList error:(EMError *)error {
    // todo
    NSLog(@"ignored group list:%@.", ignoredGroupList);
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger index = _selectedContact.index;
    if (buttonIndex == 0)
    {
        //delete
        _selectedContact.deleteContact(index);
    }
    else if (buttonIndex == 1)
    {
        //add to black list
        [self showHudInView:self.view hint:NSLocalizedString(@"group.ban.adding", @"Adding to black list..")];
        NSArray *occupants = [NSArray arrayWithObject:[self.dataSource objectAtIndex:_selectedContact.index]];
        __weak ChatGroupDetailViewController *weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
            EMError *error = nil;
            EMGroup *group = [[EMClient sharedClient].groupManager blockOccupants:occupants
                                                                       fromGroup:weakSelf.chatGroup.groupId
                                                                           error:&error];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf hideHud];
                if (!error) {
                    weakSelf.chatGroup = group;
                    [weakSelf.dataSource removeObjectAtIndex:index];
                    [weakSelf refreshScrollView];
                }
                else{
                    [weakSelf showHint:error.errorDescription];
                }
            });
        });
    }
    _selectedContact = nil;
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    _selectedContact = nil;
}
@end
