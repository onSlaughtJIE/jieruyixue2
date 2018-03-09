//
//  ExpertDataCell.h
//  JRMedical
//
//  Created by a on 16/12/26.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpertDataCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *DataDic;

@property (weak, nonatomic) IBOutlet UIView *fenShiView;
@property (weak, nonatomic) IBOutlet UIView *fuWuView;
@property (weak, nonatomic) IBOutlet UIView *xinYView;

@property (weak, nonatomic) IBOutlet UILabel *fenShiNum;
@property (weak, nonatomic) IBOutlet UILabel *fuWuNum;
@property (weak, nonatomic) IBOutlet UILabel *xinYiNum;

@property (weak, nonatomic) IBOutlet UILabel *fenShiLab;
@property (weak, nonatomic) IBOutlet UILabel *fuWuLab;
@property (weak, nonatomic) IBOutlet UILabel *xinYiLab;

@end
