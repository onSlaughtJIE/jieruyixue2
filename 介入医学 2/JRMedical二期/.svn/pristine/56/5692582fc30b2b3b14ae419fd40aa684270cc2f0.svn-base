//
//  LearnFVC.h
//  JRMedical
//
//  Created by a on 16/11/4.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "BaseViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "EMSDK.h"

@interface LearnFVC : BaseViewController

{
    EMConnectionState _connectionState;
}


- (void)jumpToChatList;

- (void)setupUntreatedApplyCount;

- (void)setupUnreadMessageCount;

- (void)networkChanged:(EMConnectionState)connectionState;

- (void)didReceiveLocalNotification:(UILocalNotification *)notification;

- (void)didReceiveUserNotification:(UNNotification *)notification;

- (void)playSoundAndVibration;

- (void)showNotificationWithMessage:(EMMessage *)message;


@end
