//
//  NewesPostFooterView.h
//  JRMedical
//
//  Created by a on 16/12/7.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewestPostModel.h"

@protocol NewesPostFooterViewDelegate <NSObject>

- (void)selectPostStateClick:(NSInteger)tag curSection:(NSInteger)section;

@end

@interface NewesPostFooterView : UIView

@property (nonatomic, assign) id<NewesPostFooterViewDelegate> delegate;

@property (nonatomic, assign) NSInteger section;

@property (nonatomic, strong) UIView *endView;

@property (nonatomic, strong) NewestPostModel *model;

@end
