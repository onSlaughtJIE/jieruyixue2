//
//  SetMyInfoCell.m
//  JRMedical
//
//  Created by a on 16/11/10.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "SetMyInfoCell.h"

@implementation SetMyInfoCell

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
    
    NSDictionary *userDic = [UserInfo gettUserInfoAll];

    switch (row) {
        case 0:
        {
            self.leftLab.text = @"昵        称";
            self.rightTF.placeholder = @"请输入您的昵称,不要超过4个字";
            
            if ([Utils isBlankString:userDic[@"NickName"]] == NO) {
                self.rightTF.text = userDic[@"NickName"];
            }
        }
            break;
        case 1:
        {
            self.leftLab.text = @"姓        名";
            self.rightTF.placeholder = @"请输入您的真实姓名";
            
            if ([Utils isBlankString:userDic[@"CustomerName"]] == NO) {
                self.rightTF.text = userDic[@"CustomerName"];
            }
        }
            break;
        case 2:
        {
            self.leftLab.text = @"性        别";
            self.rightTF.placeholder = @"请选择您的性别";
            self.rightTF.enabled = NO;
            
            if (userDic[@"Sex"] != nil) {
                NSInteger sex = [userDic[@"Sex"] integerValue];
                if (sex == 1) {
                    self.rightTF.text = @"男";
                }
                else {
                    self.rightTF.text = @"女";
                }
            }
        }
            break;
        case 3:
        {
            self.leftLab.text = @"地        区";
            self.rightTF.placeholder = @"请选择您所在的地区";
            self.rightTF.enabled = NO;
            
            if ([Utils isBlankString:userDic[@"ProvinceName"]] == NO && [Utils isBlankString:userDic[@"CityName"]] == NO) {
                self.rightTF.text = [NSString stringWithFormat:@"%@ %@",userDic[@"ProvinceName"],userDic[@"CityName"]];
            }
            else if ([Utils isBlankString:userDic[@"CityName"]] == YES && [Utils isBlankString:userDic[@"ProvinceName"]] == NO) {
                self.rightTF.text = userDic[@"ProvinceName"];
            }
            else if ([Utils isBlankString:userDic[@"CityName"]] == NO && [Utils isBlankString:userDic[@"ProvinceName"]] == YES) {
                self.rightTF.text = userDic[@"CityName"];
            }
        }
            break;
        case 4:
        {
            self.leftLab.text = @"出生年月";
            self.rightTF.placeholder = @"请选择您的出生年月日";
            self.rightTF.enabled = NO;
            
            if ([Utils isBlankString:userDic[@"BirthDay"]] == NO) {
                self.rightTF.text = userDic[@"BirthDay"];
            }
        }
            break;
        case 5:
        {
            self.rightTF.hidden = YES;
            self.rightTV.hidden = NO;
            self.leftLab.text = @"签        名";
            self.rightTV.placeholder = @"请输入您的个性签名,不要超过200字";
            
            if ([Utils isBlankString:userDic[@"Signature"]] == NO) {
                self.rightTV.text = userDic[@"Signature"];
            }
        }
            break;
        case 6:
        {
            self.rightTF.hidden = YES;
            self.id_Z_Img.hidden = NO;
            self.id_F_Img.hidden = NO;
            self.id_Z_Lab.hidden = NO;
            self.id_F_Lab.hidden = NO;
            self.leftLab.text = @"实名认证";
            
            if ([Utils isBlankString:userDic[@"IdentityPicJust"]] == NO) {
                [self.id_Z_Img sd_setImageWithURL:[NSURL URLWithString:userDic[@"IdentityPicJust"]] placeholderImage:[UIImage imageNamed:@"addd"]];
            }
            
            if ([Utils isBlankString:userDic[@"IdentityPicBack"]] == NO) {
                [self.id_F_Img sd_setImageWithURL:[NSURL URLWithString:userDic[@"IdentityPicBack"]] placeholderImage:[UIImage imageNamed:@"addd"]];
            }
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
    [self.contentView addSubview:self.id_Z_Img];
    [self.contentView addSubview:self.id_F_Img];
    [self.contentView addSubview:self.id_Z_Lab];
    [self.contentView addSubview:self.id_F_Lab];
    
    self.leftLab.sd_layout.topSpaceToView(self.contentView,5).leftSpaceToView(self.contentView,10).heightIs(40).widthIs(70);
    self.rightTF.sd_layout.centerYEqualToView(self.contentView).leftSpaceToView(self.leftLab,10).rightSpaceToView(self.contentView,10).heightIs(40);
    self.rightTV.sd_layout.centerYEqualToView(self.contentView).leftSpaceToView(self.leftLab,10).rightSpaceToView(self.contentView,10).heightIs(100);
    self.id_Z_Img.sd_layout.leftSpaceToView(self.leftLab,10).topSpaceToView(self.contentView,10).heightIs(80).widthIs(80);
    self.id_F_Img.sd_layout.leftSpaceToView(self.id_Z_Img,30).topSpaceToView(self.contentView,10).heightIs(80).widthIs(80);
    self.id_Z_Lab.sd_layout.leftSpaceToView(self.leftLab,10).topSpaceToView(self.id_Z_Img,5).heightIs(15).widthIs(80);
    self.id_F_Lab.sd_layout.leftSpaceToView(self.id_Z_Lab,30).topSpaceToView(self.id_F_Img,5).heightIs(15).widthIs(80);
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
- (UIImageView *)id_Z_Img {
    if (!_id_Z_Img) {
        _id_Z_Img = [UIImageView new];
        _id_Z_Img.image = [UIImage imageNamed:@"addd"];
        _id_Z_Img.hidden = YES;
        _id_Z_Img.userInteractionEnabled = YES;
        _id_Z_Img.clipsToBounds = YES;
        _id_Z_Img.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _id_Z_Img;
}
- (UIImageView *)id_F_Img {
    if (!_id_F_Img) {
        _id_F_Img = [UIImageView new];
        _id_F_Img.image = [UIImage imageNamed:@"addd"];
        _id_F_Img.hidden = YES;
        _id_F_Img.userInteractionEnabled = YES;
        _id_F_Img.clipsToBounds = YES;
        _id_F_Img.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _id_F_Img;
}
- (UILabel *)id_Z_Lab {
    if (!_id_Z_Lab) {
        _id_Z_Lab = [UILabel new];
        _id_Z_Lab.text = @"身份证正面";
        _id_Z_Lab.font = [UIFont systemFontOfSize:12];
        _id_Z_Lab.textAlignment = NSTextAlignmentCenter;
        _id_Z_Lab.textColor = HuiText_Color;
        _id_Z_Lab.hidden = YES;
    }
    return _id_Z_Lab;
}
- (UILabel *)id_F_Lab {
    if (!_id_F_Lab) {
        _id_F_Lab = [UILabel new];
        _id_F_Lab.text = @"身份证反面";
        _id_F_Lab.font = [UIFont systemFontOfSize:12];
        _id_F_Lab.textAlignment = NSTextAlignmentCenter;
        _id_F_Lab.textColor = HuiText_Color;
        _id_F_Lab.hidden = YES;
    }
    return _id_F_Lab;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
