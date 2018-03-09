//
//  AuthorCell.m
//  JRMedical
//
//  Created by a on 16/11/17.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "AuthorCell.h"

@implementation AuthorCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        self.backgroundColor = BG_Color;

        self.contentLab.text = @"        以后宝阳的问题，不管是我发的还是客户发的，除非我强调要立即改，否则2天之内改完发布即可。后续不再重复。他们的微信申请下来了，需要把微信支付添加上去，等他们接口提供好";
        
        [self initCellView];
    }
    return self;
}

#pragma mark - 初始化视图
- (void)initCellView {
    
    [self.contentView addSubview:self.contentLab];
    [self.contentView addSubview:self.xiaLaImg];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.lineView2];
    
    self.xiaLaImg.sd_layout.centerXEqualToView(self.contentView).bottomSpaceToView(self.contentView,15).widthIs(13).heightIs(15);
    self.contentLab.sd_layout.leftSpaceToView(self.contentView,10).rightSpaceToView(self.contentView,10).topSpaceToView(self.contentView,10).bottomSpaceToView(self.xiaLaImg,15);
    self.lineView.sd_layout.bottomSpaceToView(self.contentView,1).leftSpaceToView(self.contentView,10).rightSpaceToView(self.contentView,10).heightIs(1);
    self.lineView2.sd_layout.bottomSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,10).rightSpaceToView(self.contentView,10).heightIs(1);
}

#pragma mark - 懒加载
- (UILabel *)contentLab {
    if (!_contentLab) {
        _contentLab = [UILabel new];
        _contentLab.font = [UIFont systemFontOfSize:14];
        _contentLab.textColor = RGB(90, 90, 90);
        _contentLab.numberOfLines = 0;
    }
    return _contentLab;
}
- (UIImageView *)xiaLaImg {
    if (!_xiaLaImg) {
        _xiaLaImg = [UIImageView new];
        _xiaLaImg.image = [UIImage imageNamed:@"shuangxia"];
    }
    return _xiaLaImg;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = RGB(220, 220, 220);
    }
    return _lineView;
}
- (UIView *)lineView2 {
    if (!_lineView2) {
        _lineView2 = [UIView new];
        _lineView2.backgroundColor = RGB(250, 250, 250);
    }
    return _lineView2;
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
