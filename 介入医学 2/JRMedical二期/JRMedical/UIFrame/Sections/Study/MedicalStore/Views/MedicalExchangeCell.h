//
//  MedicalExchangeCell.h
//  JRMedical
//
//  Created by a on 16/12/19.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface MedicalExchangeCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *dataAry;

@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UIImageView *ubIcon;
@property (nonatomic, strong) UILabel *ubNumLab;
@property (nonatomic, strong) UIImageView *plaimage;

@end
