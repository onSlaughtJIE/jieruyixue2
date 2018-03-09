//
//  PublicNewsListModel.h
//  JRMedical
//
//  Created by a on 16/11/21.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublicNewsListModel : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, assign) BOOL IsShouCang;//是否收藏
@property (nonatomic, assign) BOOL IsDianZan;//是否点赞
@property (nonatomic, assign) BOOL IsHot; //是否是最热
@property (nonatomic, assign) BOOL NewTop; // 是否是置顶
@property (nonatomic, assign) BOOL IsVideo; // 是否是视频

@property (nonatomic, assign) CGFloat PingJiaJiLu; // 评价次数
@property (nonatomic, assign) CGFloat LiuLanJiLu; // 浏览次数
@property (nonatomic, assign) CGFloat ShouCangJiLu; // 收藏次数
@property (nonatomic, assign) CGFloat DianZhanShuLiang;//点赞数量

@property (nonatomic, copy) NSString *LaiYuan;//来源
@property (nonatomic, copy) NSString *Url;//详情页
@property (nonatomic, copy) NSString *ZhaiYao;//摘要
@property (nonatomic, copy) NSString *ZhaoKaiChengShi;//召开城市
@property (nonatomic, copy) NSString *GroupCode;//类型 视频 等等....
@property (nonatomic, copy) NSString *TuPian;//图片地址 
@property (nonatomic, copy) NSString *BiaoTi;//标题
@property (nonatomic, copy) NSString *LeiBie;//类别
@property (nonatomic, copy) NSString *LeiBieMingCheng;//类别名称
@property (nonatomic, copy) NSString *FaBiaoShiJian;//发表时间

@property (nonatomic, copy) NSString *Time;// 时间多长时间以前
@property (nonatomic, copy) NSString *TimeStamp;//开始的时间戳
@property (nonatomic, copy) NSString *KaiShiShiJian; // 开始时间
@property (nonatomic, copy) NSString *JieShuShiJian; // 结束时间

@property (nonatomic, assign) NSInteger ImageNum; // 图片数量
@property (nonatomic, copy) NSString *TuPian1;//图片1
@property (nonatomic, copy) NSString *TuPian2;//图片2
@property (nonatomic, copy) NSString *TuPian3;//图片3

@property (nonatomic, copy) NSString *VideoSpecialTitle;//视频专题标题（视频讲座）
@property (nonatomic, copy) NSString *VideoSpecialID;//视频专题ID（视频讲座）
@property (nonatomic, copy) NSString *VideoDep;//医生科室（视频讲座）
@property (nonatomic, copy) NSString *VideoDocDesc;//医生描述（视频讲座）
@property (nonatomic, copy) NSString *VideoDoctor;//主讲医生（视频讲座）
@property (nonatomic, copy) NSString *VideoHos;//医生医院（视频讲座）
@property (nonatomic, copy) NSString *VideoPost;//医生职称（视频讲座）
@property (nonatomic, copy) NSString *VideoDocPic;//主讲医生头像（视频讲座）
@property (nonatomic, copy) NSString *VideoUri;//视频链接（视频讲座）

@end
