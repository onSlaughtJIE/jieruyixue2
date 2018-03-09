//
//  TopNewsCell.m
//  JRMedical
//
//  Created by a on 16/12/7.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "TopNewsCell.h"

@implementation TopNewsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = RGB(245, 245, 245);
        
        [self.contentView addSubview:self.topLab];
        [self.contentView addSubview:self.titleLab];
        
        self.topLab.sd_layout.centerYEqualToView(self.contentView).leftSpaceToView(self.contentView,20).widthIs(40).heightIs(20);
        self.titleLab.sd_layout.centerYEqualToView(self.contentView).leftSpaceToView(self.topLab,10).rightSpaceToView(self.contentView,20).heightIs(25);
    }
    return self;
}

- (void)setModel:(NewestPostModel *)model {
    _model = model;
    
    self.titleLab.text = model.Title;
}

- (UILabel *)topLab {
    if (!_topLab) {
        _topLab = [UILabel new];
        _topLab.text = @"置顶";
        _topLab.font = [UIFont systemFontOfSize:12];
        _topLab.textAlignment = NSTextAlignmentCenter;
        _topLab.textColor = RGB(230, 79, 70);
        _topLab.layer.borderWidth = 1.0f;
        _topLab.layer.borderColor = RGB(230, 79, 70).CGColor;
    }
    return _topLab;
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.text = @"如果你无法简洁的表达你的想法,那只能说明你还不能完全表达你的诉求";
        _titleLab.font = [UIFont systemFontOfSize:14];
    }
    return _titleLab;
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
