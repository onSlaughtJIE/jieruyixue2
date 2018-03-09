//
//  ReplyPostModel.h
//  JRMedical
//
//  Created by a on 16/12/10.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReplyPostModel : NSObject

@property (nonatomic, assign) BOOL IsRole;//是否认证

@property (nonatomic, copy) NSString *CTime;//创建时间
@property (nonatomic, copy) NSString *CUserName;//创建人姓名
@property (nonatomic, copy) NSString *Content;//内容
@property (nonatomic, copy) NSString *CreUserPic;//创建人头像
@property (nonatomic, copy) NSString *EvaluateDevice;//设备

@property (nonatomic, copy) NSString *ReplyID;//帖子ID

@property (nonatomic, copy) NSArray *List;//图片视频集合
//RType 0 图片，1视频
//ThumImg  缩略图
//Uri  当RType   为0时是图片高清图    为1时是视频地址
//VideoPic 视频图片

@end
