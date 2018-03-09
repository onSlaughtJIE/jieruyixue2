//
//  Utils.h
//  JRMedical
//
//  Created by a on 16/11/4.
//  Copyright © 2016年 idcby. All rights reserved.
//

// 工具类

#import <Foundation/Foundation.h>

@interface Utils : NSObject

/* * 
 * 计算文本大小
 * title 文本内容
 * font 文字大小
 * return 文本大小
 */
+ (CGSize)sizeForTitle:(NSString *)title withFont:(UIFont *)font;

/* *
 * 获得文本高度
 * width 文本宽度
 * size 文字大小
 * return 文本大小
 */
+ (CGRect)getTextRectWithString:(NSString *)str withWidth:(NSInteger)width withFontSize:(CGFloat)size;

/* *
 * 判断字符串是否为空
 * string 文本内容
 */
+ (BOOL)isBlankString:(NSString *)string;

/* *
 * 格式化时间戳
 * format 时间格式
 * timeStr 时间戳字符串
 */
+ (NSString *)formatTimeStamp:(NSString *)format withTime:(NSString *)timeStr;

//拨打电话
+ (void)makeCallWithPhoneNum:(NSString *)num target:(UIViewController *)target;

//字典转json
+ (NSString *)jsonFromDictionary:(NSDictionary *)dic;

@end
