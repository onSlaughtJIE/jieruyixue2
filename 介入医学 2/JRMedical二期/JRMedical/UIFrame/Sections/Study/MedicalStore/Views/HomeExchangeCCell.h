//
//  HomeExchangeCCell.h
//  JRMedical
//
//  Created by a on 16/12/5.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeLimitGoodView.h"

@protocol HomeExchangeCCellDelegate <NSObject>

- (void)selectExchangeView:(NSInteger)typeTag;

@end

@interface HomeExchangeCCell : UICollectionViewCell

@property (nonatomic, assign) id<HomeExchangeCCellDelegate>delegate;

@property (nonatomic, strong) NSMutableArray *modelAry;
@property (nonatomic, strong) UIScrollView *horizonScroll;
@property (nonatomic, strong) TimeLimitGoodView *goodView;

@end
