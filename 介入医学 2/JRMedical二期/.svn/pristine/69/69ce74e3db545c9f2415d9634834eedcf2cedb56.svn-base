//
//  GroupJianJieChangeViewController.m
//  JRMedical
//
//  Created by ww on 2016/12/30.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "GroupJianJieChangeViewController.h"

@interface GroupJianJieChangeViewController ()<UITextViewDelegate>
{
    EMGroup         *_group;
    BOOL            _isOwner;
    UITextView     *_subjectTextView;
}

@end

@implementation GroupJianJieChangeViewController

- (instancetype)initWithGroup:(EMGroup *)group
{
    self = [self init];
    if (self) {
        _group = group;
        NSString *loginUsername = [[EMClient sharedClient] currentUsername];
        _isOwner = [_group.owner isEqualToString:loginUsername];
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_isOwner) {
       self.title = @"修改群简介";
    } else {
       self.title = @"群简介";
    }
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:(UIBarButtonItemStylePlain) target:self action:@selector(popViewControllerAnimated)];
    
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    if (_isOwner)
    {
        UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"save", @"Save") style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
        saveItem.tintColor = [UIColor whiteColor];
        [self.navigationItem setRightBarButtonItem:saveItem];
    }
    
    
    CGRect frame = CGRectMake(20, 20, Width_Screen - 40, 120);
    
    
    _subjectTextView = [[UITextView alloc] initWithFrame:frame];
    _subjectTextView.layer.cornerRadius = 5.0;
    _subjectTextView.layer.borderWidth = 1.0;
    _subjectTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _subjectTextView.textColor = [UIColor darkGrayColor];
    _subjectTextView.text = _group.description;
    if (!_isOwner)
    {
        _subjectTextView.userInteractionEnabled = NO;
    }

    _subjectTextView.delegate = self;
    [self.view addSubview:_subjectTextView];
}

- (void)popViewControllerAnimated {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - action
- (void)back
{
    if ([_subjectTextView isFirstResponder])
    {
        [_subjectTextView resignFirstResponder];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save:(id)sender
{
    [self saveSubject];
}

/*
 
 修改群描述
 不推荐使用 ，只有 Owner 有权限操作。
 
 EMError *error = nil;
 // 修改群描述
 EMGroup* group = [[EMClient sharedClient].groupManager changeDescription:@"修改的群描述" forGroup:@"1410329312753" error:&error];
 if (!error) {
 NSLog(@"修改成功");
 }
 
 */

- (void)saveSubject
{
    EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:_group.groupId type:EMConversationTypeGroupChat createIfNotExist:NO];
    EMError *error = nil;
    [[EMClient sharedClient].groupManager changeDescription:_subjectTextView.text forGroup:_group.groupId error:&error];
    if (!error) {
        if ([_group.groupId isEqualToString:conversation.conversationId]) {
            NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithDictionary:conversation.ext];
            [ext setObject:_group.description forKey:@"description"];
            [ext setObject:[NSNumber numberWithBool:_group.isPublic] forKey:@"isPublic"];
            conversation.ext = ext;
        }
    }
    [self back];
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
