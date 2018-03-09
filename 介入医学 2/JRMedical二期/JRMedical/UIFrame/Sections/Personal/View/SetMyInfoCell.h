//
//  SetMyInfoCell.h
//  JRMedical
//
//  Created by a on 16/11/10.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQTextView.h"

@interface SetMyInfoCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) UILabel *leftLab;
@property (nonatomic, strong) UITextField *rightTF;

@property (nonatomic, strong) IQTextView *rightTV;
@property (nonatomic, strong) UIImageView *id_Z_Img;
@property (nonatomic, strong) UIImageView *id_F_Img;
@property (nonatomic, strong) UILabel *id_Z_Lab;
@property (nonatomic, strong) UILabel *id_F_Lab;

@end
