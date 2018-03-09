//
//  HomeNewsListModel.h
//  JRMedical
//
//  Created by a on 16/11/21.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeNewsListModel : NSObject

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger ImageNum; // 图片数量
@property (nonatomic, assign) NSInteger IsDianZan;  // 是否已点赞
@property (nonatomic, assign) NSInteger IsHot; //是否是最热
@property (nonatomic, assign) NSInteger IsShouCang; // 是否已收藏
@property (nonatomic, assign) NSInteger IsVideo; // 是否是视频
@property (nonatomic, assign) CGFloat PingJiaJiLu; // 评价次数
@property (nonatomic, assign) CGFloat *LiuLanJiLu; // 浏览次数
@property (nonatomic, assign) CGFloat *ShouCangJiLu; // 收藏次数

@property (nonatomic, strong) NSString *TuPian1;//图片1
@property (nonatomic, strong) NSString *TuPian2;//图片2
@property (nonatomic, strong) NSString *TuPian3;//图片3

@property (nonatomic, strong) NSString *BiaoTi;//标题
@property (nonatomic, strong) NSString *DianZhanShuLiang;//点赞数量
@property (nonatomic, strong) NSString *FaBiaoShiJian;//发表时间
@property (nonatomic, strong) NSString *GroupCode;//类型 视频 等等....
@property (nonatomic, strong) NSString *KaiShiShiJian; // 开始时间
@property (nonatomic, strong) NSString *JieShuShiJian; // 结束时间
@property (nonatomic, strong) NSString *LaiYuan;//来源
@property (nonatomic, strong) NSString *LeiBie; //类别
@property (nonatomic, strong) NSString *LeiBieMingCheng;//类别名称
@property (nonatomic, strong) NSString *Time;// 时间多长时间以前
@property (nonatomic, strong) NSString *Url;//详情地址

@end
