//
//  Utils.m
//  JRMedical
//
//  Created by a on 16/11/4.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "Utils.h"

@implementation Utils

//计算文本大小
+ (CGSize)sizeForTitle:(NSString *)title withFont:(UIFont *)font {
    CGRect titleRect = [title boundingRectWithSize:CGSizeMake(FLT_MAX, FLT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName : font}
                                           context:nil];
    
    return CGSizeMake(titleRect.size.width,
                      titleRect.size.height);
}

//计算文本高度
+ (CGRect)getTextRectWithString:(NSString *)str withWidth:(NSInteger)width withFontSize:(CGFloat)size {
    CGRect rect = [str boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil];
    return rect;
}

//判断字符串是否为空
+ (BOOL)isBlankString:(NSString *)string {
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if (    [string isEqual:nil]
        ||  [string isEqual:Nil]){
        return YES;
    }
    if (![string isKindOfClass:[NSString class]]) {
        return YES;
    }
    if (0 == [string length]){
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    if([string isEqualToString:@"(null)"]){
        return YES;
    }
    return NO;
}

//格式化时间戳
+ (NSString *)formatTimeStamp:(NSString *)format withTime:(NSString *)timeStr {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStr integerValue]];
    formatter.dateFormat = format;
    NSString *time = [formatter stringFromDate:date];
    
    return time;
}

//拨打电话
+ (void)makeCallWithPhoneNum:(NSString *)num target:(UIViewController *)target {
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        UIWebView *callPhoneWebVw = [[UIWebView alloc] init];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",num]]];
        [callPhoneWebVw loadRequest:request];
        [target.view addSubview:callPhoneWebVw];
    } else {
        UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"对不起!" message:@"你的设备不支持打电话" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Notpermitted show];
    }
}

////字典转json
+ (NSString *)jsonFromDictionary:(NSDictionary *)dic {
    NSMutableString *jsonString = [NSMutableString string];
    [jsonString appendString:@"{"];
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        [jsonString appendFormat:@"\"%@\":",key];
        //NSString *valueStr = [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [jsonString appendFormat:@"\"%@\",",value];
    }];
    [jsonString replaceCharactersInRange:NSMakeRange(jsonString.length - 1, 1) withString:@""];
    [jsonString appendString:@"}"];
    return jsonString;
}

@end
