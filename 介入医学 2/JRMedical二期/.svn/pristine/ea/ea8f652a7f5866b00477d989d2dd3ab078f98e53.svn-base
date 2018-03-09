//
//  NewsDetailView.m
//  JRMedical
//
//  Created by a on 16/12/8.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "NewsDetailView.h"
#import "LWImageBrowser.h"

#define Img_Weight (Width_Screen-20)/4*3//一个图片的宽度
#define Img_Height ((Width_Screen-20)/4*3)/3*2//一个图片的高度

@implementation NewsDetailView

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

- (void)setModel:(NewestPostModel *)model {
    _model = model;
    
    if (model.IsRole) {
        self.isRenZhengImg.hidden = NO;
    }
    else {
        self.isRenZhengImg.hidden = YES;
    }
    
    //固态高度值    135.6
    //动态高度值为  内容 和 图片
    
    [self.headerPhoto sd_setImageWithURL:[NSURL URLWithString:model.CreUserPic] placeholderImage:[UIImage imageNamed:@"mtou"]];
    self.nameLab.text = model.CUserName;
    self.timeLab.text = model.CTime;
    self.xingHaoLab.text = model.EvaluateDevice;
    self.titleLab.text = model.Title;
    self.contantLab.text = model.Content;
    
    CGSize timeWidth = [Utils sizeForTitle:self.timeLab.text withFont:[UIFont systemFontOfSize:12]];
    CGRect contantWidth = [Utils getTextRectWithString:self.contantLab.text withWidth:Width_Screen-20 withFontSize:16];
    
    self.timeLab.sd_resetLayout.topSpaceToView(self.nameLab,10).leftSpaceToView(self.headerPhoto,10).widthIs(timeWidth.width).heightIs(12);
    self.contantLab.sd_resetLayout.topSpaceToView(self.lineView,10).leftSpaceToView(self,10).rightSpaceToView(self,10).heightIs(contantWidth.size.height);

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
            
            videoPlayWebView.sd_layout.topSpaceToView(self.contantLab,10+(10+Img_Height)*i).centerXEqualToView(self).widthIs(Img_Weight).heightIs(Img_Height);
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
            
            image.sd_layout.topSpaceToView(self.contantLab,videoHeight+(10+Img_Height)*i).centerXEqualToView(self).widthIs(Img_Weight).heightIs(Img_Height);
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
    
    [self addSubview:self.headerPhoto];
    [self addSubview:self.isRenZhengImg];
    [self addSubview:self.nameLab];
    [self addSubview:self.timeLab];
    [self addSubview:self.laiYuanLab];
    [self addSubview:self.xingHaoLab];
    [self addSubview:self.titleLab];
    [self addSubview:self.lineView];
    [self addSubview:self.contantLab];
    [self addSubview:self.botLineView];
    
    self.headerPhoto.sd_layout.topSpaceToView(self,10).leftSpaceToView(self,10).widthIs(54).heightIs(54);
    self.isRenZhengImg.sd_layout.bottomEqualToView(self.headerPhoto).leftSpaceToView(self.headerPhoto,-15).heightIs(12).widthIs(12);
    self.nameLab.sd_layout.topSpaceToView(self,20).leftSpaceToView(self.headerPhoto,10).rightSpaceToView(self,10).heightIs(16);
    self.timeLab.sd_layout.topSpaceToView(self.nameLab,10).leftSpaceToView(self.headerPhoto,10).widthIs(50).heightIs(12);
    self.laiYuanLab.sd_layout.topSpaceToView(self.nameLab,10).leftSpaceToView(self.timeLab,10).widthIs(25).heightIs(12);
    self.xingHaoLab.sd_layout.topSpaceToView(self.nameLab,10).leftSpaceToView(self.laiYuanLab,2).rightSpaceToView(self,10).heightIs(12);
    self.titleLab.sd_layout.topSpaceToView(self.headerPhoto,10).leftSpaceToView(self,10).rightSpaceToView(self,10).heightIs(40);
    self.lineView.sd_layout.topSpaceToView(self.titleLab,5).leftSpaceToView(self,10).rightSpaceToView(self,10).heightIs(0.5);
    self.contantLab.sd_layout.topSpaceToView(self.lineView,5).leftSpaceToView(self,10).rightSpaceToView(self,10).heightIs(35);
    self.botLineView.sd_layout.bottomEqualToView(self).leftSpaceToView(self,0).rightSpaceToView(self,0).heightIs(0.85);
}

#pragma mark - 懒加载
- (UIImageView *)headerPhoto {
    if (!_headerPhoto) {
        _headerPhoto = [UIImageView new];
        _headerPhoto.backgroundColor = [UIColor whiteColor];
        _headerPhoto.image = [UIImage imageNamed:@"mtou"];
        _headerPhoto.userInteractionEnabled = YES;
        _headerPhoto.clipsToBounds = YES;
        _headerPhoto.contentMode = UIViewContentModeScaleAspectFill;
        _headerPhoto.layer.cornerRadius = 27;
    }
    return _headerPhoto;
}
- (UIImageView *)isRenZhengImg {
    if (!_isRenZhengImg) {
        _isRenZhengImg = [UIImageView new];
        _isRenZhengImg.image = [UIImage imageNamed:@"doctor-ren"];
    }
    return _isRenZhengImg;
}
- (UILabel *)nameLab {
    if (!_nameLab) {
        _nameLab = [UILabel new];
        _nameLab.font = [UIFont boldSystemFontOfSize:16];
        _nameLab.textColor = Main_Color;
    }
    return _nameLab;
}
- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [UILabel new];
        _timeLab.textColor = HuiText_Color;
        _timeLab.font = [UIFont systemFontOfSize:12];
    }
    return _timeLab;
}
- (UILabel *)laiYuanLab {
    if (!_laiYuanLab) {
        _laiYuanLab = [UILabel new];
        _laiYuanLab.textColor = HuiText_Color;
        _laiYuanLab.font = [UIFont systemFontOfSize:12];
        _laiYuanLab.text = @"来自";
    }
    return _laiYuanLab;
}
- (UILabel *)xingHaoLab {
    if (!_xingHaoLab) {
        _xingHaoLab = [UILabel new];
        _xingHaoLab.textColor = RGB(31, 188, 210);
        _xingHaoLab.font = [UIFont systemFontOfSize:12];
    }
    return _xingHaoLab;
}
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
- (UIView *)botLineView {
    if (!_botLineView) {
        _botLineView = [UIView new];
        _botLineView.backgroundColor = BG_Color;
    }
    return _botLineView;
}
- (UILabel *)contantLab {
    if (!_contantLab) {
        _contantLab = [UILabel new];
        _contantLab.font = [UIFont systemFontOfSize:16];
        _contantLab.numberOfLines = 0;
        _contantLab.textColor = RGB(120, 120, 120);
    }
    return _contantLab;
}

@end
