//
//  GroupSearchModel.h
//  JRMedical
//
//  Created by ww on 2016/12/23.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupSearchModel : NSObject
@property (nonatomic, strong) NSString *GroupName;
@property (nonatomic, strong) NSString *GroupID;
@property (nonatomic, strong) NSString *Pic;
@property (nonatomic, strong) NSString *Remark;
@property (nonatomic, strong) NSString *Maxusers;
@property (nonatomic, assign) NSInteger GroupCategory; // 0 官方群 1学术群 2社会群
@end
