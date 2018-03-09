//
//  AddNewAddressCell.h
//  JRMedical
//
//  Created by a on 16/12/16.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAddressModel.h"

@interface AddNewAddressCell : UITableViewCell

@property (nonatomic, strong) MyAddressModel *model;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) UILabel *leftLab;
@property (nonatomic, strong) UITextField *rightTF;
@property (nonatomic, strong) UIImageView *rightImage;

@end
