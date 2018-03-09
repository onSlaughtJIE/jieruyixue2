/************************************************************
  *  * Hyphenate CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2016 Hyphenate Inc. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of Hyphenate Inc.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from Hyphenate Inc.
  */

#import "EMRemarkImageView.h"

#import "UIImageView+HeadImage.h"

@implementation EMRemarkImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _editing = NO;
        
        CGFloat vMargin = frame.size.height / 6;
       
        CGFloat hMargin = vMargin / 2;
        
        
//        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(hMargin, vMargin, frame.size.width - vMargin, frame.size.height - vMargin)];
//        _imageView.clipsToBounds = YES;
//        _imageView.layer.cornerRadius = 5;
//        [self addSubview:_imageView];
        _newimagev = [[UIImageView alloc]initWithFrame:CGRectMake(hMargin, vMargin, frame.size.width - vMargin, frame.size.height - vMargin)];
//        _newimagev.backgroundColor = [UIColor redColor];
        _newimagev.clipsToBounds = YES;
        _newimagev.layer.cornerRadius = 5;
//        _newimagev.userInteractionEnabled = YES;

        
        [self addSubview:_newimagev];
        
        
        CGFloat rHeight = _newimagev.frame.size.height / 3;
        _remarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_newimagev.frame) - rHeight, _newimagev.frame.size.width, rHeight)];
        _remarkLabel.autoresizesSubviews = UIViewAutoresizingFlexibleTopMargin;
        _remarkLabel.clipsToBounds = YES;
        _remarkLabel.numberOfLines = 0;
        _remarkLabel.textAlignment = NSTextAlignmentCenter;
        _remarkLabel.font = [UIFont systemFontOfSize:10.0];
        _remarkLabel.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
        _remarkLabel.textColor = [UIColor whiteColor];
        [_newimagev addSubview:_remarkLabel];
    }
    return self;
}



- (void)setRemark:(NSString *)remark
{
    _remark = remark;
    [_remarkLabel setTextWithUsername:_remark];
    [_imageView imageWithUsername:remark placeholderImage:nil];
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    _imageView.image = image;
}

@end
