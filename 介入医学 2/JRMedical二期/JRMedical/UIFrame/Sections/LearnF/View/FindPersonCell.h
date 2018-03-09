//
//  FindPersonCell.h
//  JRMedical
//
//  Created by ww on 2016/12/19.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindPersonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *personAddBtn;
@property (weak, nonatomic) IBOutlet UIImageView *personImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab; // name暂时没有, 要根据环信ID去获取昵称
@property (weak, nonatomic) IBOutlet UILabel *telLab;

@end
