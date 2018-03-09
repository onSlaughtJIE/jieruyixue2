//
//  PatientAskModel.h
//  JRMedical
//
//  Created by apple on 16/6/28.
//  Copyright © 2016年 ZC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PatientAskModel : NSObject


@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *ReplyContent;

@property (nonatomic, copy) NSString *ReplyTime;

@property (nonatomic, copy) NSString *QuestionContent;

@property (nonatomic, copy) NSString *QuestionTime;


@end
