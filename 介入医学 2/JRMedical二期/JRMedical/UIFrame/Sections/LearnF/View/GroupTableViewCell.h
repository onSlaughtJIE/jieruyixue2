//
//  GroupTableViewCell.h
//  JRMedical
//
//  Created by ww on 2016/12/14.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GroupModel;
@class SheHuiModel;
@class GroupSearchModel;

@interface GroupTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *groupImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *subLab;
@property (weak, nonatomic) IBOutlet UILabel *joinBiaoshiLab;

- (void)setValueByModel:(GroupModel *)model;

- (void)setValueSheHuiModel:(SheHuiModel *)model;

- (void)setValueWithGroupSearchModle:(GroupSearchModel *)model;

@end
