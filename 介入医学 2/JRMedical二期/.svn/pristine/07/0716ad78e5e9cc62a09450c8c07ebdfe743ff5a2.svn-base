//
//  IMFindViewController.m
//  JRMedical
//
//  Created by ww on 2016/12/19.
//  Copyright © 2016年 idcby. All rights reserved.
//

#define Is_up_Ios_9      ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)

#define kPersonCell @"personCell"

#import "IMFindViewController.h"
#import "FindPersonCell.h"
#import "FindPersonModel.h"
#import "ApplyViewController.h"
#import "InvitationManager.h"
#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import <AddressBook/ABPerson.h>
#import <AddressBookUI/ABPersonViewController.h>
#import <ContactsUI/ContactsUI.h>
#import "AddFriendCell.h"

@interface IMFindViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIAlertViewDelegate, ABPeoplePickerNavigationControllerDelegate, CNContactPickerDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *IMSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *SearchTableView;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, strong) NSString *memberid;
@property (nonatomic, strong) NSString *newmessage;

@end

@implementation IMFindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加好友";
    self.IMSearchBar.delegate = self;
    self.IMSearchBar.placeholder = @"请输入手机号搜索用户";
    [self.IMSearchBar becomeFirstResponder];
    
    // 找人cell
    [self.SearchTableView registerNib:[UINib nibWithNibName:@"FindPersonCell" bundle:nil] forCellReuseIdentifier:kPersonCell];

    self.dataSource = [NSMutableArray array];
    
    UIBarButtonItem *two = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"tongxun"] style:(UIBarButtonItemStylePlain) target:self action:@selector(openAbookAction:)];
    self.navigationItem.rightBarButtonItem = two;
    
    
}


#pragma mark - UISearchBar Delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    self.IMSearchBar.showsCancelButton = YES;
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    NSLog(@"键盘点击搜索");
    self.IMSearchBar.showsCancelButton = NO;
    [self.IMSearchBar resignFirstResponder];
    
    
    [self searchAction];
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    NSLog(@"取消搜索");
    self.IMSearchBar.showsCancelButton = NO;
    [self.IMSearchBar resignFirstResponder];
}


#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FindPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:kPersonCell forIndexPath:indexPath];
    [cell.personAddBtn addTarget:self action:@selector(addPerson:) forControlEvents:(UIControlEventTouchUpInside)];
    cell.personImageView.image = [UIImage imageNamed:@"chatListCellHead.png"];
    cell.telLab.text = [self.dataSource objectAtIndex:indexPath.row];
    cell.nameLab.text = @"";
    return cell;
    

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

#pragma mark - Button Action
- (void)addPerson:(UIButton *)sender {

    NSLog(@"_memberid - %@", _memberid);
    NSString *buddyName = _memberid;
    if ([self didBuddyExist:buddyName]) {
        
        [EMAlertView showAlertWithTitle:@"他（她）已经是你的好友了！"
                                message:nil
                        completionBlock:nil
                      cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                      otherButtonTitles:nil];
        
//        FindPersonCell *cell = (FindPersonCell *)sender.superview.superview;
//        [cell.personAddBtn setTitleColor:Main_Color forState:(UIControlStateNormal)];
//        [cell.personAddBtn setTitle:@"已添加" forState:(UIControlStateNormal)];
//        cell.personAddBtn.layer.borderWidth = 0;
        
    }
    else if([self hasSendBuddyRequest:buddyName])
    {
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"friend.repeatApply", @"you have send fridend request to '%@'!"), buddyName];
        [EMAlertView showAlertWithTitle:message
                                message:nil
                        completionBlock:nil
                      cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                      otherButtonTitles:nil];
        
        
    }else{
        [self showMessageAlertView];
        
        // 调后台接口, 极光推送消息
        NSLog(@"buddyName - %@", buddyName);
        [self JPushWithAddFriendWithCustomID:buddyName];
    }
    
    //    FindPersonCell *cell = (FindPersonCell *)sender.superview.superview;
    //    NSIndexPath *index = [self.SearchTableView indexPathForCell:cell];
//    FindPersonModel *model = self.dataSource[index.row]; // 这个model没用
    
//    [cell.personAddBtn setTitleColor:Main_Color forState:(UIControlStateNormal)];
//    [cell.personAddBtn setTitle:@"已添加" forState:(UIControlStateNormal)];
//    cell.personAddBtn.layer.borderWidth = 0;
    
    
    
}

- (void)JPushWithAddFriendWithCustomID:(NSString *)customId {
    
    
    NSString *urlS = [NSString stringWithFormat:@"%@/api/IM/JPushByCustomerID", Server_Int_Url];
    NSString *dataS = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCCustomerID=%@", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI, customId, nil];
    NSString *dataEncrpyt = [TWDes encryptWithContent:dataS type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    NSDictionary *paraDic = @{kToken:token, kDatas:dataEncrpyt};
    
    [AFManegerHelp POST:urlS parameters:paraDic success:^(id responseObjeck) {
        NSLog(@"JPushWithAddFriend - %@", responseObjeck);
        [self hideHud];
        if ([responseObjeck[@"Success"] integerValue] == 1) {
            
        }
        
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"cuowu%@", error);
    }];
}


#pragma mark - action

- (void)searchAction
{

    if(_IMSearchBar.text.length > 0)
    {
        NSString *loginUsername = [[EMClient sharedClient] currentUsername];
        if ([_IMSearchBar.text isEqualToString:loginUsername]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"friend.notAddSelf", @"can't add yourself as a friend") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
            [alertView show];
            
            return;
        }
        [self searchNameIsMemberWith:_IMSearchBar.text];
        
        
    }
}
/**
 *  判断这个人是否是我们的会员
 *
 */

- (void)searchNameIsMemberWith:(NSString *)phone {
    //    /api/IM/IsExistsByPhone
    NSString *urlS = [NSString stringWithFormat:@"%@/api/IM/IsExistsByPhone", Server_Int_Url];
    NSString *dataS = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCphone=%@", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI,phone, nil];
    NSString *dataEncrpyt = [TWDes encryptWithContent:dataS type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    NSDictionary *paraDic = @{kToken:token, kDatas:dataEncrpyt};
    
    [AFManegerHelp POST:urlS parameters:paraDic success:^(id responseObjeck) {
        
        NSLog(@"判断这个人是否是我们的会员 - %@", responseObjeck);
        
        if ([responseObjeck[@"Success"] integerValue] == 1) {
            
            NSDictionary *dic = responseObjeck[@"JsonData"];
            if ([dic[@"IsExists"] integerValue] == 1) {
                _memberid = dic[@"CustomerID"];
                NSLog(@"------%@", _memberid);
                [self sendMessageWithString:phone];
            } else {
                
                self.alertView = [[UIAlertView alloc] initWithTitle:@"你搜索的不是会员"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:nil, nil];
                _alertView.tag = 500;
                [NSTimer scheduledTimerWithTimeInterval:0.9 target:self selector:@selector(dismissAlert) userInfo:nil repeats:NO];
                [_alertView show];
            }
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
}

- (void)dismissAlert {
    
    [_alertView dismissWithClickedButtonIndex:0 animated:YES];
    
    UITextField *messageTextField = [_alertView textFieldAtIndex:0];
    
    NSString *username = [[EMClient sharedClient] currentUsername];
    
    if (messageTextField.text.length > 0) {
        [self getuserNameWith:username withMeaage:messageTextField.text];
    }
    else{
        [self getuserNameWith:username withMeaage:@"请求加你为好友"];
    }
    
    [self sendFriendApplyWithMessage:_newmessage];
    
}



/**
 *  是否发来申请
 *
 */
- (void)sendMessageWithString:(NSString *)string {
    //判断是否已发来申请
    NSArray *applyArray = [[ApplyViewController shareController] dataSource];
    if (applyArray && [applyArray count] > 0) {
        for (ApplyEntity *entity in applyArray) {
            ApplyStyle style = [entity.style intValue];
            BOOL isGroup = style == ApplyStyleFriend ? NO : YES;
            if (!isGroup && [entity.applicantUsername isEqualToString:_memberid]) {
                NSString *str = [NSString stringWithFormat:NSLocalizedString(@"friend.repeatInvite", @"%@ have sent the application to you"), string];
                NSLog(@"%@", str);
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:str
                                                                    message:nil
                                                                   delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                                          otherButtonTitles:nil, nil];
                [alertView show];
                return;
            }
        }
    }
    
    [self.dataSource removeAllObjects];
    [self.dataSource addObject:string];
    [self.SearchTableView reloadData];
}


- (BOOL)hasSendBuddyRequest:(NSString *)buddyName
{
    //    NSArray *userlist = [[EMClient sharedClient].contactManager getContactsFromDB];
    NSArray *userlist = [[EMClient sharedClient].contactManager getContacts];
    for (NSString *username in userlist) {
        if ([username isEqualToString:buddyName]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)didBuddyExist:(NSString *)buddyName
{
    //    NSArray *userlist = [[EMClient sharedClient].contactManager getContactsFromDB];
    NSArray *userlist = [[EMClient sharedClient].contactManager getContacts];
    for (NSString *username in userlist) {
        if ([username isEqualToString:buddyName]){
            return YES;
        }
    }
    return NO;
}

- (void)showMessageAlertView
{
//    self.alertView = [[UIAlertView alloc] initWithTitle:@"发送添加好友成功，等到好友确认！"
//                                                message:nil
//                                               delegate:self
//                                      cancelButtonTitle:nil
//                                      otherButtonTitles:nil, nil];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(dismissAlert) userInfo:nil repeats:NO];
    [_alertView show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 500) {
        NSLog(@"小时");
    } else {
        if ([alertView cancelButtonIndex] != buttonIndex) {
            UITextField *messageTextField = [alertView textFieldAtIndex:0];
        
            NSString *username = [[EMClient sharedClient] currentUsername];
            
            if (messageTextField.text.length > 0) {
                [self getuserNameWith:username withMeaage:messageTextField.text];
            }
            else{
                [self getuserNameWith:username withMeaage:@"请求加你为好友"];
            }
            [self sendFriendApplyWithMessage:_newmessage];
        }
    }
    
}


- (void)getuserNameWith:(NSString *)aUsername withMeaage:(NSString *)message {
    
    NSString *urlS = [NSString stringWithFormat:@"%@/api/IM/GetCustomerInfoByID", Server_Int_Url];
    NSString *dataS = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCID=%@", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI,aUsername, nil];
    NSString *dataEncrpyt = [TWDes encryptWithContent:dataS type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    NSDictionary *paraDic = @{kToken:token, kDatas:dataEncrpyt};
    
    [AFManegerHelp POST:urlS parameters:paraDic success:^(id responseObjeck) {
        
        NSLog(@"GetCustomerInfoByID - %@", responseObjeck);
        if ([responseObjeck[@"Success"] integerValue] == 1) {
            NSArray *array = responseObjeck[@"JsonData"];
            for (NSDictionary *d in array) {
                _newmessage = [NSString stringWithFormat:@"%@%@", d[@"CustomerName"], message];
            }
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"cuowu%@", error);
    }];
    
}


- (void)sendFriendApplyWithMessage:(NSString *)message
{

    NSString *buddyName = _memberid;
    if (buddyName && buddyName.length > 0) {
        [self showHudInView:self.view hint:NSLocalizedString(@"friend.sendApply", @"sending application...")];
        EMError *error = [[EMClient sharedClient].contactManager addContact:buddyName message:message];
        [self hideHud];
        if (error) {
            [self showHint:NSLocalizedString(@"friend.sendApplyFail", @"send application fails, please operate again")];
        }
        else{
            [self showHint:NSLocalizedString(@"friend.sendApplySuccess", @"send successfully")];
//            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.IMSearchBar.showsCancelButton = NO;
}

#pragma mark - 打开通讯录
- (void)openAbookAction:(UIButton *)sender {
    ///获取通讯录权限，调用系统通讯录
    [self CheckAddressBookAuthorization:^(bool isAuthorized , bool isUp_ios_9) {
        if (isAuthorized) {
            [self callAddressBook:isUp_ios_9];
        }else {
            NSLog(@"请到设置>隐私>通讯录打开本应用的权限设置");
        }
    }];
}

- (void)CheckAddressBookAuthorization:(void (^)(bool isAuthorized , bool isUp_ios_9))block {
    if (Is_up_Ios_9) {
        CNContactStore * contactStore = [[CNContactStore alloc]init];
        if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined) {
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * __nullable error) {
                if (error)
                {
                    NSLog(@"Error: %@", error);
                }
                else if (!granted)
                {
                    
                    block(NO,YES);
                }
                else
                {
                    block(YES,YES);
                }
            }];
        }
        else if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized){
            block(YES,YES);
        }
        else {
            NSLog(@"请到设置>隐私>通讯录打开本应用的权限设置");
        }
    }else {
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
        
        if (authStatus == kABAuthorizationStatusNotDetermined)
        {
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error)
                    {
                        NSLog(@"Error: %@", (__bridge NSError *)error);
                    }
                    else if (!granted)
                    {
                        
                        block(NO,NO);
                    }
                    else
                    {
                        block(YES,NO);
                    }
                });
            });
        }else if (authStatus == kABAuthorizationStatusAuthorized)
        {
            block(YES,NO);
        }else {
            NSLog(@"请到设置>隐私>通讯录打开本应用的权限设置");
        }
    }
}

- (void)callAddressBook:(BOOL)isUp_ios_9 {
    if (isUp_ios_9) {
        CNContactPickerViewController *contactPicker = [[CNContactPickerViewController alloc] init];
        contactPicker.delegate = self;
        contactPicker.displayedPropertyKeys = @[CNContactPhoneNumbersKey];
        [self presentViewController:contactPicker animated:YES completion:nil];
    }else {
        ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
        peoplePicker.peoplePickerDelegate = self;
        [self presentViewController:peoplePicker animated:YES completion:nil];
        
    }
}

#pragma mark -- CNContactPickerDelegate
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
    CNPhoneNumber *phoneNumber = (CNPhoneNumber *)contactProperty.value;
    
    [self dismissViewControllerAnimated:YES completion:^{
        /// 联系人
        NSString *text1 = [NSString stringWithFormat:@"%@%@",contactProperty.contact.familyName,contactProperty.contact.givenName];
        /// 电话
        NSString *text2 = phoneNumber.stringValue;
        //        text2 = [text2 stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSLog(@"联系人：%@, 电话：%@",text1,text2);
        NSString *newPhoneNum = [text2 stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSString *newPhoneNum2 = [newPhoneNum substringFromIndex:newPhoneNum.length-11];
        
        [self searchNameIsMemberWith:newPhoneNum2];
        
    }];
}

#pragma mark -- ABPeoplePickerNavigationControllerDelegate
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    ABMultiValueRef valuesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex index = ABMultiValueGetIndexForIdentifier(valuesRef,identifier);
    CFStringRef value = ABMultiValueCopyValueAtIndex(valuesRef,index);
    CFStringRef anFullName = ABRecordCopyCompositeName(person);
    
    [self dismissViewControllerAnimated:YES completion:^{
        /// 联系人
        NSString *text1 = [NSString stringWithFormat:@"%@",anFullName];
        /// 电话
        NSString *text2 = (__bridge NSString*)value;
        //        text2 = [text2 stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSLog(@"联系人：%@, 电话：%@",text1,text2);
        
        NSString *newPhoneNum = [text2 stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSString *newPhoneNum2 = [newPhoneNum substringFromIndex:newPhoneNum.length-11];
        
        [self searchNameIsMemberWith:newPhoneNum2];
        
        
    }];
}


//取消选择
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}


/**
 *  iOS 8.0之后
 */

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person
{
    ABPersonViewController *personViewController = [[ABPersonViewController alloc] init];
    personViewController.displayedPerson = person;
    [peoplePicker pushViewController:personViewController animated:YES];
}

/**
 *  iOS 7.0 下
 */
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    return YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    long index = ABMultiValueGetIndexForIdentifier(phone,identifier);
    NSString *phoneNO = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, index);
    if ([phoneNO hasPrefix:@"+"]) {
        phoneNO = [phoneNO substringFromIndex:3];
    }
    
    phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSLog(@"%@", phoneNO);
    [self searchNameIsMemberWith:phoneNO];
    return YES;
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
