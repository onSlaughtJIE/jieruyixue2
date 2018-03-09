//
//  PdfWebViewController.h
//  JRMedical
//
//  Created by ww on 2016/11/29.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "BaseViewController.h"
#import "PublicNewsListModel.h"

typedef void(^PassZiXunStatus)(NSInteger , NSInteger, NSInteger);

@interface PdfWebViewController : BaseViewController

@property (nonatomic, strong) PublicNewsListModel *model;

@property (nonatomic, copy) PassZiXunStatus passZiXunStatus;

@end
