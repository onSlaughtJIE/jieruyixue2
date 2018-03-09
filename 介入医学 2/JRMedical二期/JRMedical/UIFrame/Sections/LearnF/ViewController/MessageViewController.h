//
//  MessageViewController.h
//  JRMedical
//
//  Created by ww on 2016/12/13.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "EaseConversationListViewController.h"

@interface MessageViewController : EaseConversationListViewController

@property (strong, nonatomic) NSMutableArray *conversationsArray;

- (void)refresh;
- (void)refreshDataSource;

- (void)isConnect:(BOOL)isConnect;
- (void)networkChanged:(EMConnectionState)connectionState;

@end
