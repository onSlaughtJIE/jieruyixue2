//
//  EaseBarrageFlyView.m
//  UCloudMediaRecorderDemo
//
//  Created by EaseMob on 16/6/13.
//  Copyright © 2016年 zmw. All rights reserved.
//

#import "EaseBarrageFlyView.h"

#import "EaseTextAttachment.h"

#define kLabelDefaultWidth 125.f
#define kLabelDefaultHeight 25.f

@interface EaseBarrageFlyView ()
{
    EMMessage *_message;
}

@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UILabel *giftLabel;
@property(nonatomic,strong) UIImageView *headImageView;
@property(nonatomic,strong) UIView *bgView;

@end

@implementation EaseBarrageFlyView

-(instancetype)initWithMessage:(EMMessage*)messge
{
    self = [super init];
    if (self) {
        int flag = arc4random()%140;
        [self setFrame:CGRectMake(0, flag, 200, 80)];
        
        [self getUserNickNameWithEMID:messge.from];
        
        _message = messge;
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.headImageView];
        [self.bgView addSubview:self.nameLabel];
        [self.bgView addSubview:self.giftLabel];
        
        
    }
    return self;
}

- (UILabel*)nameLabel
{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headImageView.frame) + 5, 0, kLabelDefaultWidth, kLabelDefaultHeight)];
        if (_message) {
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:_message.from attributes:nil];
            NSDictionary *attributes = @{NSFontAttributeName :[UIFont systemFontOfSize:12.0f]};
            [string addAttributes:attributes range:NSMakeRange(0, string.length)];
            _nameLabel.attributedText = string;
            NSLog(@"弹幕 -- %@", string);
        }
        _nameLabel.textColor = [UIColor whiteColor];
    }
    return _nameLabel;
}


// 获取用户昵称
- (void)getUserNickNameWithEMID:(NSString *)EMID {
    
    NSString *urlS = [NSString stringWithFormat:@"%@/api/IM/GetCustomerInfoByID", Server_Int_Url];
    NSString *dataS = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCID=%@", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI, EMID, nil];
    NSString *dataEncrpyt = [TWDes encryptWithContent:dataS type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    NSDictionary *paraDic = @{kToken:token, kDatas:dataEncrpyt};
    
    [AFManegerHelp POST:urlS parameters:paraDic success:^(id responseObjeck) {
        NSLog(@"EaseChatView - live - GetCustomerInfoByID - %@", responseObjeck);
        if ([responseObjeck[@"Success"] integerValue] == 1) {
            
            NSArray *array = responseObjeck[@"JsonData"];
            NSDictionary *dic = array.firstObject;
            
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:dic[@"CustomerName"] attributes:nil];
            NSDictionary *attributes = @{NSFontAttributeName :[UIFont systemFontOfSize:12.0f]};
            [string addAttributes:attributes range:NSMakeRange(0, string.length)];
            _nameLabel.attributedText = string;
        }
        
    } failure:^(NSError *error) {
        NSLog(@"cuowu%@", error);
    }];
    
}

- (UILabel*)giftLabel
{
    if (_giftLabel == nil) {
        _giftLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headImageView.frame) + 5, CGRectGetMaxY(self.nameLabel.frame), kLabelDefaultWidth, kLabelDefaultHeight)];
        _giftLabel.textColor = [UIColor whiteColor];
        
        EMTextMessageBody *body = (EMTextMessageBody*)_message.body;
        _giftLabel.text = body.text;
        NSLog(@"%@",_message.ext);
        _giftLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _giftLabel;
}

- (UIView*)bgView
{
    if (_bgView == nil) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 200, 50)];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = CGRectGetHeight(_bgView.frame)/2;
        _bgView.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
    }
    return _bgView;
}

- (UIImageView*)headImageView
{
    if (_headImageView == nil) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetHeight(self.bgView.frame), CGRectGetHeight(self.bgView.frame))];
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = CGRectGetHeight(self.bgView.frame)/2;
        _headImageView.image = [UIImage imageNamed:@"live_default_user"];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headImageView;
}

- (void)animateInView:(UIView *)view
{
    CGRect frame = self.frame;
    frame.origin.x = CGRectGetMaxX(view.frame) + CGRectGetWidth(frame);
    self.frame = frame;
    
    self.alpha = 0;
    __weak typeof(self) weakSelf = self;
    
    dispatch_block_t animateStepOneBlock = ^{
        CGRect frame = weakSelf.frame;
        frame.origin.x = CGRectGetMaxX(view.frame)/2;
        weakSelf.frame = frame;
        weakSelf.alpha = 1;
    };
    
    dispatch_block_t animateStepTowBlock = ^{
        CGRect frame = weakSelf.frame;
        frame.origin.x = -CGRectGetWidth(frame);
        weakSelf.frame = frame;
        weakSelf.alpha = 0;
    };
    
    [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        animateStepOneBlock();
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            animateStepTowBlock();
        } completion:^(BOOL finished) {
            [weakSelf removeFromSuperview];
        }];
    }];
}





@end
