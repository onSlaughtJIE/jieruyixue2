//
//  Foundation+Log.m
//  加强输出日志
//
//  Created by 张正 on 15/8/27.
//  Copyright (c) 2015年 张正. All rights reserved.
//

#import <Foundation/Foundation.h>



@implementation NSDictionary (Log)



//+ (void)load
//{
//    NSLog(@"11");
//}


- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *str = [NSMutableString string];
    [str appendString:@"{\n"];
    
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [str appendFormat:@"\t%@ = %@, \n", key, obj];
    }];
    
    [str appendString:@"}"];
    
    // 删除最后一个,
    //NSRange range = [str rangeOfString:@"," options:NSBackwardsSearch];
    //[str deleteCharactersInRange:range];
     
    
    return str;
}

@end

@implementation NSArray (Log)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *str = [NSMutableString string];
    [str appendString:@"[\n"];
    
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [str appendFormat:@"\t\t%@,\n", obj];
    }];
    
    [str appendString:@"]"];
    
    // 删除最后一个,
//    NSRange range = [str rangeOfString:@"," options:NSBackwardsSearch];
//    [str deleteCharactersInRange:range];
    
    
    return str;
}



@end

