//
//  MyExtensionHeaderView.m
//  JRMedical
//
//  Created by a on 16/12/21.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "MyExtensionHeaderView.h"

@implementation MyExtensionHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = Main_Color;
        
        [self setViewAutolayout];
    }
    return self;
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    self.codeImg.image = [self generateQRCode:dataDic[@"ShareUri"]];
    
    if (dataDic[@"GeneralizeCount"] == nil) {
        self.codeNumLab.text = @"推广人数 : 0 人";
    }
    else {
        self.codeNumLab.text = [NSString stringWithFormat:@"推广人数 : %@ 人",dataDic[@"GeneralizeCount"]];
    }
}

#pragma mark - 设置自动布局
- (void)setViewAutolayout {
    
    [self addSubview:self.codeImg];
    [self addSubview:self.codeLab];
    [self addSubview:self.codeNumLab];
    
    self.codeImg.sd_layout.topSpaceToView(self,20).centerXEqualToView(self).heightIs(100).widthIs(100);
    self.codeLab.sd_layout.centerXEqualToView(self).topSpaceToView(self.codeImg,10).heightIs(14).leftSpaceToView(self,15).rightSpaceToView(self,15);
    self.codeNumLab.sd_layout.centerXEqualToView(self).topSpaceToView(self.codeLab,15).heightIs(16).leftSpaceToView(self,15).rightSpaceToView(self,15);
}

#pragma mark - 生成二维码
- (UIImage *)generateQRCode:(NSString *)urlStr {
    
    // 生成二维码图片
    CIImage *qrcodeImage;
    NSData *data = [urlStr dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    qrcodeImage = [filter outputImage];
    
    // 消除模糊
    CGFloat scaleX = 200 / qrcodeImage.extent.size.width; // extent 返回图片的frame
    CGFloat scaleY = 200 / qrcodeImage.extent.size.height;
    
    CIImage *transformedImage = [qrcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:transformedImage];
}

#pragma mark - 懒加载
- (UIImageView *)codeImg {
    if (!_codeImg) {
        _codeImg = [UIImageView new];
        _codeImg.userInteractionEnabled = YES;
        _codeImg.clipsToBounds = YES;
        _codeImg.contentMode = UIViewContentModeScaleAspectFill;
        _codeImg.layer.cornerRadius = 5;
    }
    return _codeImg;
}
- (UILabel *)codeLab {
    if (!_codeLab) {
        _codeLab = [UILabel new];
        _codeLab.text = @"我的推广二维码";
        _codeLab.textColor = [UIColor whiteColor];
        _codeLab.font = [UIFont systemFontOfSize:14];
        _codeLab.textAlignment = NSTextAlignmentCenter;
    }
    return _codeLab;
}
- (UILabel *)codeNumLab {
    if (!_codeNumLab) {
        _codeNumLab = [UILabel new];
        _codeNumLab.text = @"推广人数 : 0人";
        _codeNumLab.textColor = [UIColor whiteColor];
        _codeNumLab.font = [UIFont boldSystemFontOfSize:16];
        _codeNumLab.textAlignment = NSTextAlignmentCenter;
        _codeNumLab.userInteractionEnabled = YES;
    }
    return _codeNumLab;
}

@end
