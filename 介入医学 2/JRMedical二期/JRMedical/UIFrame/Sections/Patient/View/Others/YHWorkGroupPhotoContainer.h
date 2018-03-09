//
//  YHWorkGroupPhotoContainer.h
//  HKPTimeLine  仿赤兔、微博动态
//  CSDN:  http://blog.csdn.net/samuelandkevin
//  Created by samuelandkevin on 16/9/20.
//  Copyright © 2016年 HKP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YHWorkGroupPhotoContainerDelegate <NSObject>

- (void)selectedVideoPushPostDetail:(NSString *)url;

@end

@interface YHWorkGroupPhotoContainer : UIView

@property (nonatomic, assign) id <YHWorkGroupPhotoContainerDelegate> delegate;//缩略图URL

@property (nonatomic, strong) NSArray *picUrlArray;//缩略图URL
@property (nonatomic, strong) NSArray *picOriArray;//原图url
@property (nonatomic, strong) NSArray *rTypeArray;//图片类型

@property (nonatomic, assign) NSInteger isReply;//是否是回帖

- (instancetype)initWithWidth:(CGFloat)width;
@end
