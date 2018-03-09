//
//  yuyueView.m
//  YiJiaXin
//
//  Created by ww on 16/10/21.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "yuyueView.h"

@interface yuyueView ()

@end




@implementation yuyueView


+(instancetype)yuyueView {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"yuyueView"
                                          owner:nil options:nil]lastObject];
}

- (IBAction)cancleView:(UIButton *)sender {
    
    if (self.cancle) {
        self.cancle();
    }
    
}

- (IBAction)makeSure:(UIButton *)sender {
    
    if (self.makesure) {
        self.makesure();
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
