//
//  NewestPostModel.h
//  JRMedical
//
//  Created by a on 16/12/8.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewestPostModel : NSObject

@property (nonatomic, assign) BOOL IsHot;//热门（1 热门 )
@property (nonatomic, assign) BOOL IsTop;//置顶（1 置顶 )
@property (nonatomic, assign) BOOL IsLike;//是否点赞
@property (nonatomic, assign) BOOL IsCollection;//是否收藏
@property (nonatomic, assign) BOOL IsRole;//是否认证

@property (nonatomic, assign) NSInteger BrowseCount;//浏览数量
@property (nonatomic, assign) NSInteger CollectionCount;//收藏数量
@property (nonatomic, assign) NSInteger ShareCount;//分享数量
@property (nonatomic, assign) NSInteger ReplyCount;//回复数量
@property (nonatomic, assign) NSInteger LikedCount;//点赞数量

@property (nonatomic, copy) NSString *Title;//标题
@property (nonatomic, copy) NSString *CTime;//创建时间
@property (nonatomic, copy) NSString *CUserName;//创建人姓名
@property (nonatomic, copy) NSString *PostID;//帖子ID
@property (nonatomic, copy) NSString *Uri;//分享的链接地址
@property (nonatomic, copy) NSString *CreUserPic;//创建人头像
@property (nonatomic, copy) NSString *Content;//内容
@property (nonatomic, copy) NSString *CustomerID;//发帖人ID
@property (nonatomic, copy) NSString *EvaluateDevice;//设备

@property (nonatomic, copy) NSArray *List;//图片视频集合
//RType 0 图片，1视频
//ThumImg  缩略图
//Uri  当RType   为0时是图片高清图    为1时是视频地址
//VideoPic 视频图片

@end
