//
//  HuiFangTableViewCell.m
//  JRMedical
//
//  Created by ww on 2016/11/29.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "HuiFangTableViewCell.h"
#import "EasePublishModel.h"

@interface HuiFangTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *customerPic;
@property (weak, nonatomic) IBOutlet UILabel *customerName;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;

@property (weak, nonatomic) IBOutlet UIImageView *liveImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;


@end

@implementation HuiFangTableViewCell

- (void)setHuiFangCellWithModel:(EasePublishModel *)model {
    
    [self.customerPic sd_setImageWithURL:[NSURL URLWithString:model.CustomerPic] placeholderImage:[UIImage imageNamed:@"mtou"]];
    self.customerName.text = model.CustomerName;
    self.addressLab.text = model.Address;

    [self.liveImageView sd_setImageWithURL:[NSURL URLWithString:model.Image] placeholderImage:[UIImage imageNamed:@"jiazai"]];
    self.titleLab.text = model.Title;
    
    
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
