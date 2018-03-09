//
//  BottomCollectionViewCell.h
//  JRMedical
//
//  Created by ww on 16/11/15.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerchandiseListModel.h"

@protocol MedicalExchangeCellDelegate <NSObject>

- (void)selectRowDelectClick:(NSIndexPath *)indexPath;

@end

@interface BottomCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, assign) id<MedicalExchangeCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *pictureImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
//@property (weak, nonatomic) IBOutlet UIImageView *ubImg;
//@property (weak, nonatomic) IBOutlet UILabel *priceUB;


@property (nonatomic, strong) MerchandiseListModel *model;

@end
