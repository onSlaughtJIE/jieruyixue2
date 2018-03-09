//
//  GroupApplyZuweiCell.m
//  JRMedical
//
//  Created by ww on 2016/12/14.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "GroupApplyZuweiCell.h"

@implementation GroupApplyZuweiCell

- (void)setGroupApplyZuweiCellWithModelArr:(NSArray *)modelArr {
    
    //        NSDictionary *insideDic = array[indexPath.row];
    //        OrgDetailModel * insideModel = [[OrgDetailModel alloc] init];
    //        [insideModel setValuesForKeysWithDictionary:insideDic];
    
    switch (modelArr.count) {
        case 0:
        {
            self.oneImage.hidden = YES;
            self.twoImage.hidden = YES;
            self.threeImage.hidden = YES;
            self.fourImage.hidden = YES;
            self.fiveImage.hidden = YES;
            
        }
            break;
        case 1:
        {
            self.oneImage.hidden = NO;
            self.twoImage.hidden = YES;
            self.threeImage.hidden = YES;
            self.fourImage.hidden = YES;
            self.fiveImage.hidden = YES;
            
            NSDictionary *insideDic = modelArr[0];
            OrgDetailModel *insideModel = [[OrgDetailModel alloc] init];
            [insideModel setValuesForKeysWithDictionary:insideDic];
            [self.oneImage sd_setImageWithURL:[NSURL URLWithString:insideModel.Pic] placeholderImage:[UIImage imageNamed:@"mtou"]];
            
        }
            break;
        case 2:
        {
            self.oneImage.hidden = NO;
            self.twoImage.hidden = NO;
            self.threeImage.hidden = YES;
            self.fourImage.hidden = YES;
            self.fiveImage.hidden = YES;
            
            NSDictionary *insideDic = modelArr[0];
            OrgDetailModel *insideModel = [[OrgDetailModel alloc] init];
            [insideModel setValuesForKeysWithDictionary:insideDic];
            [self.oneImage sd_setImageWithURL:[NSURL URLWithString:insideModel.Pic] placeholderImage:[UIImage imageNamed:@"mtou"]];
            
            NSDictionary *insideDic2 = modelArr[1];
            OrgDetailModel *insideModel2 = [[OrgDetailModel alloc] init];
            [insideModel2 setValuesForKeysWithDictionary:insideDic2];
            [self.twoImage sd_setImageWithURL:[NSURL URLWithString:insideModel2.Pic] placeholderImage:[UIImage imageNamed:@"mtou"]];
        }
            break;
        case 3:
        {
            self.oneImage.hidden = NO;
            self.twoImage.hidden = NO;
            self.threeImage.hidden = NO;
            self.fourImage.hidden = YES;
            self.fiveImage.hidden = YES;
            
            NSDictionary *insideDic = modelArr[0];
            OrgDetailModel *insideModel = [[OrgDetailModel alloc] init];
            [insideModel setValuesForKeysWithDictionary:insideDic];
            [self.oneImage sd_setImageWithURL:[NSURL URLWithString:insideModel.Pic] placeholderImage:[UIImage imageNamed:@"mtou"]];
            
            NSDictionary *insideDic2 = modelArr[1];
            OrgDetailModel *insideModel2 = [[OrgDetailModel alloc] init];
            [insideModel2 setValuesForKeysWithDictionary:insideDic2];
            [self.twoImage sd_setImageWithURL:[NSURL URLWithString:insideModel2.Pic] placeholderImage:[UIImage imageNamed:@"mtou"]];
            
            NSDictionary *insideDic3 = modelArr[2];
            OrgDetailModel *insideModel3 = [[OrgDetailModel alloc] init];
            [insideModel3 setValuesForKeysWithDictionary:insideDic3];
            [self.threeImage sd_setImageWithURL:[NSURL URLWithString:insideModel3.Pic] placeholderImage:[UIImage imageNamed:@"mtou"]];
        }
            break;
        case 4:
        {
            self.oneImage.hidden = NO;
            self.twoImage.hidden = NO;
            self.threeImage.hidden = NO;
            self.fourImage.hidden = NO;
            self.fiveImage.hidden = YES;
            
            NSDictionary *insideDic = modelArr[0];
            OrgDetailModel *insideModel = [[OrgDetailModel alloc] init];
            [insideModel setValuesForKeysWithDictionary:insideDic];
            [self.oneImage sd_setImageWithURL:[NSURL URLWithString:insideModel.Pic] placeholderImage:[UIImage imageNamed:@"mtou"]];
            
            NSDictionary *insideDic2 = modelArr[1];
            OrgDetailModel *insideModel2 = [[OrgDetailModel alloc] init];
            [insideModel2 setValuesForKeysWithDictionary:insideDic2];
            [self.twoImage sd_setImageWithURL:[NSURL URLWithString:insideModel2.Pic] placeholderImage:[UIImage imageNamed:@"mtou"]];
            
            NSDictionary *insideDic3 = modelArr[2];
            OrgDetailModel *insideModel3 = [[OrgDetailModel alloc] init];
            [insideModel3 setValuesForKeysWithDictionary:insideDic3];
            [self.threeImage sd_setImageWithURL:[NSURL URLWithString:insideModel3.Pic] placeholderImage:[UIImage imageNamed:@"mtou"]];
            
            NSDictionary *insideDic4 = modelArr[2];
            OrgDetailModel *insideModel4 = [[OrgDetailModel alloc] init];
            [insideModel4 setValuesForKeysWithDictionary:insideDic4];
            [self.fourImage sd_setImageWithURL:[NSURL URLWithString:insideModel4.Pic] placeholderImage:[UIImage imageNamed:@"mtou"]];
            
        }
            break;
        default: // 5个或超过5个
        {
            self.oneImage.hidden = NO;
            self.twoImage.hidden = NO;
            self.threeImage.hidden = NO;
            self.fourImage.hidden = NO;
            self.fiveImage.hidden = NO;
            
            NSDictionary *insideDic = modelArr[0];
            OrgDetailModel *insideModel = [[OrgDetailModel alloc] init];
            [insideModel setValuesForKeysWithDictionary:insideDic];
            [self.oneImage sd_setImageWithURL:[NSURL URLWithString:insideModel.Pic] placeholderImage:[UIImage imageNamed:@"mtou"]];
            
            NSDictionary *insideDic2 = modelArr[1];
            OrgDetailModel *insideModel2 = [[OrgDetailModel alloc] init];
            [insideModel2 setValuesForKeysWithDictionary:insideDic2];
            [self.twoImage sd_setImageWithURL:[NSURL URLWithString:insideModel2.Pic] placeholderImage:[UIImage imageNamed:@"mtou"]];
            
            NSDictionary *insideDic3 = modelArr[2];
            OrgDetailModel *insideModel3 = [[OrgDetailModel alloc] init];
            [insideModel3 setValuesForKeysWithDictionary:insideDic3];
            [self.threeImage sd_setImageWithURL:[NSURL URLWithString:insideModel3.Pic] placeholderImage:[UIImage imageNamed:@"mtou"]];
            
            NSDictionary *insideDic4 = modelArr[3];
            OrgDetailModel *insideModel4 = [[OrgDetailModel alloc] init];
            [insideModel4 setValuesForKeysWithDictionary:insideDic4];
            [self.fourImage sd_setImageWithURL:[NSURL URLWithString:insideModel4.Pic] placeholderImage:[UIImage imageNamed:@"mtou"]];
            
            NSDictionary *insideDic5 = modelArr[4];
            OrgDetailModel *insideModel5 = [[OrgDetailModel alloc] init];
            [insideModel5 setValuesForKeysWithDictionary:insideDic5];
            [self.fiveImage sd_setImageWithURL:[NSURL URLWithString:insideModel5.Pic] placeholderImage:[UIImage imageNamed:@"mtou"]];
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
