//
//  YHWorkGroupPhotoContainer.m
//  HKPTimeLine  仿赤兔、微博动态
//  CSDN:  http://blog.csdn.net/samuelandkevin
//  Created by samuelandkevin on 16/9/20.
//  Copyright © 2016年 HKP. All rights reserved.
//

#import "YHWorkGroupPhotoContainer.h"
#import "LWImageBrowser.h"
#import <UIImageView+WebCache.h>

@interface YHWorkGroupPhotoContainer ()

@property (nonatomic, strong) NSArray *imageViewsArray;
@property (nonatomic, assign) CGFloat width;

@property (nonatomic, strong) NSMutableArray *tUrlArray;
@property (nonatomic, strong) NSMutableArray *hUrlArray;
@property (nonatomic, strong) NSMutableArray *videoUrlArray;

@end

@implementation YHWorkGroupPhotoContainer

- (instancetype)initWithWidth:(CGFloat)width{
    if (self = [super init]) {
        NSAssert(width>0, @"请设置图片容器的宽度");
        self.width = width;

        self.tUrlArray = [NSMutableArray arrayWithCapacity:0];
        self.hUrlArray = [NSMutableArray arrayWithCapacity:0];
        self.videoUrlArray = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    NSMutableArray *temp = [NSMutableArray new];
    
    for (int i = 0; i < 9; i++) {
        UIImageView *imageView = [UIImageView new];
        
        [self addSubview:imageView];
        
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tap];
        [temp addObject:imageView];
    }
    
    self.imageViewsArray = [temp copy];
}

- (void)setIsReply:(NSInteger)isReply {
    _isReply = isReply;
}

- (void)setPicOriArray:(NSArray *)picOriArray {
    _picOriArray = picOriArray;
}

- (void)setRTypeArray:(NSArray *)rTypeArray {
    _rTypeArray = rTypeArray;
    
    [self.tUrlArray removeAllObjects];
    [self.hUrlArray removeAllObjects];
    [self.videoUrlArray removeAllObjects];

    for (int i = 0; i < _rTypeArray.count; i ++) {
        
        NSString *tUrl = self.picUrlArray[i];
        NSString *hUrl = self.picOriArray[i];
        
        //将视频 和 图片 url  分离出来
        if ([_rTypeArray[i] integerValue] == 1) {
            [self.videoUrlArray addObject:hUrl];
        }
        else {
            [self.tUrlArray addObject:tUrl];
            [self.hUrlArray addObject:hUrl];
        }
    }
}

- (void)setPicUrlArray:(NSArray *)picUrlArray{
    _picUrlArray = picUrlArray;
    
    NSInteger num;
    if (_picUrlArray.count >= 9) {
        num = 9;
    }
    else {
        num = _picUrlArray.count;
    }
    
    for (long i = num; i < self.imageViewsArray.count; i++) {
        UIImageView *imageView = [self.imageViewsArray objectAtIndex:i];
        imageView.hidden = YES;
    }
    
    if (num == 0) {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        return;
    }
    
    CGFloat itemW = [self itemWidthForPicPathArray:_picUrlArray];
    
    CGFloat itemH;
    if (num == 1) {
        itemH = itemW/3*2;
    }
    else {
        itemH = itemW;
    }
    
    long perRowItemCount = [self perRowItemCountForPicPathArray:num];
    CGFloat margin = 5;
    
    for (int i = 0; i < num; i++) {
        
        NSURL *obj     =  _picUrlArray[i];
        long columnIndex = i % perRowItemCount;
        long rowIndex    = i / perRowItemCount;
        
        UIImageView *imageView = self.imageViewsArray[i];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.hidden = NO;
        [imageView sd_setImageWithURL:obj placeholderImage:[UIImage imageNamed:@"jiazai"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (image.size.width < itemW || image.size.height < itemW) {
                imageView.contentMode = UIViewContentModeScaleAspectFill;
            }
        }
         ];

        imageView.frame = CGRectMake(columnIndex * (itemW + margin), rowIndex * (itemH + margin), itemW, itemH);
    }
    
    int columnCount = ceilf(num * 1.0 / perRowItemCount);
    CGFloat h = columnCount * itemH + (columnCount - 1) * margin;
    

    [self mas_updateConstraints:^(MASConstraintMaker *make) {
         make.height.mas_equalTo(h);
        }
    ];

}

#pragma mark - private actions

- (void)tapImageView:(UITapGestureRecognizer *)tap
{
    
    UIView *imageView = tap.view;
    
    if ([self.rTypeArray[imageView.tag] integerValue] == 1) {
        
        if ([self.videoUrlArray[imageView.tag] isEqualToString:@""] || self.videoUrlArray[imageView.tag] == nil) {
            return;
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(selectedVideoPushPostDetail:)]) { //只有当代理存在，且timeTickOut方法被实现的时候才执行下面的语句
            [_delegate selectedVideoPushPostDetail:self.videoUrlArray[imageView.tag]];
        }
        
    }
    else {
        
        if (self.isReply == 3000) {//处理商品评价图片
            NSMutableArray* tmps = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < self.picOriArray.count; i ++) {
                LWImageBrowserModel* model = [[LWImageBrowserModel alloc]
                                              initWithplaceholder:[UIImage imageNamed:@"jiazai"]
                                              thumbnailURL:[NSURL URLWithString:[self.picOriArray objectAtIndex:i]]
                                              HDURL:[NSURL URLWithString:[self.picOriArray objectAtIndex:i]]
                                              containerView:imageView
                                              positionInContainer:CGRectFromString(self.picOriArray[i])
                                              index:i];
                [tmps addObject:model];
            }
            
            LWImageBrowser* browser = [[LWImageBrowser alloc] initWithImageBrowserModels:tmps
                                                                            currentIndex:imageView.tag];
            
            [browser show];
        }
        else {
            NSMutableArray* tmps = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < self.tUrlArray.count; i ++) {
                LWImageBrowserModel* model = [[LWImageBrowserModel alloc]
                                              initWithplaceholder:[UIImage imageNamed:@"jiazai"]
                                              thumbnailURL:[NSURL URLWithString:[self.tUrlArray objectAtIndex:i]]
                                              HDURL:[NSURL URLWithString:[self.hUrlArray objectAtIndex:i]]
                                              containerView:imageView
                                              positionInContainer:CGRectFromString(self.tUrlArray[i])
                                              index:i];
                [tmps addObject:model];
            }
            
            LWImageBrowser* browser = [[LWImageBrowser alloc] initWithImageBrowserModels:tmps
                                                                            currentIndex:imageView.tag-self.videoUrlArray.count];
            
            [browser show];
        }
    }
}

- (CGFloat)itemWidthForPicPathArray:(NSArray *)array
{
    if (array.count == 1) {
        if (self.isReply == 1000 || self.isReply == 3000) {
            return (Width_Screen-84)/4*3;
        }
        else {
            return (Width_Screen-20)/4*3;
        }
    } else {
        CGFloat itemW = (self.width -10) /3 ;
        return itemW;
    }
}

- (NSInteger)perRowItemCountForPicPathArray:(NSInteger )num
{
    if (num < 3) {
        return num;
    } else if (num == 4) {
        return 2;
    } else {
        return 3;
    }
}

@end
