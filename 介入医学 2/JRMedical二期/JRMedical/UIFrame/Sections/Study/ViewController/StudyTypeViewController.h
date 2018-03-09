//
//  StudyTypeViewController.h
//  JRMedical
//
//  Created by ww on 16/11/12.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PassLearnArr)(NSMutableArray *, NSMutableArray *, NSMutableArray *, NSMutableArray *);

@interface StudyTypeViewController : UIViewController

@property (nonatomic, copy) PassLearnArr passLearnArr;

@end
