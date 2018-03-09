//
//  XinxueViewController.h
//  JRMedical
//
//  Created by ww on 2017/1/16.
//  Copyright © 2017年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PassTypeArr)(NSMutableArray *, NSMutableArray *, NSMutableArray *, NSMutableArray *);

@interface XinxueViewController : UIViewController

@property (nonatomic, copy) NSString *TypeID;

@property (nonatomic, copy) PassTypeArr passTypeArr;

@end
