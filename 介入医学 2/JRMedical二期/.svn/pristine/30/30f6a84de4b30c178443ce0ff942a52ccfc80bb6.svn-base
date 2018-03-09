//
//  NewesPostFooterView.m
//  JRMedical
//
//  Created by a on 16/12/7.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "NewesPostFooterView.h"

@implementation NewesPostFooterView {
    
    NSInteger _curSection;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshPostListStateDianZhan" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshPostListStateCollection" object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addFooterView];//展示资讯状态的工具栏
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshPostListStateDianZhanClick:) name:@"RefreshPostListStateDianZhan" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshPostListStateCollectionClick:) name:@"RefreshPostListStateCollection" object:nil];
    }
    return self;
}

- (void)RefreshPostListStateDianZhanClick:(NSNotification *)sender {
    
    if (self.section == _curSection) {
        NSInteger isDZ = [sender.userInfo[@"isLike"] integerValue];
        
        UIButton *dzBtn = (UIButton *)[self viewWithTag:203];
        
        if (isDZ == 0) {
            [dzBtn setTitleColor:RGB(160, 160, 160) forState:(UIControlStateNormal)];
            [dzBtn setImage:[UIImage imageNamed:@"hengtianjinfuicon03"] forState:(UIControlStateNormal)];
        }
        else {
            [dzBtn setTitleColor:Main_Color forState:(UIControlStateNormal)];
            [dzBtn setImage:[UIImage imageNamed:@"dianzanlu"] forState:(UIControlStateNormal)];
        }
    }
}

- (void)RefreshPostListStateCollectionClick:(NSNotification *)sender {
    
    if (self.section == _curSection) {
        UIButton *scBtn = (UIButton *)[self viewWithTag:204];
        
        NSInteger isSC = [sender.userInfo[@"isCollection"] integerValue];
        
        if (isSC == 0) {
            [scBtn setTitleColor:RGB(160, 160, 160) forState:(UIControlStateNormal)];
            [scBtn setImage:[UIImage imageNamed:@"shoucang_gray"] forState:(UIControlStateNormal)];
        }
        else {
            [scBtn setTitleColor:Main_Color forState:(UIControlStateNormal)];
            [scBtn setImage:[UIImage imageNamed:@"shoucangyy"] forState:(UIControlStateNormal)];
        }
    }
}

- (void)setSection:(NSInteger)section {
    _section = section;
}

- (void)setModel:(NewestPostModel *)model {
    _model = model;
    
//    UIButton *fxBtn = (UIButton *)[self viewWithTag:201];
//    UIButton *plBtn = (UIButton *)[self viewWithTag:202];
    UIButton *dzBtn = (UIButton *)[self viewWithTag:203];
    UIButton *scBtn = (UIButton *)[self viewWithTag:204];
    
    if (model.IsLike == 0) {
        [dzBtn setTitleColor:RGB(160, 160, 160) forState:(UIControlStateNormal)];
        [dzBtn setImage:[UIImage imageNamed:@"hengtianjinfuicon03"] forState:(UIControlStateNormal)];
    }
    else {
        [dzBtn setTitleColor:Main_Color forState:(UIControlStateNormal)];
        [dzBtn setImage:[UIImage imageNamed:@"dianzanlu"] forState:(UIControlStateNormal)];
    }
    
    if (model.IsCollection == 0) {
        [scBtn setTitleColor:RGB(160, 160, 160) forState:(UIControlStateNormal)];
        [scBtn setImage:[UIImage imageNamed:@"shoucang_gray"] forState:(UIControlStateNormal)];
    }
    else {
        [scBtn setTitleColor:Main_Color forState:(UIControlStateNormal)];
        [scBtn setImage:[UIImage imageNamed:@"shoucangyy"] forState:(UIControlStateNormal)];
    }
//
//    [fxBtn setTitle:[NSString stringWithFormat:@" %ld ",model.ShareCount] forState:(UIControlStateNormal)];
//    
//    [plBtn setTitle:[NSString stringWithFormat:@" %ld ",model.ReplyCount] forState:(UIControlStateNormal)];
//    
//    [dzBtn setTitle:[NSString stringWithFormat:@" %ld ",model.LikedCount] forState:(UIControlStateNormal)];
//    
//    [scBtn setTitle:[NSString stringWithFormat:@" %ld ",model.CollectionCount] forState:(UIControlStateNormal)];
}

#pragma mark - 添加工具栏
- (void)addFooterView {
    
    NSArray *tagArr = @[@201, @202, @203, @204];
    NSArray *titleArr = @[@" 分享 ", @" 评论 ", @" 点赞 ", @" 收藏 "];
    NSArray *imageArr = @[@"fenxiang-1", @"groupcopy5", @"hengtianjinfuicon03", @"shoucang_gray"];
    
    for (int i = 0; i < titleArr.count; i++) {
        
        UIView *itemView = [[UIView alloc] initWithFrame:(CGRectMake(Width_Screen/4 * i, 0, Width_Screen/4, 40))];
        UIButton *item = [self makeACustomView:tagArr[i] title:titleArr[i] image:imageArr[i]];
        [itemView addSubview:item];
        
        UILabel *lineLab = [[UILabel alloc] initWithFrame:(CGRectMake(Width_Screen/4-1, 15, 1, 10))];
        lineLab.backgroundColor = [UIColor lightGrayColor];
        lineLab.alpha = 0.6;
        
        if (i < 3) {
            [itemView addSubview:lineLab];
        }
        
        [self.endView addSubview:itemView];
    }
    
    [self addSubview:self.endView];
}

// 自定义方法
- (UIButton *)makeACustomView:(NSNumber *)tag title:(NSString *)name image:(NSString *)picName {
    
    UIButton *button = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, Width_Screen/4-1, 40))];
    [button setTitle:name forState:(UIControlStateNormal)];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    button.tag = tag.integerValue;
    [button addTarget:self action:@selector(handleToolbar:) forControlEvents:(UIControlEventTouchUpInside)];
    [button setTitleColor:RGB(160, 160, 160) forState:(UIControlStateNormal)];
    [button setImage:[UIImage imageNamed:picName] forState:(UIControlStateNormal)];
    
    return button;
}

#pragma mark - 工具栏Action 响应事件
- (void)handleToolbar:(UIButton *)sender {

//    201: // 评论 202:// 点赞 203: // 收藏  204:  // 分享
    
    _curSection = self.section;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectPostStateClick:curSection:)]) {
        [self.delegate selectPostStateClick:sender.tag curSection:self.section];
    }
}


#pragma mark - 懒加载
- (UIView *)endView {
    if (!_endView) {
        self.endView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, Width_Screen, 40))];
        _endView.backgroundColor = [UIColor whiteColor];
    }
    return _endView;
}

@end
