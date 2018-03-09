//
//  StudyCellOne.m
//  JRMedical
//
//  Created by ww on 16/11/12.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "StudyCellOne.h"
#import "ZWVerticalAlignLabel.h"

@interface StudyCellOne ()
@property (weak, nonatomic) IBOutlet ZWVerticalAlignLabel *title;

@end

@implementation StudyCellOne

- (void)setModel:(PublicNewsListModel *)model {
    _model = model;
    
    self.biaoTiLab.text = model.BiaoTi;
    self.laiYuanLab.text = model.LaiYuan;
    self.timeLab.text = model.Time;
    [self.Img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.TuPian1]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
    
    if (model.NewTop) {
        self.ZhiDingImg.hidden = NO;
    }else {
        self.ZhiDingImg.hidden = YES;
    }
    
    //是否是最热
    if (model.IsHot) {
        self.isHotImg.hidden = NO;
        self.zhiDing.constant = 16;
    }
    else {
        self.isHotImg.hidden = YES;
        self.zhiDing.constant = 3;
    }
    
    //评论条数
    if (model.PingJiaJiLu < 1000) {
        self.pingLunLab.text = [NSString stringWithFormat:@"%.0f评论",model.PingJiaJiLu];
    }
    else if (model.PingJiaJiLu >= 10000){
        self.pingLunLab.text = [NSString stringWithFormat:@"%.1f万评论",model.PingJiaJiLu/10000];
    }
    else {
        self.pingLunLab.text = [NSString stringWithFormat:@"%.1f千评论",model.PingJiaJiLu/1000];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.ZhiDingImg.clipsToBounds = YES;
    self.ZhiDingImg.layer.cornerRadius = 2;
    self.ZhiDingImg.textColor = RGB(230, 79, 70);
    self.ZhiDingImg.layer.borderWidth = .6f;
    self.ZhiDingImg.hidden = YES;
    self.ZhiDingImg.layer.borderColor = RGB(230, 79, 70).CGColor;
    
    [self.title textAlign:^(ZWMaker *make) {
        make.addAlignType(textAlignType_top);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
