//
//  MerchandiseTypeCell.h
//  JRMedical
//
//  Created by a on 16/12/5.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerchandiseTypeView.h"

@protocol MerchandiseTypeCellDelegate <NSObject>

- (void)selectTypeView:(NSInteger)typeTag;

@end

@interface MerchandiseTypeCell : UICollectionViewCell
//
@property (nonatomic, assign) id<MerchandiseTypeCellDelegate>delegate;

@property (nonatomic, strong) NSMutableArray *modelAry;
@property (nonatomic, strong) UIScrollView *horizonScroll;

@property (nonatomic, strong) UIImageView *rightImg;
@property (nonatomic, strong) UIImageView *leftImg;

@property (strong, nonatomic) MerchandiseTypeView *mtypeView;

@end
