//
//  PatientAskCell.h
//  JRMedical
//
//  Created by apple on 16/6/28.
//  Copyright © 2016年 ZC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PatientAskModel;

@interface PatientAskCell : UITableViewCell

- (void)setDataWithModel:(PatientAskModel *)model;

@end
