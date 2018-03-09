//
//  PatientDetailVC.h
//  JRMedical
//
//  Created by a on 16/12/8.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "BaseViewController.h"
#import "NewestPostModel.h"

@interface PatientDetailVC : BaseViewController

@property (nonatomic, strong) NewestPostModel *model;

@property (nonatomic, strong) NSArray *picUrlArray;//缩略图URL
@property (nonatomic, strong) NSArray *picOriArray;//原图url
@property (nonatomic, strong) NSArray *rTypeArray;//图片类型

@end
