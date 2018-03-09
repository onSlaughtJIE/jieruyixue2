//
//  EaseChatCell.h
//  UCloudMediaRecorderDemo
//
//  Created by EaseMob on 16/6/12.
//  Copyright © 2016年 zmw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NetFinish)();

@interface EaseChatCell : UITableViewCell

@property (nonatomic, copy) NetFinish netFinish;

- (void)setMesssage:(EMMessage*)message;

+ (CGFloat)heightForMessage:(EMMessage *)message;

@end
