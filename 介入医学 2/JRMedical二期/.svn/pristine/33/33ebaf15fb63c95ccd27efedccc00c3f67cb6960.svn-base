//
//  ChooseAddressTableViewCell.h
//  HongJHome
//
//  Created by 曹柏涵 on 15/8/26.
//  Copyright (c) 2015年 yizhisheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMButton.h"
#import "MyAddressModel.h"

@protocol ChooseAddressTableViewCellDelegate <NSObject>

- (void)selectRowDelectClick:(NSIndexPath *)indexPath;

@end

@interface ChooseAddressTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (strong, nonatomic) MyAddressModel *model;

@property (nonatomic, assign) id<ChooseAddressTableViewCellDelegate> delegate;

@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *phoneLab;
@property (nonatomic, strong) UILabel *contantLab;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) KMButton *moRenAddBtn;
@property (nonatomic, strong) KMButton *bianJiBtn;
@property (nonatomic, strong) KMButton *deleBtn;

@end
