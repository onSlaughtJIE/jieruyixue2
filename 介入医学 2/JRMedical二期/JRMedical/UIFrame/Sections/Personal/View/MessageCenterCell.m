//
//  MessageCenterCell.m
//  JRMedical
//
//  Created by a on 16/12/21.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "MessageCenterCell.h"

@implementation MessageCenterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCellView];
    }
    return self;
}

-(void)setModel:(MessageCenterModel *)model {
    _model = model;
    
    self.titleLab.text = model.NoticeContent;
    self.timeLab.text = model.CreTime;
}

- (void)initCellView {
    
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.timeLab];
    
    self.titleLab.sd_layout.topSpaceToView(self.contentView,10).leftSpaceToView(self.contentView,10).rightSpaceToView(self.contentView,10).heightIs(38);
    self.timeLab.sd_layout.bottomSpaceToView(self.contentView,10).leftSpaceToView(self.contentView,10).rightSpaceToView(self.contentView,10).heightIs(12);
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:14];
        _titleLab.numberOfLines = 0;
    }
    return _titleLab;
}
- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [UILabel new];
        _timeLab.font = [UIFont systemFontOfSize:12];
        _timeLab.textColor = [UIColor lightGrayColor];
    }
    return _timeLab;
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
