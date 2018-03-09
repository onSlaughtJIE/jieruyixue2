//
//  NewsDetailView.h
//  JRMedical
//
//  Created by a on 16/12/8.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewestPostModel.h"

@interface NewsDetailView : UIView<UIWebViewDelegate>

@property (nonatomic, strong) NewestPostModel *model;

@property (nonatomic, strong) UIImageView *headerPhoto;
@property (nonatomic, strong) UIImageView *isRenZhengImg;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *laiYuanLab;
@property (nonatomic, strong) UILabel *xingHaoLab;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *contantLab;
@property (nonatomic, strong) UIView *botLineView;

@property (nonatomic, strong) NSMutableArray *tUrlArray;
@property (nonatomic, strong) NSMutableArray *hUrlArray;
@property (nonatomic, strong) NSMutableArray *videoUrlArray;

@end
