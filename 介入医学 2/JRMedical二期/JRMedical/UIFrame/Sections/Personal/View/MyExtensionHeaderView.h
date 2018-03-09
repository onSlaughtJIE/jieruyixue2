//
//  MyExtensionHeaderView.h
//  JRMedical
//
//  Created by a on 16/12/21.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyExtensionHeaderView : UIView

@property (nonatomic, strong) NSDictionary *dataDic;

@property (nonatomic, strong) UIImageView *codeImg;
@property (nonatomic, strong) UILabel *codeLab;
@property (nonatomic, strong) UILabel *codeNumLab;

- (instancetype)initWithFrame:(CGRect)frame;

@end
