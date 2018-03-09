//
//  TimeLimitGoodView.m
//  JRMedical
//
//  Created by ww on 16/11/15.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "TimeLimitGoodView.h"

@implementation TimeLimitGoodView

+ (instancetype)shareTimeLimitGoodView {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"TimeLimitGoodView" owner:nil options:nil] firstObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
