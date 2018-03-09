//
//  LearnRelevantNewsCell.m
//  JRMedical
//
//  Created by a on 16/11/29.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "LearnRelevantNewsCell.h"

@implementation LearnRelevantNewsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = BG_Color;
        
        [self initCellView];
    }
    return self;
}

- (void)setModel:(PublicNewsListModel *)model {
    _model = model;
    
    self.titleMessage.text = model.BiaoTi;
}

- (void)setArrayNum:(NSInteger)arrayNum {
    _arrayNum = arrayNum;
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    
    if (self.arrayNum == 1) {
        self.yinYingView.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0).heightIs(3);
        self.lineView2.hidden = YES;
        self.lineView.hidden = YES;
        self.topYinYingView.sd_layout.bottomSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0).heightIs(3);
    }
    else {
        if (indexPath.row == 0) {
            self.yinYingView.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0).heightIs(3);
        }
        else if (indexPath.row == (self.arrayNum-1)) {
            
            self.lineView2.hidden = YES;
            self.lineView.hidden = YES;
            
            self.topYinYingView.sd_layout.bottomSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0).heightIs(3);
        }
    }
}

#pragma mark - 初始化视图
- (void)initCellView {

    [self.contentView addSubview:self.leftImg];
    [self.contentView addSubview:self.titleMessage];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.lineView2];
    [self.contentView addSubview:self.yinYingView];
    [self.contentView addSubview:self.topYinYingView];

    self.leftImg.sd_layout.leftSpaceToView(self.contentView,15).centerYEqualToView(self.contentView).widthIs(7).heightIs(12);
    self.titleMessage.sd_layout.leftSpaceToView(self.leftImg,15).centerYEqualToView(self.contentView).rightSpaceToView(self.contentView,15).heightIs(14);
    self.lineView.sd_layout.bottomSpaceToView(self.contentView,1).leftSpaceToView(self.contentView,10).rightSpaceToView(self.contentView,10).heightIs(1);
    self.lineView2.sd_layout.bottomSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,10).rightSpaceToView(self.contentView,10).heightIs(1);
}

#pragma mark - 懒加载
- (UIImageView *)leftImg {
    if (!_leftImg) {
        _leftImg = [UIImageView new];
        _leftImg.image = [UIImage imageNamed:@"right"];
    }
    return _leftImg;
}
- (UILabel *)titleMessage {
    if (!_titleMessage) {
        _titleMessage = [UILabel new];
        _titleMessage.font = [UIFont systemFontOfSize:14];
    }
    return _titleMessage;
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
- (UIView *)yinYingView {
    if (!_yinYingView) {
        _yinYingView = [UIView new];
        _yinYingView.backgroundColor = [UIColor whiteColor];
        _yinYingView.layer.shadowColor = RGB(40, 40, 40).CGColor;//阴影颜色
        _yinYingView.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
        _yinYingView.layer.shadowOpacity = 0.8;//不透明度
        _yinYingView.layer.shadowRadius = 4.0;//半径
    }
    return _yinYingView;
}
- (UIView *)topYinYingView {
    if (!_topYinYingView) {
        _topYinYingView = [UIView new];
        _topYinYingView.backgroundColor = [UIColor whiteColor];
        _topYinYingView.layer.shadowColor = RGB(40, 40, 40).CGColor;//阴影颜色
        _topYinYingView.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
        _topYinYingView.layer.shadowOpacity = 0.8;//不透明度
        _topYinYingView.layer.shadowRadius = 4.0;//半径
    }
    return _topYinYingView;
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
