//
//  UINavigationBar+Lzy7575.h
//  liuzhiyuan
//
//  Created by a on 16/11/3.
//  Copyright © 2016年 刘志远. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (Lzy7575)

//translucent  导航栏模糊效果

/**
 * 获取底边分隔线
 */
@property(nonatomic) UIImageView * hairline_7575;

/**
 * 背景色
 */
@property(nonatomic) UIColor * backGroundColor_7575;

/**
 * 背景透明度
 */
@property(nonatomic) CGFloat elementsAlpha_7575;

/**
 * 偏移量
 */
@property(nonatomic) CGFloat translationY_7575;

/**
 * 重置
 */
- (void)reset_7575;

@end
