//
//  JPushTzDetailVC.h
//  JRMedical
//
//  Created by ww on 2017/2/21.
//  Copyright © 2017年 idcby. All rights reserved.
//

#import "BaseViewController.h"
#import "NewestPostModel.h"

@interface JPushTzDetailVC : BaseViewController

@property (nonatomic, copy) NSString *jPushPostID; // 推送传来的被评论帖子id

@property (nonatomic, strong) NewestPostModel *model;
@property (nonatomic, strong) NSMutableArray *picUrlArray;//缩略图URL
@property (nonatomic, strong) NSMutableArray *picOriArray;//原图url
@property (nonatomic, strong) NSMutableArray *rTypeArray;//图片类型

@end
