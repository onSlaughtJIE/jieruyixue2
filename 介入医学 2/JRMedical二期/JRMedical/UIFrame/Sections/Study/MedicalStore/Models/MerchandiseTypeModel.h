//
//  MerchandiseTypeModel.h
//  JRMedical
//
//  Created by a on 16/12/5.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MerchandiseTypeModel : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *GroupID;//分组ID
@property (nonatomic, copy) NSString *GroupCode;//分组编码
@property (nonatomic, copy) NSString *Name;//名称
@property (nonatomic, copy) NSString *Value;//值，用于回传给后台
@property (nonatomic, copy) NSString *ImageUri;//图标路径

@end
