//
//  MyPostTieZiCell.h
//  JRMedical
//
//  Created by ww on 2017/2/18.
//  Copyright © 2017年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewestPostModel.h"
#import "YHWorkGroupPhotoContainer.h"

@interface MyPostTieZiCell : UITableViewCell

@property (nonatomic, strong) NewestPostModel *model;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) UIImageView *headerPhoto;
@property (nonatomic, strong) UIImageView *isRenZhengImg;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *laiYuanLab;
@property (nonatomic, strong) UILabel *xingHaoLab;
@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) NSArray *picUrlArray;//缩略图URL
@property (nonatomic, strong) NSArray *picOriArray;//原图url
@property (nonatomic, strong) NSArray *rTypeArray;//图片类型

@property (nonatomic,strong) YHWorkGroupPhotoContainer *picContainerView;

@property (nonatomic,strong) UIButton *deleteBtn; // 删除按钮

@end
