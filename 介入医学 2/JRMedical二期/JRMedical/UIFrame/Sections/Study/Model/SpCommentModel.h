//
//  SpCommentModel.h
//  JRMedical
//
//  Created by a on 16/8/12.
//  Copyright © 2016年 ZC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpCommentModel : NSObject

@property (nonatomic, assign) BOOL IsRole;//是否认证

@property (nonatomic, copy) NSString *Time;//时间
@property (nonatomic, copy) NSString *EvaluateDevice;//机型
@property (nonatomic, copy) NSString *ResourcesContent;//内容
@property (nonatomic, copy) NSString *CustomerID;//会员id
@property (nonatomic, copy) NSString *CustomerName;//会员姓名
@property (nonatomic, copy) NSString *CustomerPic;//会员头像
@property (nonatomic, copy) NSString *ZiXunID;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *ResourcesID;//被资讯标题或者论坛标题的id
@property (nonatomic, copy) NSString *ResourcesTitle;//被资讯标题或者论坛标题的id

@end
