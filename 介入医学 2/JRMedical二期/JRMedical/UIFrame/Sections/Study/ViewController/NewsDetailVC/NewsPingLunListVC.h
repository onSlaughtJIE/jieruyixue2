//
//  NewsPingLunListVC.h
//  JRMedical
//
//  Created by a on 16/12/6.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "BaseViewController.h"
#import "PublicNewsListModel.h"

@interface NewsPingLunListVC : BaseViewController

@property (nonatomic, strong) PublicNewsListModel *model;

@property (nonatomic, assign) NSInteger IsDZ;
@property (nonatomic, assign) NSInteger IsShouCang;

@property (nonatomic, assign) BOOL isFromCaseCatalogue; // 来自病例分类的, 评论"4"

@end
