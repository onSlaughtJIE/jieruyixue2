//
//  yuyueView.h
//  YiJiaXin
//
//  Created by ww on 16/10/21.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Cancle)();
typedef void(^Makesure)();


@interface yuyueView : UIView

@property (nonatomic, copy) Cancle cancle;
@property (nonatomic, copy) Makesure makesure;
@property (weak, nonatomic) IBOutlet UIView *countView;
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *oldLab;

- (IBAction)cancleView:(UIButton *)sender;
- (IBAction)makeSure:(UIButton *)sender;

+(instancetype)yuyueView;


@end
