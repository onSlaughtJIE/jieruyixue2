//
//  PicOrVideoModel.h
//  JRMedical
//
//  Created by apple on 16/7/5.
//  Copyright © 2016年 ZC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PicOrVideoModel : NSObject

@property(nonatomic,strong)NSData *contentData;
@property(nonatomic,strong)NSString *contentName;
@property(nonatomic,strong)NSString *passKey;
@property(nonatomic,strong)NSString *passType;

@end
