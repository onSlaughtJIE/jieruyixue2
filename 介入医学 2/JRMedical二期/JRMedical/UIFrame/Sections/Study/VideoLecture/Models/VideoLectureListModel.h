//
//  VideoLectureListModel.h
//  JRMedical
//
//  Created by a on 16/11/23.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoLectureListModel : NSObject

@property (nonatomic, assign) BOOL *IsShouCang;//是否收藏
@property (nonatomic, assign) BOOL *IsDianZan;//是否点赞

@property (nonatomic, assign) CGFloat ShouCangJiLu;//收藏数量
@property (nonatomic, assign) CGFloat PingJiaJiLu;//评价数量
@property (nonatomic, assign) CGFloat LiuLanJiLu;//浏览数量
@property (nonatomic, assign) CGFloat DianZhanShuLiang;//点赞数量

@property (nonatomic, strong) NSString *TuPian;//视频图片
@property (nonatomic, strong) NSString *ZhaiYao;//摘要
@property (nonatomic, strong) NSString *LaiYuan;//来源
@property (nonatomic, strong) NSString *VideoSpecialTitle;//视频专题标题
@property (nonatomic, strong) NSString *GroupCode;
@property (nonatomic, strong) NSString *LeiBie;//类别
@property (nonatomic, strong) NSString *LeiBieMingCheng;//类别名称
@property (nonatomic, strong) NSString *ID;//视频ID
@property (nonatomic, strong) NSString *BiaoTi;//标题
@property (nonatomic, strong) NSString *FaBiaoShiJian;//发表时间
@property (nonatomic, strong) NSString *VideoSpecialID;//视频专题ID
@property (nonatomic, strong) NSString *VideoDep;//医生科室（视频讲座）
@property (nonatomic, strong) NSString *VideoDocDesc;//医生描述（视频讲座）
@property (nonatomic, strong) NSString *VideoDoctor;//主讲医生（视频讲座）
@property (nonatomic, strong) NSString *VideoHos;//医生医院（视频讲座）
@property (nonatomic, strong) NSString *VideoPost;//医生职称（视频讲座）
@property (nonatomic, strong) NSString *VideoDocPic;//主讲医生头像（视频讲座）
@property (nonatomic, strong) NSString *VideoUri;//视频链接（视频讲座）

@end
