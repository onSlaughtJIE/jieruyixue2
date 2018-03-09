//
//  DoctorInfoJianLiCell.m
//  JRMedical
//
//  Created by a on 16/12/29.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "DoctorInfoJianLiCell.h"

@implementation DoctorInfoJianLiCell

- (void)setDataImgAry:(NSArray *)dataImgAry {
    _dataImgAry = dataImgAry;
    
    switch (dataImgAry.count) {
        case 1:
        {
            
            self.image2.hidden = YES;
            self.image3.hidden = YES;
            self.image4.hidden = YES;
            self.image5.hidden = YES;
            self.image6.hidden = YES;
            
            NSDictionary *imageDic1 = dataImgAry[0];
            [self.image1 sd_setImageWithURL:[NSURL URLWithString:imageDic1[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
        }
            break;
        case 2:
        {
            
            self.image3.hidden = YES;
            self.image4.hidden = YES;
            self.image5.hidden = YES;
            self.image6.hidden = YES;
            
            NSDictionary *imageDic1 = dataImgAry[0];
            NSDictionary *imageDic2 = dataImgAry[1];
            [self.image1 sd_setImageWithURL:[NSURL URLWithString:imageDic1[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
            [self.image2 sd_setImageWithURL:[NSURL URLWithString:imageDic2[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
        }
            break;
        case 3:
        {
            self.image4.hidden = YES;
            self.image5.hidden = YES;
            self.image6.hidden = YES;
            
            NSDictionary *imageDic1 = dataImgAry[0];
            NSDictionary *imageDic2 = dataImgAry[1];
            NSDictionary *imageDic3 = dataImgAry[2];
            [self.image1 sd_setImageWithURL:[NSURL URLWithString:imageDic1[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
            [self.image2 sd_setImageWithURL:[NSURL URLWithString:imageDic2[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
            [self.image3 sd_setImageWithURL:[NSURL URLWithString:imageDic3[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
        }
            break;
        case 4:
        {
            self.image5.hidden = YES;
            self.image6.hidden = YES;
            
            NSDictionary *imageDic1 = dataImgAry[0];
            NSDictionary *imageDic2 = dataImgAry[1];
            NSDictionary *imageDic3 = dataImgAry[2];
            NSDictionary *imageDic4 = dataImgAry[3];
            [self.image1 sd_setImageWithURL:[NSURL URLWithString:imageDic1[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
            [self.image2 sd_setImageWithURL:[NSURL URLWithString:imageDic2[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
            [self.image3 sd_setImageWithURL:[NSURL URLWithString:imageDic3[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
            [self.image4 sd_setImageWithURL:[NSURL URLWithString:imageDic4[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
        }
            break;
        case 5:
        {
            self.image6.hidden = YES;
            
            NSDictionary *imageDic1 = dataImgAry[0];
            NSDictionary *imageDic2 = dataImgAry[1];
            NSDictionary *imageDic3 = dataImgAry[2];
            NSDictionary *imageDic4 = dataImgAry[3];
            NSDictionary *imageDic5 = dataImgAry[4];
            [self.image1 sd_setImageWithURL:[NSURL URLWithString:imageDic1[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
            [self.image2 sd_setImageWithURL:[NSURL URLWithString:imageDic2[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
            [self.image3 sd_setImageWithURL:[NSURL URLWithString:imageDic3[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
            [self.image4 sd_setImageWithURL:[NSURL URLWithString:imageDic4[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
            [self.image5 sd_setImageWithURL:[NSURL URLWithString:imageDic5[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
        }
            break;
        case 6:
        {
            NSDictionary *imageDic1 = dataImgAry[0];
            NSDictionary *imageDic2 = dataImgAry[1];
            NSDictionary *imageDic3 = dataImgAry[2];
            NSDictionary *imageDic4 = dataImgAry[3];
            NSDictionary *imageDic5 = dataImgAry[4];
            NSDictionary *imageDic6 = dataImgAry[5];
            [self.image1 sd_setImageWithURL:[NSURL URLWithString:imageDic1[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
            [self.image2 sd_setImageWithURL:[NSURL URLWithString:imageDic2[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
            [self.image3 sd_setImageWithURL:[NSURL URLWithString:imageDic3[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
            [self.image4 sd_setImageWithURL:[NSURL URLWithString:imageDic4[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
            [self.image5 sd_setImageWithURL:[NSURL URLWithString:imageDic5[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
            [self.image6 sd_setImageWithURL:[NSURL URLWithString:imageDic6[@"ImgUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
        }
            break;
        default:
            break;
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle  = UITableViewCellSelectionStyleNone;
    
    self.imageHeight.constant = (Width_Screen-60)/3;
    
    self.image1.userInteractionEnabled = YES;
    self.image2.userInteractionEnabled = YES;
    self.image3.userInteractionEnabled = YES;
    self.image4.userInteractionEnabled = YES;
    self.image5.userInteractionEnabled = YES;
    self.image6.userInteractionEnabled = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
