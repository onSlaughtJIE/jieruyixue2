//
//  ImageShowCollectCell.h
//  JRMedical
//
//  Created by apple on 16/7/25.
//  Copyright © 2016年 ZC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class imageShowCollectModel;

@interface ImageShowCollectCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *picView;
@property (weak, nonatomic) IBOutlet UIButton *picDeleteBtn;
@property (weak, nonatomic) IBOutlet UIImageView *boImageView;


- (void)setDataForSubViewWithModel:(imageShowCollectModel *)model;

@end
