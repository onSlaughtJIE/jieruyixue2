//
//  CaseLibraryDetailView.h
//  JRMedical
//
//  Created by a on 16/12/21.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaseLibraryModel.h"

@interface CaseLibraryDetailView : UIView<UIWebViewDelegate>

@property (nonatomic, strong) CaseLibraryModel *model;

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) NSMutableArray *tUrlArray;
@property (nonatomic, strong) NSMutableArray *hUrlArray;
@property (nonatomic, strong) NSMutableArray *videoUrlArray;

@end
