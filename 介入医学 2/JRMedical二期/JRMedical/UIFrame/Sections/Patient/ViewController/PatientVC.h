//
//  PatientVC.h
//  JRMedical
//
//  Created by a on 16/11/4.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PassLearnArr)(NSMutableArray *, NSMutableArray *);

@interface PatientVC : UIViewController

@property (nonatomic, copy) PassLearnArr passLearnArr;

@end
