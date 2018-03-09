//
//  WLZ_ShoppingCartEndView.m
//  WLZ_ShoppingCart
//
//  Created by lijiarui on 15/12/15.
//  Copyright © 2015年 lijiarui. All rights reserved.
//

#import "WLZ_ShoppingCartEndView.h"

#import "WLZ_ShoppingCarController.h"
#import "UIColor+WLZ_HexRGB.h"

@interface WLZ_ShoppingCartEndView ()

@property(nonatomic,strong)UIButton *deleteBt;
@property(nonatomic,strong)KMButton *pushBt;

@end

static CGFloat VIEW_HEIGHT = 44;

@implementation WLZ_ShoppingCartEndView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addObserver:self forKeyPath:@"isEdit" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        [self initView];
    }
    return self;
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"isEdit"]) {
        
        if (self.isEdit) {
            self.Lab.hidden=YES;
            self.deleteBt.hidden=NO;
            self.pushBt.hidden=YES;
        }
        else
        {
            self.Lab.hidden=NO;
            self.deleteBt.hidden=YES;
            self.pushBt.hidden=NO;
        }
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"isEdit"];
}

-(void)initView
{
    [self addSubview:self.checkbt];
    [self addSubview:self.Lab];
    [self addSubview:self.pushBt];
    [self addSubview:self.deleteBt];
    
    self.checkbt.sd_layout.centerYEqualToView(self).leftSpaceToView(self,15).widthIs(80).heightIs(35);
    self.pushBt.sd_layout.centerYEqualToView(self).rightEqualToView(self).widthIs(120).heightIs(44);
    self.deleteBt.sd_layout.centerYEqualToView(self).rightEqualToView(self).widthIs(120).heightIs(44);
    self.Lab.sd_layout.centerYEqualToView(self).leftSpaceToView(self.checkbt,10).rightSpaceToView(self.pushBt,10).heightIs(14);
}

-(void)clickRightBT:(UIButton *)bt {
    [self.delegate clickRightBT:bt];
}

-(void)clickAllEnd:(UIButton *)bt {
    [self.delegate clickALLEnd:bt];
}

- (void)setIsEdit:(BOOL)isEdit {
    _isEdit = isEdit;
}

#pragma mark - 懒加载
- (KMButton *)pushBt {
    if (!_pushBt) {
        _pushBt = [KMButton buttonWithType:UIButtonTypeCustom];
        _pushBt.spacing = 5;
        _pushBt.margin = 30;
        _pushBt.kMButtonType = KMButtonLeft;
        _pushBt.backgroundColor = RGB(232, 78, 64);
        [_pushBt setImage:[UIImage imageNamed:@"qiandaijiesuan"] forState:UIControlStateNormal];
        [_pushBt setTitle:@"去结算" forState:UIControlStateNormal];
        _pushBt.titleLabel.font = [UIFont systemFontOfSize:14];
        _pushBt.hidden = NO;
        _pushBt.tag = 18;
        [_pushBt addTarget:self action:@selector(clickRightBT:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pushBt;
}
- (UIButton *)deleteBt {
    if (!_deleteBt) {
        _deleteBt = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBt.titleLabel.font = [UIFont systemFontOfSize:14];
        [_deleteBt setTitle:@"删除" forState:UIControlStateNormal];
        _deleteBt.backgroundColor = RGB(232, 78, 64);
        _deleteBt.hidden = YES;
        _deleteBt.tag = 19;
        [_deleteBt addTarget:self action:@selector(clickRightBT:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBt;
}
- (KMButton *)checkbt {
    if (!_checkbt) {
        _checkbt = [KMButton buttonWithType:UIButtonTypeCustom];
        _checkbt.spacing = 5;
        _checkbt.margin = 1;
        _checkbt.kMButtonType = KMButtonLeft;
        [_checkbt setImage:[UIImage imageNamed:@"weixuan"] forState:UIControlStateNormal];
        [_checkbt setImage:[UIImage imageNamed:@"duidui"] forState:UIControlStateSelected];
        [_checkbt setTitle:@"全选" forState:UIControlStateNormal];
        [_checkbt setTitle:@"取消全选" forState:UIControlStateSelected];
        [_checkbt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _checkbt.titleLabel.font = [UIFont systemFontOfSize:14];
        _checkbt.selected = YES;
        [_checkbt addTarget:self action:@selector(clickAllEnd:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkbt;
}
- (UILabel *)Lab {
    if (!_Lab) {
        _Lab = [UILabel new];
        _Lab.text = @"合计:";
        _Lab.font = [UIFont systemFontOfSize:14];
        _Lab.textAlignment = NSTextAlignmentCenter;
    }
    return _Lab;
}

+ (CGFloat)getViewHeight {
    return VIEW_HEIGHT;
}

@end
