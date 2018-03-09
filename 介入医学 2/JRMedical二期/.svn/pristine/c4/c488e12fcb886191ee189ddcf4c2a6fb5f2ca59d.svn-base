//
//  MyCertificationCell.m
//  JRMedical
//
//  Created by a on 16/11/10.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "MyCertificationCell.h"

@implementation MyCertificationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        
        [self initCellView];
    }
    return self;
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    NSInteger row = self.indexPath.row;
    
    switch (row) {
        case 0:
        {
            self.leftLab.text = @"姓        名";
            self.rightTF.placeholder = @"请输入您的真实姓名";
        }
            break;
        case 1:
        {
            self.leftLab.text = @"医        院";
            self.rightTF.placeholder = @"选择您所在的医院,如果没有请添加";
            self.rightTF.enabled = NO;
        }
            break;
        case 2:
        {
            self.leftLab.text = @"科        室";
            self.rightTF.placeholder = @"选择您所在的科室";
            self.rightTF.enabled = NO;
        }
            break;
        case 3:
        {
            self.leftLab.text = @"职        称";
            self.rightTF.placeholder = @"选择您的职称";
            self.rightTF.enabled = NO;
        }
            break;
        case 4:
        {
            self.leftLab.text = @"介        入";
            self.rightTF.placeholder = @"选择您的介入学科,可多选";
            self.rightTF.enabled = NO;
        }
            break;
        case 5:
        {
            self.leftLab.text = @"擅        长";
            self.rightTV.placeholder = @"请输入您擅长的领域";
            self.rightTF.hidden = YES;
            self.rightTV.hidden = NO;
        }
            break;
        case 6:
        {
            self.leftLab.text = @"成        果";
            self.rightTV.placeholder = @"请输入您的成果";
            self.rightTF.hidden = YES;
            self.rightTV.hidden = NO;
        }
            break;
        default:
            break;
    }
}

- (void)setRenZhengDic:(NSDictionary *)renZhengDic {
    _renZhengDic = renZhengDic;
    
    NSInteger row = self.indexPath.row;
    
    switch (row) {
        case 0:
        {
            self.rightTF.text = renZhengDic[@"CustomerName"];
        }
            break;
        case 1:
        {
            self.rightTF.text = renZhengDic[@"HospitalName"];
        }
            break;
        case 2:
        {
            self.rightTF.text = renZhengDic[@"DepartmentName"];
        }
            break;
        case 3:
        {
            self.rightTF.text = renZhengDic[@"PostName"];
        }
            break;
        case 4:
        {
            self.rightTF.text = renZhengDic[@"InterventionMsgName"];
        }
            break;
        case 5:
        {
            self.rightTV.text = renZhengDic[@"SpecialtyMsg"];
        }
            break;
        case 6:
        {
            self.rightTV.text = renZhengDic[@"AchievementsMsg"];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 初始化视图
- (void)initCellView {
    
    [self.contentView addSubview:self.leftLab];
    [self.contentView addSubview:self.rightTF];
    [self.contentView addSubview:self.rightTV];
    
    self.leftLab.sd_layout.topSpaceToView(self.contentView,5).leftSpaceToView(self.contentView,10).heightIs(40).widthIs(70);
    self.rightTF.sd_layout.centerYEqualToView(self.contentView).leftSpaceToView(self.leftLab,10).rightSpaceToView(self.contentView,15).heightIs(40);
    self.rightTV.sd_layout.centerYEqualToView(self.contentView).leftSpaceToView(self.leftLab,10).rightSpaceToView(self.contentView,10).heightIs(100);
}

#pragma mark - 懒加载
- (UILabel *)leftLab {
    if (!_leftLab) {
        _leftLab = [UILabel new];
        _leftLab.font = [UIFont systemFontOfSize:15];
    }
    return _leftLab;
}
- (UITextField *)rightTF {
    if (!_rightTF) {
        _rightTF = [UITextField new];
        _rightTF.font = [UIFont systemFontOfSize:15];
        _rightTF.returnKeyType = UIReturnKeyDone;
        _rightTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _rightTF;
}
- (IQTextView *)rightTV {
    if (!_rightTV) {
        _rightTV = [IQTextView new];
        _rightTV.font = [UIFont systemFontOfSize:15];
        _rightTV.layer.borderColor = BG_Color.CGColor;
        _rightTV.layer.cornerRadius = 5;
        _rightTV.clipsToBounds = YES;
        _rightTV.layer.borderWidth = 1;
        _rightTV.hidden = YES;
    }
    return _rightTV;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
