//
//  SpPingluCell.m
//  JRMedical
//
//  Created by apple on 16/5/13.
//  Copyright © 2016年 ZC. All rights reserved.
//

#import "SpPingluCell.h"
#import "SpCommentModel.h"

@interface SpPingluCell ()

@end

@implementation SpPingluCell

- (void)setModel:(SpCommentModel *)model {
    _model = model;
    
    if (model.IsRole) {
        self.SpIsRenZhengImg.hidden = NO;
    }
    else {
        self.SpIsRenZhengImg.hidden = YES;
    }
    
    self.fromLab.text = model.EvaluateDevice;
    self.SpCommentLabel.text = [NSString stringWithFormat:@"%@",model.ResourcesContent];
    self.SpPublicTime.text = model.Time;
    [self.SpUserImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.CustomerPic]] placeholderImage:[UIImage imageNamed:@"mtou"]];
    self.SpUserName.text = model.CustomerName;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
