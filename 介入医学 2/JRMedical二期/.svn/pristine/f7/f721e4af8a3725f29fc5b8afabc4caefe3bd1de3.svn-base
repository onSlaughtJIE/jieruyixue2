//
//  FamousHospitalCell.m
//  JRMedical
//
//  Created by ww on 2016/12/29.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "FamousHospitalCell.h"

@interface FamousHospitalCell ()
@property (weak, nonatomic) IBOutlet UIImageView *hosImageView;
@property (weak, nonatomic) IBOutlet UILabel *hosNameLab;
@property (weak, nonatomic) IBOutlet UILabel *levelLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UIView *starView;
@property (weak, nonatomic) IBOutlet UILabel *countLab;

@end

@implementation FamousHospitalCell

- (void)setFamousHospitalCellWithModel:(FamousHosModel *)model {
    
    [self.hosImageView sd_setImageWithURL:[NSURL URLWithString:model.Pic] placeholderImage:[UIImage imageNamed:@"jiazai"]];
    self.hosNameLab.text = model.HospitalName;
    self.levelLab.text = model.CLevel;
    self.addressLab.text = model.ProvinceName;
    self.countLab.text = model.ServiceCount;
    
    NSInteger num = [model.Level integerValue];
//    NSLog(@"self.starView.subview - %@", self.starView.subviews);
    switch (num) {
        case 0:
        {
            // 0等级
            for (UIImageView *imageView in self.starView.subviews) {
                imageView.hidden = YES;
            }
        }
            break;
        case 1:
        {
            // 1等级
            for (int i = 0; i < 5; i++) {
                UIImageView *imageView = self.starView.subviews[i];
                if (i == 0) {
                    imageView.hidden = NO;
                } else {
                    imageView.hidden = YES;
                }
            }
        }
            break;
        case 2:
        {
            // 2等级
            for (int i = 0; i < 5; i++) {
                UIImageView *imageView = self.starView.subviews[i];
                if (i == 0 || i == 1) {
                    imageView.hidden = NO;
                } else {
                    imageView.hidden = YES;
                }
            }
        }
            break;
        case 3:
        {
            // 3等级
            for (int i = 0; i < 5; i++) {
                UIImageView *imageView = self.starView.subviews[i];
                if (i == 0 || i == 1 || i == 2) {
                    imageView.hidden = NO;
                } else {
                    imageView.hidden = YES;
                }
            }
        }
            break;
        case 4:
        {
            // 4等级
            for (int i = 0; i < 5; i++) {
                UIImageView *imageView = self.starView.subviews[i];
                if (i == 0 || i == 1 || i == 2 || i == 3) {
                    imageView.hidden = NO;
                } else {
                    imageView.hidden = YES;
                }
            }
        }
            break;
        default:
        {
            // 5等级
            for (int i = 0; i < 5; i++) {
                UIImageView *imageView = self.starView.subviews[i];
                imageView.hidden = NO;
            }

        }
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
