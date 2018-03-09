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

#import "ApplyViewController.h"

#import "ApplyFriendCell.h"
#import "InvitationManager.h"
#import "LearnFVC.h"


static ApplyViewController *controller = nil;

@interface ApplyViewController ()<ApplyFriendCellDelegate>
{
    LearnFVC *_mainVC;
}


@end

@implementation ApplyViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _dataSource = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (instancetype)shareController
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[self alloc] initWithStyle:UITableViewStylePlain];
    });
    
    return controller;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.title = NSLocalizedString(@"title.apply", @"Application and notification");
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:(UIBarButtonItemStylePlain) target:self action:@selector(popViewControllerAnimated)];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    NSLog(@"这是申请与通知界面");
    [self loadDataSourceFromLocalDB];
}

- (void)popViewControllerAnimated {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

//    [self.tableView reloadData];
}



#pragma mark - getter

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (NSString *)loginUsername
{
    return [[EMClient sharedClient] currentUsername];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ApplyFriendCell";
    ApplyFriendCell *cell = (ApplyFriendCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[ApplyFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if(self.dataSource.count > indexPath.row)
    {
        ApplyEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
        
        if (entity) {
            cell.indexPath = indexPath;
            ApplyStyle applyStyle = [entity.style intValue];
            if (applyStyle == ApplyStyleGroupInvitation) {
                cell.titleLabel.text = NSLocalizedString(@"title.groupApply", @"Group Notification");
                cell.headerImageView.image = [UIImage imageNamed:@"groupPrivateHeader"];
            }
            else if (applyStyle == ApplyStyleJoinGroup)
            {
                NSLog(@"群组加入");
                cell.titleLabel.text = NSLocalizedString(@"title.groupApply", @"Group Notification");
                cell.headerImageView.image = [UIImage imageNamed:@"groupPrivateHeader"];
            }
            else if(applyStyle == ApplyStyleFriend){
                
                [cell setCellNameBy:entity];
                
                cell.headerImageView.image = [UIImage imageNamed:@"chatListCellHead"];
                cell.contentLabel.text = @"请求加你为好友";
            }
            cell.contentLabel.text = entity.reason;
        }
    }
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ApplyEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
    return [ApplyFriendCell heightWithContent:entity.reason];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - ApplyFriendCellDelegate

- (void)applyCellAddFriendAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.dataSource count]) {

        [self showHudInView:self.view hint:NSLocalizedString(@"sendingApply", @"sending apply...")];
        
        ApplyEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
        ApplyStyle applyStyle = [entity.style intValue];
        
        NSLog(@"--当前账号的%@", [[EMClient sharedClient] currentUsername]);
        NSLog(@"--邀请的信息%@", entity.applicantUsername);
        NSLog(@"--群ID%@", entity.groupId);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            EMError *error;
            NSArray *array = [[EMClient sharedClient].groupManager getMyGroupsFromServerWithError:nil];
            NSLog(@"%@", array);
            if (applyStyle == ApplyStyleGroupInvitation) {
                [[EMClient sharedClient].groupManager acceptInvitationFromGroup:entity.groupId inviter:entity.applicantUsername error:&error];
            }
            else if (applyStyle == ApplyStyleJoinGroup)
            {
                error = [[EMClient sharedClient].groupManager acceptJoinApplication:entity.groupId applicant:entity.applicantUsername];
            }
            else if(applyStyle == ApplyStyleFriend){
                error = [[EMClient sharedClient].contactManager acceptInvitationForUsername:entity.applicantUsername];
            }
            NSLog(@"错误信息%@", error.errorDescription);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideHud];
                if (!error) {
                    [self.dataSource removeObject:entity];
                    NSString *loginUsername = [[EMClient sharedClient] currentUsername];
                    [[InvitationManager sharedInstance] removeInvitation:entity loginUser:loginUsername];
                    [self.tableView reloadData];
                }
                else{
                    [self showHint:NSLocalizedString(@"acceptFail", @"accept failure")];
                }
            });
        });
    }
}

- (void)applyCellRefuseFriendAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.dataSource count]) {
        [self showHudInView:self.view hint:NSLocalizedString(@"sendingApply", @"sending apply...")];
        ApplyEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
        ApplyStyle applyStyle = [entity.style intValue];
        EMError *error;
        
        NSLog(@"当前账号的%@", [[EMClient sharedClient] currentUsername]);
        NSLog(@"申请人的信息%@", entity.applicantUsername);
        if (applyStyle == ApplyStyleGroupInvitation) {
            
            error = [[EMClient sharedClient].groupManager declineInvitationFromGroup:entity.groupId inviter:entity.applicantUsername reason:nil];
        }
        else if (applyStyle == ApplyStyleJoinGroup)
        {
            error = [[EMClient sharedClient].groupManager declineJoinApplication:entity.groupId applicant:entity.applicantUsername reason:nil];
        }
        else if(applyStyle == ApplyStyleFriend){
            [[EMClient sharedClient].contactManager declineInvitationForUsername:entity.applicantUsername];
        }
        
        [self hideHud];
        if (!error) {
            [self.dataSource removeObject:entity];
            NSString *loginUsername = [[EMClient sharedClient] currentUsername];
            [[InvitationManager sharedInstance] removeInvitation:entity loginUser:loginUsername];
            
            [self.tableView reloadData];
        }
        else{
            [self showHint:NSLocalizedString(@"rejectFail", @"reject failure")];
            [self.dataSource removeObject:entity];
            NSString *loginUsername = [[EMClient sharedClient] currentUsername];
            [[InvitationManager sharedInstance] removeInvitation:entity loginUser:loginUsername];
            
            [self.tableView reloadData];

        }
    }
}

#pragma mark - public

- (void)addNewApply:(NSDictionary *)dictionary
{
    NSLog(@"%@", dictionary);
    if (dictionary && [dictionary count] > 0) {
        NSString *applyUsername = [dictionary objectForKey:@"username"];
        ApplyStyle style = [[dictionary objectForKey:@"applyStyle"] intValue];
        
        if (applyUsername && applyUsername.length > 0) {
            for (int i = ((int)[_dataSource count] - 1); i >= 0; i--) {
                ApplyEntity *oldEntity = [_dataSource objectAtIndex:i];
                ApplyStyle oldStyle = [oldEntity.style intValue];
                if (oldStyle == style && [applyUsername isEqualToString:oldEntity.applicantUsername]) {
                    if(style != ApplyStyleFriend)
                    {
                        NSString *newGroupid = [dictionary objectForKey:@"groupname"];
                        if (newGroupid || [newGroupid length] > 0 || [newGroupid isEqualToString:oldEntity.groupId]) {
                            break;
                        }
                    }
                    
                    oldEntity.reason = [dictionary objectForKey:@"applyMessage"];
                    [_dataSource removeObject:oldEntity];
                    [_dataSource insertObject:oldEntity atIndex:0];
                    [self.tableView reloadData];
                    
                    return;
                }
            }
            
            //new apply
            ApplyEntity * newEntity= [[ApplyEntity alloc] init];
            newEntity.applicantUsername = [dictionary objectForKey:@"username"];
            newEntity.style = [dictionary objectForKey:@"applyStyle"];
            newEntity.reason = [dictionary objectForKey:@"applyMessage"];
            
            NSString *loginName = [[EMClient sharedClient] currentUsername];
            newEntity.receiverUsername = loginName;
            
            NSString *groupId = [dictionary objectForKey:@"groupId"];
            newEntity.groupId = (groupId && groupId.length > 0) ? groupId : @"";
            
            NSString *groupSubject = [dictionary objectForKey:@"groupname"];
            newEntity.groupSubject = (groupSubject && groupSubject.length > 0) ? groupSubject : @"";
            
            NSString *loginUsername = [[EMClient sharedClient] currentUsername];
            [[InvitationManager sharedInstance] addInvitation:newEntity loginUser:loginUsername];
            
            [_dataSource insertObject:newEntity atIndex:0];
            [self.tableView reloadData];

        }
    }
}

- (void)loadDataSourceFromLocalDB
{
    [_dataSource removeAllObjects];
    NSString *loginName = [self loginUsername];
    if(loginName && [loginName length] > 0)
    {
        NSArray * applyArray = [[InvitationManager sharedInstance] applyEmtitiesWithloginUser:loginName];
        [self.dataSource addObjectsFromArray:applyArray];
        
//        if (self.dataSource.count == 0) {
//            UILabel *label = [[UILabel alloc]initWithFrame:(CGRectMake(0, 0, Width_Screen, 40))];
//            label.text = @"暂无好友申请和通知";
//            label.textAlignment = NSTextAlignmentCenter;
//            label.textColor = [UIColor lightGrayColor];
//            self.tableView.backgroundView = label;
//            
//        }
        
        [self.tableView reloadData];
    }
}

- (void)back
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUntreatedApplyCount" object:nil];

    [self.navigationController popViewControllerAnimated:YES];
    self.hidesBottomBarWhenPushed = NO;
}


- (void)clear
{
    [_dataSource removeAllObjects];
    [self.tableView reloadData];
}

@end
