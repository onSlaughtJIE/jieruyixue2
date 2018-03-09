//
//  OrderFaPiaoContantCell.m
//  JRMedical
//
//  Created by a on 16/12/19.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "OrderFaPiaoContantCell.h"

@implementation OrderFaPiaoContantCell {
    
    NSInteger _oldBtnTag;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.typeLab];
        [self.contentView addSubview:self.orderFaPiaoView];
        [self.contentView addSubview:self.contantView];
        
        self.typeLab.sd_layout.topSpaceToView(self.contentView,15).leftSpaceToView(self.contentView,15).rightSpaceToView(self.contentView,15).heightIs(14);
        self.orderFaPiaoView.sd_layout.topSpaceToView(self.typeLab,15).leftSpaceToView(self.contentView,10).rightSpaceToView(self.contentView,10).heightIs(0.8);
        
        
    }
    return self;
}


- (void)buttonClick:(UIButton *)btn {
    
     UIButton *oldBtn =  [self viewWithTag:_oldBtnTag];
    oldBtn.selected = NO;
    UIButton *newBtn =  [self viewWithTag:btn.tag];
    newBtn.selected = YES;
    //保存
    _oldBtnTag = btn.tag;
    
    NSDictionary *dataDic = self.dataAry[btn.tag-100];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectFoPiaoContantClick:)]) {//设置按钮代理点击将所选发票内容传出去
        [self.delegate selectFoPiaoContantClick:dataDic[@"Value"]];
    }
}

- (void)setDataAry:(NSArray *)dataAry {
    _dataAry = dataAry;
    
    for(UIView *view in [self.contantView subviews])
    {
        if ([view isKindOfClass:[KMButton class]]) {
            [view removeFromSuperview];
        }
    }
    
    CGFloat heightScreen;
    if (dataAry.count <= 3) {
        heightScreen = 50;
    }
    else if (dataAry.count >3 && dataAry.count <= 6) {
        heightScreen = 110;
    }
    else {
        heightScreen = 170;
    }
    
    self.contantView.sd_layout.topSpaceToView(self.orderFaPiaoView,15).leftSpaceToView(self.contentView,15).rightSpaceToView(self.contentView,15).heightIs(heightScreen);
    
    int hang = (Width_Screen-30-100*3)/4;
    int lie = 10;
    for (int i = 0; i < dataAry.count; i++) {
        
        NSDictionary *dataDic = dataAry[i];

        KMButton *btn = [KMButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((i%3)*(hang+100), (i/3)*(lie+50), 100, 50);
        btn.spacing = 5;
        btn.margin = 1;
        btn.kMButtonType = KMButtonLeft;
        [btn setImage:[UIImage imageNamed:@"weixuan"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"duidui"] forState:UIControlStateSelected];
        [btn setTitle:dataDic[@"Name"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.tag = 100 + i;
        
        if (i == 0) {
            btn.selected = YES;
            _oldBtnTag = btn.tag;
        }
        else {
            btn.selected = NO;
        }
        
        [self.contantView addSubview:btn];
    }
}

- (UILabel *)typeLab {
    if (!_typeLab) {
        _typeLab = [UILabel new];
        _typeLab.font = [UIFont systemFontOfSize:14];
        _typeLab.text = @"发票内容";
    }
    return _typeLab;
}
- (UIView *)orderFaPiaoView {
    if (!_orderFaPiaoView) {
        _orderFaPiaoView = [UIView new];
        _orderFaPiaoView.backgroundColor = RGB(220, 220, 220);
    }
    return _orderFaPiaoView;
}
- (UIView *)contantView {
    if (!_contantView) {
        _contantView = [UIView new];
    }
    return _contantView;
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
