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

#import "GroupSubjectChangingViewController.h"

@interface GroupSubjectChangingViewController () <UITextFieldDelegate>
{
    EMGroup         *_group;
    BOOL            _isOwner;
    UITextField     *_subjectField;
}

@end

@implementation GroupSubjectChangingViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (_isOwner) {
        self.title = @"修改群名称";
    } else {
        self.title = @"群名称";
    }
//    self.title = NSLocalizedString(@"title.groupSubjectChanging", @"Change group name");


    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:(UIBarButtonItemStylePlain) target:self action:@selector(popViewControllerAnimated)];
    
    [self.navigationItem setLeftBarButtonItem:backItem];

    if (_isOwner)
    {
        UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"save", @"Save") style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
        saveItem.tintColor = [UIColor whiteColor];
        [self.navigationItem setRightBarButtonItem:saveItem];
    }

    
    CGRect frame = CGRectMake(20, 20, Width_Screen - 40, 40);
    
    _subjectField = [[UITextField alloc] initWithFrame:frame];
    _subjectField.layer.cornerRadius = 5.0;
    _subjectField.layer.borderWidth = 1.0;
    _subjectField.placeholder = NSLocalizedString(@"group.setting.subject", @"Please input group name");
    _subjectField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _subjectField.textColor = [UIColor darkGrayColor];
    _subjectField.font = [UIFont systemFontOfSize:13];
    _subjectField.text = _group.subject;
    if (!_isOwner)
    {
        _subjectField.enabled = NO;
    }
    frame.origin = CGPointMake(frame.size.width - 5.0, 0.0);
    frame.size = CGSizeMake(5.0, 40.0);
    UIView *holder = [[UIView alloc] initWithFrame:frame];
    _subjectField.rightView = holder;
    _subjectField.rightViewMode = UITextFieldViewModeAlways;
    frame.origin = CGPointMake(0.0, 0.0);
    holder = [[UIView alloc] initWithFrame:frame];
    _subjectField.leftView = holder;
    _subjectField.leftViewMode = UITextFieldViewModeAlways;
    _subjectField.delegate = self;
    [self.view addSubview:_subjectField];
}

- (void)popViewControllerAnimated {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - action
- (void)back
{
    if ([_subjectField isFirstResponder])
    {
        [_subjectField resignFirstResponder];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save:(id)sender
{
    [self saveSubject];
}

- (void)saveSubject
{
    EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:_group.groupId type:EMConversationTypeGroupChat createIfNotExist:NO];
    EMError *error = nil;
    [[EMClient sharedClient].groupManager changeGroupSubject:_subjectField.text forGroup:_group.groupId error:&error];
    if (!error) {
        if ([_group.groupId isEqualToString:conversation.conversationId]) {
            NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithDictionary:conversation.ext];
            [ext setObject:_group.subject forKey:@"subject"];
            [ext setObject:[NSNumber numberWithBool:_group.isPublic] forKey:@"isPublic"];
            conversation.ext = ext;
        }
    }
    [self back];
}

@end
