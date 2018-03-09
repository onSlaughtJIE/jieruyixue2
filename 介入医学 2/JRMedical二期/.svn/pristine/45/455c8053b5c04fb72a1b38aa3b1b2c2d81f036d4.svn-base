//
//  HosEndController.m
//  JRMedical
//
//  Created by apple on 16/7/19.
//  Copyright © 2016年 ZC. All rights reserved.
//

#import "HosEndController.h"
#import "RenZhengHospitalModel.h"
#import "HosShuruViewController.h"
#import "MyCertificationVC.h"
#import "MedicineRegistrationVC.h"

#import "UITableView+EmpayData.h"
#import <YYKit.h>

@interface HosEndController ()

@end

@implementation HosEndController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"医院列表";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"手动输入" style:(UIBarButtonItemStylePlain) target:self action:@selector(shuru)];
    
    
    [self loadHos];
    
}

- (void)shuru {
    
    
    HosShuruViewController *vc = [[HosShuruViewController alloc] init];
    
    vc.AreaID = _AreaID;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.dataSource == nil) {
        [tableView tableViewDisplayWitMsg:@"" ifNecessaryForRowCount:self.dataSource.count];
    }
    else {
        [tableView tableViewDisplayWitMsg:@"该地区暂无医院信息!" ifNecessaryForRowCount:self.dataSource.count];
    }
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    RenZhengHospitalModel *model = self.dataSource[indexPath.row];
    
    cell.textLabel.text = model.Name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RenZhengHospitalModel *hosModel = self.dataSource[indexPath.row];
   
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setObject:hosModel.Name forKey:@"hosName"];
    [dic setObject:hosModel.ID  forKey:@"hosID"];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"passHos" object:nil userInfo:dic];
    
    NSArray * ctrlArray = self.navigationController.viewControllers;
    
//    NSLog(@"ctrlArray ---  %@", ctrlArray);
    
    NSInteger renzhengNum = 0;
    
    int i = 0;
    
    for (UIViewController *controller in ctrlArray) {
        
//        NSLog(@"controller.nibName - %@", controller.nibName);
        
        if ([controller.className isEqualToString:@"MyCertificationVC"]) {
            
            renzhengNum = i;
        }
        else if ([controller.className isEqualToString:@"MedicineRegistrationVC"]) {
            renzhengNum = i;
        }
        
        i++;
        
    }
    
    [self.navigationController popToViewController:[ctrlArray objectAtIndex:renzhengNum] animated:YES];
}


- (void)loadHos {
    
    NSString *url = @"api/Hospital/SearchList";
    NSString *params = [NSString stringWithFormat:@"ZICBDYCArea=%@ZICBDYCKey=%@",self.AreaID, @""];
    self.pageSize = 50;
    [self showLoadding:@"正在加载" time:20];
    [self loadDataApi:url withParams:params refresh:RefreshTypeNone model:RenZhengHospitalModel.class];
}

@end
