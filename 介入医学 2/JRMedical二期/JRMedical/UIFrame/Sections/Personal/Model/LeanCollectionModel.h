//
//  LeanCollectionModel.h
//  JRMedical
//
//  Created by apple on 16/4/25.
//  Copyright © 2016年 ZC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LeanCollectionModel : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *GroupID;
@property (nonatomic, copy) NSString *GroupCode;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *Value;
@property (nonatomic, copy) NSString *ImageUri;
@property (nonatomic, copy) NSString *CheckedImage;

@property (nonatomic, assign) NSInteger Type;

@end
