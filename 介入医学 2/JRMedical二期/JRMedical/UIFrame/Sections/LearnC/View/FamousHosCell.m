//
//  FamousHosCell.m
//  JRMedical
//
//  Created by ww on 2016/12/28.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "FamousHosCell.h"

@interface FamousHosCell ()
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIImageView *doctorImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *levelLab;
@property (weak, nonatomic) IBOutlet UILabel *keshiLab;
@property (weak, nonatomic) IBOutlet UILabel *hosLab;
@property (weak, nonatomic) IBOutlet UIView *starView;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@property (weak, nonatomic) IBOutlet UILabel *lineLab;

@end

@implementation FamousHosCell

- (void)setFamousHosCellWithModel:(MyAttentionModel *)model {
    
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:model.Pic] placeholderImage:[UIImage imageNamed:@"mtou"]];
    if (model.IsRole) {
        self.doctorImageView.hidden = NO;
    } else {
        self.doctorImageView.hidden = YES;
    }
    
    self.nameLab.text = model.CustomerName;
    self.levelLab.text = model.PostName;
    self.keshiLab.text = model.DepartmentName;
    self.hosLab.text = model.HospitalName;
//    self.goodAtLab.text = [NSString stringWithFormat:@"擅长: %@", model.SpecialtyMsg];
    self.priceLab.text = [NSString stringWithFormat:@"%@元/次", model.DocAndPicPrice];
    
    NSInteger num = [model.Star integerValue];
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

/*
 
 @property (nonatomic, strong)NSString *DepartmentName; // 科室
 @property (nonatomic, strong)NSString *CLevel;   // 医院等级
 @property (nonatomic, strong)NSString *CustomerName; // 医生名称
 @property (nonatomic, strong)NSString *PostName; //医生职称
 @property (nonatomic, strong)NSString *HospitalName;//医院名称
 @property (nonatomic, strong)NSString *CustomerID; // 医生ID
 @property (nonatomic, strong)NSString *Pic; // 头像
 
 */

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
