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

#import "ContactView.h"

@implementation ContactView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        
        UIButton *bt = [UIButton buttonWithType:(UIButtonTypeSystem)];
        
        bt.frame = self.newimagev.frame;
        bt.backgroundColor = [UIColor clearColor];
        [bt addTarget:self action:@selector(tapAction) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:bt];
        
        
        _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageView.frame) - 20, 3, 30, 30)];
        [_deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        [_deleteButton setImage:[UIImage imageNamed:@"group_invitee_delete"] forState:UIControlStateNormal];
        _deleteButton.hidden = YES;
        [self addSubview:_deleteButton];
    }
    
    return self;
}

- (void)tapAction {
    NSLog(@"%ld", (long)_index);
    NSLog(@"点击事件");
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[NSString stringWithFormat:@"%ld", (long)_index] forKey:@"key"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"groupdianji" object:nil userInfo:dic];
}

- (void)setEditing:(BOOL)editing
{
    if (_editing != editing) {
        _editing = editing;
        _deleteButton.hidden = !_editing;
    }
}

- (void)deleteAction
{
    if (_deleteContact) {
        _deleteContact(self.index);
    }
}

@end
