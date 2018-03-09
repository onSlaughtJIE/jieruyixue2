//
//  KeshiSelectCell.m
//  JRMedical
//
//  Created by apple on 16/7/14.
//  Copyright © 2016年 ZC. All rights reserved.
//

#import "KeshiSelectCell.h"
#import "LeanCollectionModel.h"
#import <YYKit.h>

@interface KeshiSelectCell ()

@end

@implementation KeshiSelectCell

- (void)setValueWithLeanModel:(LeanCollectionModel *)model {
    
    [self.typeImageView setImageURL:[NSURL URLWithString:model.ImageUri]];
    self.typeLabel.text = model.Name;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
