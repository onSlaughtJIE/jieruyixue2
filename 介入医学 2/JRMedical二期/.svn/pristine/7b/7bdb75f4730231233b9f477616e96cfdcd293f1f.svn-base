//
//  CaseLibraryDetailView.m
//  JRMedical
//
//  Created by a on 16/12/21.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "CaseLibraryDetailView.h"
#import "LWImageBrowser.h"

#define Img_Weight (Width_Screen-20)/4*3//一个图片的宽度
#define Img_Height ((Width_Screen-20)/4*3)/3*2//一个图片的高度

@implementation CaseLibraryDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self initJiChuAutoLayout];
    }
    return self;
}

- (void)setTUrlArray:(NSMutableArray *)tUrlArray {
    _tUrlArray = tUrlArray;
}

- (void)setHUrlArray:(NSMutableArray *)hUrlArray {
    _hUrlArray = hUrlArray;
}

- (void)setVideoUrlArray:(NSMutableArray *)videoUrlArray {
    _videoUrlArray = videoUrlArray;
}

- (void)setModel:(CaseLibraryModel *)model {
    _model = model;
    
    self.titleLab.text = model.CaseTitle;
    CGRect titleLabWidth = [Utils getTextRectWithString:self.titleLab.text withWidth:Width_Screen-20 withFontSize:16];
    
    self.titleLab.sd_resetLayout.topSpaceToView(self,20).leftSpaceToView(self,20).rightSpaceToView(self,20).heightIs(titleLabWidth.size.height);
    self.lineView.sd_resetLayout.topSpaceToView(self.titleLab,20).leftSpaceToView(self,10).rightSpaceToView(self,10).heightIs(0.5);

    if (self.videoUrlArray.count == 0 && self.hUrlArray.count == 0) {
        self.lineView.hidden = YES;
        
    }
    else {
        self.lineView.hidden = NO;
    }
    
    if (self.videoUrlArray.count != 0) {
        //视频
        for (int i = 0; i < self.videoUrlArray.count; i ++) {
            
            UIWebView *videoPlayWebView = [UIWebView new];
            videoPlayWebView.backgroundColor = [UIColor blackColor];
            videoPlayWebView.scrollView.scrollEnabled = NO;
            videoPlayWebView.delegate = self;
            [videoPlayWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.videoUrlArray[i]]]];
            videoPlayWebView.mediaPlaybackRequiresUserAction = YES;
            [self addSubview:videoPlayWebView];
            
            videoPlayWebView.sd_layout.topSpaceToView(self.lineView,10+(10+Img_Height)*i).centerXEqualToView(self).widthIs(Img_Weight).heightIs(Img_Height);
        }
    }
    
    NSInteger videoHeight = 10+(10+Img_Height)*self.videoUrlArray.count;
    
    if (self.hUrlArray.count != 0) {
        //图片
        for (int i = 0; i < self.hUrlArray.count; i ++) {
            
            UIImageView *image = [UIImageView new];
            [image sd_setImageWithURL:[NSURL URLWithString:self.hUrlArray[i]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
            image.tag = i;
            image.contentMode = UIViewContentModeScaleAspectFill;
            image.clipsToBounds = YES;
            image.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
            [image addGestureRecognizer:tap];
            [self addSubview:image];
            
            image.sd_layout.topSpaceToView(self.lineView,videoHeight+(10+Img_Height)*i).centerXEqualToView(self).widthIs(Img_Weight).heightIs(Img_Height);
        }
    }
}

#pragma mark - UIWebViewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    //防止调回视频对应的客户端
    NSString *urlStr = request.URL.absoluteString;
    if ([urlStr rangeOfString:@"sohuvideo:"].location != NSNotFound //拦截搜狐
        || [urlStr rangeOfString:@"action.cmd"].location != NSNotFound) {
        return NO;
    }
    else{
        return YES;
    }
}

- (void)tapImageView:(UITapGestureRecognizer *)tap
{
    
    UIView *imageView = tap.view;
    
    NSMutableArray* tmps = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.hUrlArray.count; i ++) {
        LWImageBrowserModel* model = [[LWImageBrowserModel alloc]
                                      initWithplaceholder:[UIImage imageNamed:@"jiazai"]
                                      thumbnailURL:[NSURL URLWithString:[self.hUrlArray objectAtIndex:i]]
                                      HDURL:[NSURL URLWithString:[self.hUrlArray objectAtIndex:i]]
                                      containerView:imageView
                                      positionInContainer:CGRectFromString(self.hUrlArray[i])
                                      index:i];
        [tmps addObject:model];
    }
    
    LWImageBrowser* browser = [[LWImageBrowser alloc] initWithImageBrowserModels:tmps
                                                                    currentIndex:imageView.tag];
    
    [browser show];
}

#pragma mark - 初始化基础视图
- (void)initJiChuAutoLayout {
    
    [self addSubview:self.titleLab];
    [self addSubview:self.lineView];
    
    self.titleLab.sd_layout.topSpaceToView(self,20).leftSpaceToView(self,20).rightSpaceToView(self,20).heightIs(40);
    self.lineView.sd_layout.topSpaceToView(self.titleLab,20).leftSpaceToView(self,10).rightSpaceToView(self,10).heightIs(0.5);
}

#pragma mark - 懒加载
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.textColor = RGB(120, 120, 120);
        _titleLab.numberOfLines = 0;
        _titleLab.font = [UIFont systemFontOfSize:16];
    }
    return _titleLab;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = RGB(220,220,220);
    }
    return _lineView;
}

@end
