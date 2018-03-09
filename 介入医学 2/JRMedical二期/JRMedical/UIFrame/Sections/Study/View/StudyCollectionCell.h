//
//  StudyCollectionCell.h
//  JRMedical
//
//  Created by ww on 16/11/12.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudyCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *withConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConst;

@end
