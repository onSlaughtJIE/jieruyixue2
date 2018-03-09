//
//  ImageShowCollectCell.m
//  JRMedical
//
//  Created by apple on 16/7/25.
//  Copyright © 2016年 ZC. All rights reserved.
//

#import "ImageShowCollectCell.h"
#import "imageShowCollectModel.h"

@interface ImageShowCollectCell ()

@end

@implementation ImageShowCollectCell


- (void)setDataForSubViewWithModel:(imageShowCollectModel *)model {
    
    [self.picView sd_setImageWithURL:[NSURL URLWithString:model.WebSiteUri] placeholderImage:[UIImage imageNamed:@"jiazai"]];
//    self.picDeleteBtn.tag = [model.picNum integerValue];
    
    if ([model.type isEqualToString:@"pic"]) {
        self.boImageView.hidden = YES;
    } else {
        self.boImageView.hidden = NO;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
