//
//  UITableView+EmpayData.m
//  KMEEN.ZF
//
//  Created by Rookie on 16/5/12.
//  Copyright © 2016年 郑州仟米科技. All rights reserved.
//

#import "UITableView+EmpayData.h"

@implementation UITableView (EmpayData)

- (void)tableViewDisplayWitMsg:(NSString *)message withImage:(NSString *)imageName ifNecessaryForRowCount:(NSUInteger) rowCount{
    if (rowCount == 0) {
        // Display a message when the table is empty
        // 没有数据的时候，UILabel的显示样式
        
        UIView *bgView = [UIView new];
        
        UIView *bgView2 = [UIView new];
        [bgView addSubview:bgView2];
        
        bgView2.sd_layout
        .centerXEqualToView(bgView)
        .centerYEqualToView(bgView)
        .widthIs(204)
        .heightIs(218);
        
        UIImageView *BGImageView = [UIImageView new];
        UIImage *BGImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]];
        BGImageView.image = BGImage;
        [bgView2 addSubview:BGImageView];
        
        BGImageView.sd_layout
        .centerXEqualToView(bgView2)
        .widthIs(150)
        .heightIs(163);
        
        UILabel *messageLabel = [UILabel new];
        messageLabel.text = message;
//        messageLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        messageLabel.font = [UIFont systemFontOfSize:17];
        messageLabel.textColor = [UIColor lightGrayColor];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.numberOfLines = 0;
//        [messageLabel sizeToFit];
        [bgView2 addSubview:messageLabel];
        
        messageLabel.sd_layout
        .topSpaceToView(BGImageView,0)
        .centerXEqualToView(bgView2)
        .widthIs(message.length*17)
        .heightIs(55);
        

        self.backgroundView = bgView;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        self.backgroundView = nil;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
}

- (void)tableViewDisplayWitMsg:(NSString *)message  ifNecessaryForRowCount:(NSUInteger)rowCount  {
    if (rowCount == 0) {
        // Display a message when the table is empty
        // 没有数据的时候，UILabel的显示样式
        UILabel *messageLabel = [UILabel new];
        
        messageLabel.text = message;
        messageLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        messageLabel.textColor = [UIColor lightGrayColor];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.numberOfLines = 0;
        [messageLabel sizeToFit];
        
        self.backgroundView = messageLabel;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        self.backgroundView = nil;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
}

- (void)tableViewDisplayWitMsg:(NSString *)message  ifNecessaryForRowCount:(NSUInteger)rowCount widthDuiQi:(NSInteger)tag {
    if (rowCount == 0) {
        // Display a message when the table is empty
        // 没有数据的时候，UILabel的显示样式
        UILabel *messageLabel = [UILabel new];
        
        messageLabel.text = message;
        messageLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        messageLabel.textColor = [UIColor lightGrayColor];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.numberOfLines = 0;
        [messageLabel sizeToFit];
        
        if (tag == 1000) {
            messageLabel.font = [UIFont systemFontOfSize:14];
        }
        else {
            messageLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        }
        
        self.backgroundView = messageLabel;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        self.backgroundView = nil;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
}

@end
