//
//  LiveTableViewCell.m
//  JRMedical
//
//  Created by ww on 2016/11/23.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "LiveTableViewCell.h"
#import "EasePublishModel.h"

@interface LiveTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *customerPic;
@property (weak, nonatomic) IBOutlet UILabel *customerName;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *lookCountLab;
@property (weak, nonatomic) IBOutlet UIImageView *liveImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *zaikan;



@end

@implementation LiveTableViewCell

- (void)setLiveTableViewCellWithModel:(EasePublishModel *)model {
    
    [self.customerPic sd_setImageWithURL:[NSURL URLWithString:model.CustomerPic] placeholderImage:[UIImage imageNamed:@"mtou"]];
    self.customerName.text = model.CustomerName;
    self.addressLab.text = model.Address;
    self.lookCountLab.text = [NSString stringWithFormat:@"%ld次", (long)model.PlayCount];

    [self.liveImageView sd_setImageWithURL:[NSURL URLWithString:model.Image] placeholderImage:[UIImage imageNamed:@"jiazai"]];
    self.titleLab.text = model.Title;
    self.priceLab.text = [NSString stringWithFormat:@"¥%.2f", model.Pice];
    
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
