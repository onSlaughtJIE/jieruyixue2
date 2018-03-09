//
//  AddressViewController.m
//  AddressDemo
//
//  Created by 张武星 on 15/5/29.
//  Copyright (c) 2015年 worthy.zhang. All rights reserved.
//

#import "AddressViewController.h"

@interface AddressViewController ()
@property(nonatomic,strong)NSIndexPath *selectedIndexPath;//当前选中的NSIndexPath
@end

@implementation AddressViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];//改变状态栏颜色
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];//改变状态栏颜色
}


-(void)viewDidLoad{
    [self configureData];
    [self configureViews];
    
}

-(void)configureData{
    if (self.displayType == kDisplayProvince) {
        //从文件读取地址字典
        NSString *addressPath = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"plist"];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithContentsOfFile:addressPath];
        self.provinces = [dict objectForKey:@"address"];
    }
}

-(void)configureViews{
    if (self.displayType == kDisplayProvince) { //只在选择省份页面显示取消按钮
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    }
    else {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    }
    
    if (self.displayType == kDisplayArea) {//只在选择区域页面显示确定按钮
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(submit)];
    }
    
    CGRect frame = [self.view bounds];
    self.tableView = [[UITableView alloc]initWithFrame:frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.displayType == kDisplayProvince) {
        return self.provinces.count;
    }else if (self.displayType == kDisplayCity){
        return self.citys.count;
    }else{
        return self.areas.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* ID = @"cityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        if (self.displayType == kDisplayArea) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    if (self.displayType == kDisplayProvince) {
        NSDictionary *province = self.provinces[indexPath.row];
        NSString *provinceName = [province objectForKey:@"name"];
        cell.textLabel.text= provinceName;
    }else if (self.displayType == kDisplayCity){
        NSDictionary *city = self.citys[indexPath.row];
        NSString *cityName = [city objectForKey:@"name"];
        cell.textLabel.text= cityName;
    }else{
        cell.textLabel.text= self.areas[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:@"unchecked"];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.displayType == kDisplayProvince) {
        NSDictionary *province = self.provinces[indexPath.row];
        NSArray *citys = [province objectForKey:@"sub"];
        self.selectedProvince = [province objectForKey:@"name"];
        //构建下一级视图控制器
        AddressViewController *cityVC = [[AddressViewController alloc]init];
        cityVC.displayType = kDisplayCity;//显示模式为城市
        cityVC.citys = citys;
        cityVC.selectedProvince = self.selectedProvince;
        cityVC.title = self.selectedProvince;
        [self.navigationController pushViewController:cityVC animated:YES];
    }else if (self.displayType == kDisplayCity){
        NSDictionary *city = self.citys[indexPath.row];
        self.selectedCity = [city objectForKey:@"name"];
        NSArray *areas = [city objectForKey:@"sub"];
        //构建下一级视图控制器
        AddressViewController *areaVC = [[AddressViewController alloc]init];
        areaVC.displayType = kDisplayArea;//显示模式为区域
        areaVC.areas = areas;
        areaVC.selectedCity = self.selectedCity;
        areaVC.selectedProvince = self.selectedProvince;

        if ([self.selectedProvince isEqualToString:self.selectedCity]) {
            areaVC.title = [NSString stringWithFormat:@"%@",self.selectedCity];
        }
        else {
           areaVC.title = [NSString stringWithFormat:@"%@%@",self.selectedProvince,self.selectedCity];
        }
        
        [self.navigationController pushViewController:areaVC animated:YES];
    }
    else{
        //取消上一次选定状态
        UITableViewCell *oldCell =  [tableView cellForRowAtIndexPath:self.selectedIndexPath];
        oldCell.imageView.image = [UIImage imageNamed:@"unchecked"];
        //勾选当前选定状态
        UITableViewCell *newCell =  [tableView cellForRowAtIndexPath:indexPath];
        newCell.imageView.image = [UIImage imageNamed:@"checked"];
        //保存
        self.selectedArea = self.areas[indexPath.row];
        self.selectedIndexPath = indexPath;
    }
    
}
-(void)submit{
    
    if ([self.selectedArea isEqualToString:@""] || self.selectedArea == nil) {
        return [self showHint:@"请选择一个地区"];
    }
    
    NSMutableDictionary *allInfoDic = [[NSMutableDictionary alloc] init];
    
    [allInfoDic setObject:self.selectedProvince forKey:@"ProvinceAddress"];
    [allInfoDic setObject:self.selectedCity forKey:@"CityAddress"];
    [allInfoDic setObject:self.selectedArea forKey:@"AreaAddress"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectAddressNotification" object:nil userInfo:allInfoDic];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)cancel {
    if (self.displayType != kDisplayProvince) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
