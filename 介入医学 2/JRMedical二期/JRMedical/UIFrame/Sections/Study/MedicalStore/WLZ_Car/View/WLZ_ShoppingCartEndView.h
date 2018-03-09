//
//  WLZ_ShoppingCartEndView.h
//  WLZ_ShoppingCart
//
//  Created by lijiarui on 15/12/15.
//  Copyright © 2015年 lijiarui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMButton.h"

@protocol WLZ_ShoppingCartEndViewDelegate <NSObject>

-(void)clickALLEnd:(UIButton *)bt;
-(void)clickRightBT:(UIButton *)bt;

@end

@interface WLZ_ShoppingCartEndView : UIView

@property(nonatomic,assign)BOOL isEdit;
@property(weak,nonatomic)id<WLZ_ShoppingCartEndViewDelegate> delegate;
@property(nonatomic,strong)UILabel *Lab;
@property(nonatomic,strong)KMButton *checkbt;

+(CGFloat)getViewHeight;

@end

