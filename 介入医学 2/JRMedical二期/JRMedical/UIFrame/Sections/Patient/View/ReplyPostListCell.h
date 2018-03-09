//
//  ReplyPostListCell.h
//  JRMedical
//
//  Created by a on 16/12/10.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReplyPostModel.h"
#import "YHWorkGroupPhotoContainer.h"

@interface ReplyPostListCell : UITableViewCell

@property (nonatomic, strong) ReplyPostModel *model;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) UIImageView *headerPhoto;
@property (nonatomic, strong) UIImageView *isRenZhengImg;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *laiYuanLab;
@property (nonatomic, strong) UILabel *xingHaoLab;
@property (nonatomic, strong) UILabel *contactLab;

@property (nonatomic, strong) NSArray *picUrlArray;//缩略图URL
@property (nonatomic, strong) NSArray *picOriArray;//原图url
@property (nonatomic, strong) NSArray *rTypeArray;//图片类型

@property (nonatomic,strong) YHWorkGroupPhotoContainer *picContainerView;

@end
