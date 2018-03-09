//
//  WLZ_ChangeCountView.m
//  WLZ_ShoppingCart
//
//  Created by lijiarui on 15/12/14.
//  Copyright © 2015年 lijiarui. All rights reserved.
//

#import "WLZ_ChangeCountView.h"
#import "UIColor+WLZ_HexRGB.h"
@implementation WLZ_ChangeCountView

- (instancetype)initWithFrame:(CGRect)frame chooseCount:(NSInteger)chooseCount totalCount:(NSInteger)totalCount
{
    self = [super initWithFrame:frame];
    if (self) {
        self.choosedCount = chooseCount;
        self.totalCount = totalCount;
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews
{
    _subButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _subButton.frame = CGRectMake(0, 0, [UIImage imageNamed:@"jiankuagn"].size.width, [UIImage imageNamed:@"jiankuagn"].size.height);
    
    [_subButton setBackgroundImage:[UIImage imageNamed:@"jiankuagn"] forState:UIControlStateNormal];
    [_subButton setBackgroundImage:[UIImage imageNamed:@"jiankuagn"] forState:UIControlStateDisabled];
    
    _subButton.exclusiveTouch = YES;
    [self addSubview:_subButton];
    if (self.choosedCount <= 1) {
        _subButton.enabled = NO;
    }else{
        _subButton.enabled = YES;
    }
    
    _numberFD = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_subButton.frame), 0, 50, _subButton.frame.size.height)];
    
    _subButton.backgroundColor=[UIColor clearColor];
    _numberFD.textAlignment=NSTextAlignmentCenter;
    _numberFD.keyboardType=UIKeyboardTypeNumberPad;
    _numberFD.clipsToBounds = YES;
    _numberFD.layer.borderColor = RGB(180, 180, 180).CGColor;
    _numberFD.layer.borderWidth = 0.5;
    _numberFD.textColor = [UIColor colorFromHexRGB:@"333333"];
    
    _numberFD.font=[UIFont systemFontOfSize:13];
    _numberFD.backgroundColor = [UIColor whiteColor];
    _numberFD.text=[NSString stringWithFormat:@"%zi",self.choosedCount];
    
//    _numberFD.userInteractionEnabled = NO; // 数量不允许手动修改,只能通过加减号
    
    
    [self addSubview:_numberFD];
    
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addButton.frame = CGRectMake(CGRectGetMaxX(_numberFD.frame), 0, [UIImage imageNamed:@"jiankuagn"].size.width, [UIImage imageNamed:@"jiankuagn"].size.height);
    _addButton.backgroundColor=[UIColor clearColor];
    
    [_addButton setBackgroundImage:[UIImage imageNamed:@"jia-copy"] forState:UIControlStateNormal];
    [_addButton setBackgroundImage:[UIImage imageNamed:@"jia-copy"] forState:UIControlStateDisabled];
    
    _addButton.exclusiveTouch = YES;
    [self addSubview:_addButton];
    if (self.choosedCount >= self.totalCount) {
        _addButton.enabled = NO;
    }else{
        _addButton.enabled = YES;
    }
}

@end
