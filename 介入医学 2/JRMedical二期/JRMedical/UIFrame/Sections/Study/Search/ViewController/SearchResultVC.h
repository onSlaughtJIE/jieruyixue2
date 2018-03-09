//
//  SearchResultVC.h
//  JRMedical
//
//  Created by a on 16/11/25.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "BaseTableViewController.h"

@interface SearchResultVC : BaseTableViewController

@property (nonatomic, copy) NSString *searchKeyWord;
@property (nonatomic, copy) NSString *groupCode;
@property (nonatomic, copy) NSString *searchType;

@end
