//
//  AuthorInfoView.h
//  JRMedical
//
//  Created by a on 16/11/17.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicNewsListModel.h"

@interface AuthorInfoView : UIView

@property (strong, nonatomic) PublicNewsListModel *model;

@property (strong, nonatomic) UIImageView *authorPhoto;
@property (strong, nonatomic) UILabel *nameLab;
@property (strong, nonatomic) UILabel *hospitalNameLab;
@property (strong, nonatomic) UILabel *levelLab;
@property (strong, nonatomic) UILabel *categoryLab;
@property (strong, nonatomic) UIButton *followBtn;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UIView *lineView2;

@end
