//
//  AddNewAddressCell.m
//  JRMedical
//
//  Created by a on 16/12/16.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "AddNewAddressCell.h"

@implementation AddNewAddressCell

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
            self.leftLab.text = @"联系方式";
            self.rightTF.placeholder = @"请输入您的手机号";
        }
            break;
        case 2:
        {
            self.leftLab.text = @"地        区";
            self.rightTF.placeholder = @"请选择所在地区";
            self.rightTF.enabled = NO;
            _rightImage.hidden = NO;
        }
            break;
        case 3:
        {
            self.leftLab.text = @"详细地址";
            self.rightTF.placeholder = @"街道,楼牌号等";
        }
            break;
        default:
            break;
    }
}

- (void)setModel:(MyAddressModel *)model {
    _model = model;
    
    NSInteger row = self.indexPath.row;
    
    switch (row) {
        case 0:
        self.rightTF.text = model.ConsigneeName;
            break;
        case 1:
        self.rightTF.text = model.Consigneephone;
            break;
        case 2:
        {
            if ([model.Province isEqualToString:model.City]) {
                self.rightTF.text = [NSString stringWithFormat:@"%@%@",model.Province,model.County];
            }
            else {
                self.rightTF.text = [NSString stringWithFormat:@"%@%@%@",model.Province,model.City,model.County];
            }
        }
            break;
        case 3:
        self.rightTF.text = model.DetailAddress;
            break;
        default:
            break;
    }
}

#pragma mark - 初始化视图
- (void)initCellView {
    
    [self.contentView addSubview:self.leftLab];
    [self.contentView addSubview:self.rightImage];
    [self.contentView addSubview:self.rightTF];
    
    self.leftLab.sd_layout.centerYEqualToView(self.contentView).leftSpaceToView(self.contentView,10).heightIs(40).widthIs(70);
    self.rightImage.sd_layout.centerYEqualToView(self.contentView).rightSpaceToView(self.contentView,10).widthIs(10).heightIs(18);
    self.rightTF.sd_layout.centerYEqualToView(self.contentView).leftSpaceToView(self.leftLab,10).rightSpaceToView(self.rightImage,10).heightIs(40);
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
- (UIImageView *)rightImage {
    if (!_rightImage) {
        _rightImage = [UIImageView new];
        _rightImage.image = [UIImage imageNamed:@"yougengduo"];
        _rightImage.hidden = YES;
    }
    return _rightImage;
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
