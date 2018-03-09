//
//  EasePublishModel.h
//  UCloudMediaRecorderDemo
//
//  Created by EaseMob on 16/6/4.
//  Copyright © 2016年 zmw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EasePublishModel : NSObject

@property (nonatomic, assign) NSInteger ID; // 直播ID
@property (nonatomic, copy) NSString *Address; // 地址
@property (nonatomic, copy) NSString *CustomerName; // 直播人
@property (nonatomic, copy) NSString *CustomerPic; // 直播人头像
@property (nonatomic, copy) NSString *HomeNO; // 房间号
@property (nonatomic, copy) NSString *LableName; // 类别
//@property (nonatomic, assign) NSInteger LookCount; // 观看人数
@property (nonatomic, assign) NSInteger PlayCount; // 播放次数
@property (nonatomic, assign) CGFloat Pice; // 价格
@property (nonatomic, copy) NSString *Image; // 视频图片
@property (nonatomic, copy) NSString *Title; // 标题
@property (nonatomic, copy) NSString *VideoUri; // 视频地址
@property (nonatomic, copy) NSString *MemoUri; //详情（H5页面
@property (nonatomic, copy) NSString *ChatRoomsID; //聊天室ID
@property (nonatomic, copy) NSString *ChatRoomsName; //聊天室名称
@property (nonatomic, copy) NSString *OnlineNumber;// 在线人数

@end
