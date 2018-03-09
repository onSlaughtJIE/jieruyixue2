//
//  GroupTableViewCell.m
//  JRMedical
//
//  Created by ww on 2016/12/14.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "GroupTableViewCell.h"
#import "GroupModel.h"
#import "SheHuiModel.h"
#import "GroupSearchModel.h"

@implementation GroupTableViewCell


- (void)setValueByModel:(GroupModel *)model {
    [self.groupImageView sd_setImageWithURL:[NSURL URLWithString:model.Pic] placeholderImage:[UIImage imageNamed:@"tou"]];
    self.titleLab.text = [NSString stringWithFormat:@"%@(%@)", model.GroupName, model.Maxusers];
    self.subLab.text = [NSString stringWithFormat:@"%@", model.Remark];
    self.joinBiaoshiLab.hidden = YES;
    
}
- (void)setValueSheHuiModel:(SheHuiModel *)model {
    
    [self.groupImageView sd_setImageWithURL:[NSURL URLWithString:model.grouppic] placeholderImage:[UIImage imageNamed:@"tou"]];
    self.titleLab.text = [NSString stringWithFormat:@"%@(%@)", model.groupname, model.affiliationscount];
    self.subLab.text = [NSString stringWithFormat:@"%@", model.desc];
    self.joinBiaoshiLab.hidden = YES;
}

- (void)setValueWithGroupSearchModle:(GroupSearchModel *)model {
    
    [self.groupImageView sd_setImageWithURL:[NSURL URLWithString:model.Pic] placeholderImage:[UIImage imageNamed:@"tou"]];
    self.titleLab.text = [NSString stringWithFormat:@"%@(%@)", model.GroupName, model.Maxusers];
    self.subLab.text = [NSString stringWithFormat:@"%@", model.Remark];
    switch (model.GroupCategory) {
        case 0:
            self.joinBiaoshiLab.text = @"官方群";
            break;
        case 1:
            self.joinBiaoshiLab.text = @"学术群";
            break;
        default:
            self.joinBiaoshiLab.text = @"社会群";
            break;
    }
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
