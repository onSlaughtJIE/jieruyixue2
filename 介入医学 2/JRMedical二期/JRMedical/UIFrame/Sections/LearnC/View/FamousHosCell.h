//
//  FamousHosCell.h
//  JRMedical
//
//  Created by ww on 2016/12/28.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAttentionModel.h"

@interface FamousHosCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *chatBtn;

- (void)setFamousHosCellWithModel:(MyAttentionModel *)model;

@end
