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

#define KNOTIFICATIONNAME_DELETEALLMESSAGE @"RemoveAllMessages"

@interface ChatViewController : EaseMessageViewController

//@property (nonatomic, assign) BOOL isTextl;
//@property (nonatomic, assign) BOOL isAudio;

@property (nonatomic, strong) NSString *userid;
//@property (nonatomic, strong) NSString *moneyStr;
- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   canLongPressRowAtIndexPath:(NSIndexPath *)indexPath;

@end
