//
//  MedicineRegistrationCell.m
//  JRMedical
//
//  Created by a on 16/12/6.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "MedicineRegistrationCell.h"

@implementation MedicineRegistrationCell

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
    
    NSInteger row = indexPath.row;
    
    switch (row) {
        case 0:
        {
            self.leftLab.text = @"姓        名";
            self.rightTF.placeholder = @"请输入真实姓名(必填)";
        }
            break;
        case 1:
        {
            self.leftLab.text = @"电        话";
            self.rightTF.placeholder = @"请输入手机号码(必填)";
        }
            break;
        case 2:
        {
            self.leftLab.text = @"医        院";
            self.rightTF.placeholder = @"请输入医院名称";
        }
            break;
        case 3:
        {
            self.leftLab.text = @"科        室";
            self.rightTF.placeholder = @"请输入科室名称";
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
    
    self.leftLab.sd_layout.topSpaceToView(self.contentView,5).leftSpaceToView(self.contentView,10).heightIs(40).widthIs(70);
    self.rightTF.sd_layout.centerYEqualToView(self.contentView).leftSpaceToView(self.leftLab,10).rightSpaceToView(self.contentView,15).heightIs(40);
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
