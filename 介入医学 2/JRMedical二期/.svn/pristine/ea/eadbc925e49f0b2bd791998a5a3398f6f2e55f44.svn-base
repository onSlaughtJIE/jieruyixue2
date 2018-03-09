//
//  GroupOrganizeModel.h
//  JRMedical
//
//  Created by ww on 2016/12/24.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Lstorderdetail;

@interface GroupOrganizeModel : NSObject

@property (nonatomic, copy) NSString *OrganizingTypeName; // 主席 / 副主席 ...
@property (nonatomic, assign) NSInteger OrganizingTypeID;
@property (nonatomic, strong) NSArray<Lstorderdetail *> *InfoList;

@end


@interface Lstorderdetail : NSObject

@property (nonatomic, copy) NSString *CustomerName; // 昵称
@property (nonatomic, copy) NSString *CustomerID;   // 环信id
@property (nonatomic, copy) NSString *Pic;          // 头像url

@end
