//
//  KMButton.m
//  Bus
//
//  Created by Rookie on 15/9/9.
//  Copyright (c) 2015年 河南省863软件孵化器有限公司  com.863soft.gjx. All rights reserved.
//

#import "KMButton.h"

@interface KMButton ()
@property (nonatomic, assign) CGRect imageOriginalFrame;
@property (nonatomic, assign) CGRect titleOriginalFrame;
@end

@implementation KMButton

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(void)layoutSubviews {
    [super layoutSubviews];
    
    if(_margin == 0){
        _margin = 10;
    }
    
    //    self.titleLabel.backgroundColor = KMRC;
    //    self.imageView.backgroundColor = KMRC;
    
    CGFloat pWidth = self.imageView.superview.frame.size.width;
    CGFloat startX = (pWidth - self.imageView.frame.size.width - self.titleLabel.frame.size.width - _spacing)/2;
    
    CGRect imageFrame = self.imageView.frame;
    CGRect titleFrame = self.titleLabel.frame;
    
    if(self.kMButtonType == KMButtonLeft){
        startX = _margin;
        titleFrame.origin.x = startX + self.imageView.frame.size.width + _spacing;
        imageFrame.origin.x = startX;
        
    }else if(self.kMButtonType == KMButtonLeftInvert){
        startX = _margin;
        imageFrame.origin.x = startX + self.titleLabel.frame.size.width + _spacing;
        titleFrame.origin.x = startX;
        
    }else if(self.kMButtonType == KMButtonRight){
        startX = pWidth -self.titleLabel.frame.size.width - self.imageView.frame.size.width - _spacing - _margin;
        imageFrame.origin.x = startX + self.titleLabel.frame.size.width + _spacing;
        titleFrame.origin.x = startX;
        
    }else if(self.kMButtonType == KMButtonRightInvert){
        startX = pWidth -self.titleLabel.frame.size.width - self.imageView.frame.size.width - _spacing - _margin;
        titleFrame.origin.x = startX + self.imageView.frame.size.width + _spacing;
        imageFrame.origin.x = startX;
        
    }else if(self.kMButtonType == KMButtonCenter){
        
        CGFloat pWidth = self.imageView.superview.frame.size.width;
        CGFloat pHeight = self.imageView.superview.frame.size.height;
        CGFloat startY = (pHeight - self.imageView.frame.size.height - self.titleLabel.frame.size.height - _spacing)/2;
        
        
        imageFrame.origin.y = startY;
        titleFrame.origin.y = startY + self.imageView.frame.size.height + _spacing;
        
        imageFrame.origin.x = (pWidth - self.imageView.frame.size.width) / 2;
        titleFrame.origin.x = 5;
        titleFrame.size.width = pWidth - 10;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        
    }else if (self.kMButtonType == KMButtonCenterInvert){
        CGFloat pWidth = self.imageView.superview.frame.size.width;
        CGFloat pHeight = self.imageView.superview.frame.size.height;
        CGFloat startY = (pHeight - self.imageView.frame.size.height - self.titleLabel.frame.size.height - _spacing)/2;
        
        
        titleFrame.origin.y = startY;
        imageFrame.origin.y = startY + self.titleLabel.frame.size.height + _spacing;
        
        imageFrame.origin.x = (pWidth - self.imageView.frame.size.width) / 2;
        titleFrame.origin.x = 5;
        
        titleFrame.size.width = pWidth - 10;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        
    }else if(self.kMButtonType == KMButtonCenterLeft){
        
        titleFrame.origin.x = startX + self.imageView.frame.size.width + _spacing;
        imageFrame.origin.x = startX;
        
    }else if(self.kMButtonType == KMButtonCenterRight){
        
        imageFrame.origin.x = startX + self.titleLabel.frame.size.width + _spacing;
        titleFrame.origin.x = startX;
        
    }
    self.imageView.frame = imageFrame;
    self.titleLabel.frame = titleFrame;
}


@end
