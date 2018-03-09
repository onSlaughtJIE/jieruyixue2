
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

#define Is_up_Ios_9      ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)

#import "AddFriendViewController.h"

#import "ApplyViewController.h"
#import "AddFriendCell.h"
#import "InvitationManager.h"
#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import <AddressBook/ABPerson.h>
#import <AddressBookUI/ABPersonViewController.h>
#import <ContactsUI/ContactsUI.h>

@interface AddFriendViewController ()<UITextFieldDelegate, UIAlertViewDelegate, ABPeoplePickerNavigationControllerDelegate, CNContactPickerDelegate>

@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, strong) NSString *memberid;

@property (nonatomic, strong) NSString *newmessage;

@end

@implementation AddFriendViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _dataSource = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    self.title = NSLocalizedString(@"friend.add", @"Add friend");
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = self.headerView;
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0];
    self.tableView.tableFooterView = footerView;
    
//    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
////    [searchButton setTitle:NSLocalizedString(@"search", @"Search") forState:UIControlStateNormal];
    
    UIButton *searchButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    searchButton.frame = CGRectMake(Width_Screen - 70, 10, 60, 44);
//    searchButton.backgroundColor = [UIColor lightGrayColor];
    [searchButton setImage:[UIImage imageNamed:@"sousuo"] forState:(UIControlStateNormal)];
    [searchButton addTarget:self action:@selector(searchAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:searchButton];


    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:(UIBarButtonItemStylePlain) target:self action:@selector(popViewControllerAnimated)];
    
    
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    [self.view addSubview:self.textField];
    
   
    UIBarButtonItem *two = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"tongxun"] style:(UIBarButtonItemStylePlain) target:self action:@selector(openAbookAction:)];
    
    
    self.navigationItem.rightBarButtonItem = two;
    
}


- (void)popViewControllerAnimated {
    [self.navigationController popViewControllerAnimated:YES];
}

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
//- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
//    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
//    long index = ABMultiValueGetIndexForIdentifier(phone,identifier);
//    NSString *phoneNO = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, index);
//    
//    if ([phoneNO hasPrefix:@"+"]) {
//        phoneNO = [phoneNO substringFromIndex:3];
//    }
//    
//    phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    NSLog(@"%@", phoneNO);
//    [self searchNameIsMemberWith:phoneNO];
//}

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







- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter

- (UITextField *)textField
{
    if (_textField == nil) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, Width_Screen - 80, 40)];
        _textField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _textField.layer.borderWidth = 0.5;
        _textField.layer.cornerRadius = 3;
        _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30)];
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.font = [UIFont systemFontOfSize:15.0];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.placeholder = NSLocalizedString(@"friend.inputNameToSearch", @"input to find friends");
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.delegate = self;
        _textField.keyboardType = UIKeyboardTypePhonePad;
    }
    
    return _textField;
}

- (UIView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 60)];
        _headerView.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0];
        
        [_headerView addSubview:_textField];
    }
    
    return _headerView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AddFriendCell";
    AddFriendCell *cell = (AddFriendCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[AddFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.imageView.image = [UIImage imageNamed:@"chatListCellHead.png"];
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedIndexPath = indexPath;
//    NSString *buddyName = [self.dataSource objectAtIndex:indexPath.row];
    NSLog(@"%@", _memberid);
    NSString *buddyName = _memberid;
    if ([self didBuddyExist:buddyName]) {
//        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"friend.repeat", @"'%@'has been your friend!"), buddyName];
        
        [EMAlertView showAlertWithTitle:@"他（她）已经是你的好友了！"
                                message:nil
                        completionBlock:nil
                      cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                      otherButtonTitles:nil];
        
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
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - action

- (void)searchAction
{
    [_textField resignFirstResponder];
    if(_textField.text.length > 0)
    {
        NSString *loginUsername = [[EMClient sharedClient] currentUsername];
        if ([_textField.text isEqualToString:loginUsername]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"friend.notAddSelf", @"can't add yourself as a friend") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
            [alertView show];
            
            return;
        }
        [self searchNameIsMemberWith:self.textField.text];
        
        
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
    
    //            NSString *messageStr = @"";
    NSString *username = [[EMClient sharedClient] currentUsername];
    
    
    if (messageTextField.text.length > 0) {
        [self getuserNameWith:username withMeaage:messageTextField.text];
        //                messageStr = [NSString stringWithFormat:@"%@：%@", username, messageTextField.text];
    }
    else{
        [self getuserNameWith:username withMeaage:@"请求加你为好友"];
        //                messageStr = [NSString stringWithFormat:NSLocalizedString(@"friend.somebodyInvite", @"%@ invite you as a friend"), username];
        
    }
    [self sendFriendApplyAtIndexPath:self.selectedIndexPath
                             message:_newmessage];
    
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
    [self.tableView reloadData];
}


- (BOOL)hasSendBuddyRequest:(NSString *)buddyName
{

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
    self.alertView = [[UIAlertView alloc] initWithTitle:@"发送添加好友成功，等到好友确认！"
                                                message:nil
                                               delegate:self
                                      cancelButtonTitle:nil
                                      otherButtonTitles:nil, nil];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(dismissAlert) userInfo:nil repeats:NO];
    [_alertView show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 500) {
        NSLog(@"小时");
    } else {
        if ([alertView cancelButtonIndex] != buttonIndex) {
            UITextField *messageTextField = [alertView textFieldAtIndex:0];
            
//            NSString *messageStr = @"";
            NSString *username = [[EMClient sharedClient] currentUsername];
            
            
            if (messageTextField.text.length > 0) {
                [self getuserNameWith:username withMeaage:messageTextField.text];
//                messageStr = [NSString stringWithFormat:@"%@：%@", username, messageTextField.text];
            }
            else{
                [self getuserNameWith:username withMeaage:@"请求加你为好友"];
//                messageStr = [NSString stringWithFormat:NSLocalizedString(@"friend.somebodyInvite", @"%@ invite you as a friend"), username];
                
            }
            [self sendFriendApplyAtIndexPath:self.selectedIndexPath
                                     message:_newmessage];
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


- (void)sendFriendApplyAtIndexPath:(NSIndexPath *)indexPath
                           message:(NSString *)message
{
//    NSString *buddyName = [self.dataSource objectAtIndex:indexPath.row];
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
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end
