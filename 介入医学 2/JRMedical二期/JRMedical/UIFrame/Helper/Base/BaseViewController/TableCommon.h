//
//  TableCommon.h
//  liuzhiyuan
//
//  Created by Rookie on 16/5/12.
//  Copyright © 2016年 刘志远. All rights reserved.
//

#ifndef TableCommon_h
#define TableCommon_h

#define COMMON_PAGE_SIZE  10

typedef NS_ENUM(NSInteger, RefreshType) {
    RefreshTypeNone = 0,//默认从0开始  没有上拉加载下拉刷新
    RefreshTypeHeader = 1,//只有下拉刷新
    RefreshTypeFooter = 2,//只有上拉加载
    RefreshTypeBoth = 3,//上拉加载下拉刷新都有
};

#endif /* TableCommon_h */
