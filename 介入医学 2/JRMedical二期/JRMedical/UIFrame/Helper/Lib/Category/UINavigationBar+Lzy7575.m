//
//  UINavigationBar+Lzy7575.m
//  liuzhiyuan
//
//  Created by a on 16/11/3.
//  Copyright © 2016年 刘志远. All rights reserved.
//

#import "UINavigationBar+Lzy7575.h"

@implementation UINavigationBar (Lzy7575)

#pragma mark - 获取底边分隔线
@dynamic hairline_7575;
- (UIImageView *)hairline_7575 {
    NSArray * arr = self.subviews;
    
    for (UIView *uv in arr) {
        
        if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0)
        {//10.0的系统字段不一样
            UIView *view = (UIView*)uv;
            for (id obj2 in view.subviews) {
                if ([obj2 isKindOfClass:[UIImageView class]])
                {
                    UIImageView *image =  (UIImageView*)obj2;
                    image.hidden = YES;
                }
            }
        }
        else {
            if([uv isMemberOfClass:NSClassFromString(@"_UINavigationBarBackground")]){
                NSArray * arr2 = uv.subviews;
                
                for (UIView * uv_BG in arr2) {
                    if([uv_BG isMemberOfClass:[UIImageView class]]){
                        return (UIImageView *)uv_BG;
                    }
                }
            }
        }
    }
    
    return nil;
}

#pragma mark - 导航栏自定义背景
- (UIView *)overlayKey_7575 {
    return objc_getAssociatedObject(self, @selector(setOverlayKey_7575:));
}
- (void)setOverlayKey_7575:(UIView *)newValue {
    objc_setAssociatedObject(self, @selector(setOverlayKey_7575:), newValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - 导航栏背景色
@dynamic backGroundColor_7575;
- (void)setBackGroundColor_7575:(UIColor *)newValue {
    if (!self.overlayKey_7575) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.overlayKey_7575 = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(self.bounds) + 20)];
        self.overlayKey_7575.userInteractionEnabled = NO;
        self.overlayKey_7575.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self insertSubview:self.overlayKey_7575 atIndex:0];
    }
    
    self.overlayKey_7575.backgroundColor = newValue;
}

#pragma mark - 导航栏偏移
@dynamic translationY_7575;
- (void)setTranslationY_7575:(CGFloat)newValue {
    self.transform = CGAffineTransformMakeTranslation(0, newValue);
}

#pragma mark - 导航栏子控件透明度
@dynamic elementsAlpha_7575;
- (void)setElementsAlpha_7575:(CGFloat)newValue {
    [[self valueForKey:@"_leftViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
        view.alpha = newValue;
    }];
    
    [[self valueForKey:@"_rightViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
        view.alpha = newValue;
    }];
    
    UIView *titleView = [self valueForKey:@"_titleView"];
    titleView.alpha = newValue;
    
    [[self subviews] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UINavigationItemView")]) {
            obj.alpha = newValue;
            *stop = YES;
        }
    }];
}

#pragma mark - 重置导航栏
- (void)reset_7575 {
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.overlayKey_7575 removeFromSuperview];
    self.overlayKey_7575 = nil;
}

@end
