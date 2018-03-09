//
//  FindExpertController.m
//  JRMedical
//
//  Created by apple on 16/5/24.
//  Copyright © 2016年 ZC. All rights reserved.
//

#import "FindExpertController.h"
#import "JSDropDownMenu.h"
#import "MyAttentionCell.h"
#import "ExpertDetailsVC.h"

#import "KeShiModel.h"
#import "BingZhongModel.h"
#import "HospitalExpertModel.h"
#import "MyAttentionModel.h"

#import "UITableView+EmpayData.h"

@interface FindExpertController ()<UITableViewDataSource, UITableViewDelegate, JSDropDownMenuDataSource,JSDropDownMenuDelegate, UISearchBarDelegate>
{
    
    NSMutableArray *_data1;
    NSMutableArray *_data2;
    NSMutableArray *_data3;
    
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    NSInteger _currentData3Index;

    JSDropDownMenu *menu;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSString *shengID;
@property (nonatomic, copy) NSString *keShiID;
@property (nonatomic, copy) NSString *jieRuID;

@property (nonatomic, strong) UISearchBar *navSearchBar;

@end

@implementation FindExpertController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 添加nav
    [self initNavSearchBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navSearchBar removeFromSuperview];
    self.navSearchBar = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addDaoHang];
    
    [self.view addSubview:self.tableView];
}

#pragma mark 搜索
- (void)initNavSearchBar {
    self.navSearchBar = [[UISearchBar alloc]initWithFrame:(CGRectMake(50, 0, Width_Screen - 60, 44))];
    self.navSearchBar.delegate = self;
    self.navSearchBar.placeholder = @"搜索专家";
    [self.navigationController.navigationBar addSubview:self.navSearchBar];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"点击了搜索按钮");
    
    
    if ([_navSearchBar.text isEqualToString:@""] || _navSearchBar.text == nil) {
        return [self showMessage:@"请输入要搜索的内容"];
    }
    
    NSString *url = @"api/Customer/SearchList";
    NSString *params = [NSString stringWithFormat:@"ZICBDYCArea=%@ZICBDYCKs=%@ZICBDYCBz=%@ZICBDYCKey=%@", self.shengID, self.keShiID, self.jieRuID, _navSearchBar.text];
    
    self.pageSize = 10;//一次加载8条数据
    self.tableType = 1;//TableView表类
    self.baseTableView = self.tableView;//将本类表 赋值给父类去操作
    [self showLoadding:@"" time:20];
    [self loadDataApi:url withParams:params refresh:RefreshTypeBoth model:MyAttentionModel.class];
    
    [_navSearchBar resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [_navSearchBar resignFirstResponder];
}

- (void)addDaoHang {
    
    menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:45];
    menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    menu.dataSource = self;
    menu.delegate = self;
    
    [self.view addSubview:menu];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 45, Width_Screen, Height_Screen - 64 - 45) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = BG_Color;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 80, 0, 0);
        [_tableView registerClass:[MyAttentionCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}


#pragma mark tableivew代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSource == nil) {
        [tableView tableViewDisplayWitMsg:@"" ifNecessaryForRowCount:self.dataSource.count];
    }
    else {
        [tableView tableViewDisplayWitMsg:@"暂无相关专家信息!" ifNecessaryForRowCount:self.dataSource.count];
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyAttentionModel *model = self.dataSource[indexPath.row];
    MyAttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell setModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 78;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MyAttentionModel *model = self.dataSource[indexPath.row];
    ExpertDetailsVC *edVC = [ExpertDetailsVC new];
    edVC.title = model.CustomerName;
    edVC.model = model;
    [self.navigationController pushViewController:edVC animated:YES];
}

#pragma mark - JSDropDownMenuDelegate
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    return 3;
}

-(BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    
    if (column==2) {
        
        return YES;
    }
    
    return NO;
}

-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
    
    if (column==0) {
        return YES;
    }
    return NO;
}

-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    
    if (column==0) {
        return 0.3;
    }
    
    return 1;
}

-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
    
    if (column==0) {
        
        return _currentData1Index;
        
    }
    if (column==1) {
        
        return _currentData2Index;
    }
    
    return 0;
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    
    if (column==0) {
        
        if (leftOrRight==0) {
            
            if (self.areaArray.count == 0) {
                return 0;
            }
            return self.areaArray.count;
        
        }
        else {
        
            HospitalExpertModel *model = [self.areaArray objectAtIndex:leftRow];
            return model.Citys.count;
        
        }
        
    }
    else if (column==1){
        
        return self.keshiArray.count;
        
    }
    else if (column==2){
        
        return self.bingzhongArray.count;
        
    }
    
    return 0;
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    switch (column) {
        case 0:
        {
            HospitalExpertModel *model = [self.areaArray objectAtIndex:0];
            NSDictionary *city = [model.Citys objectAtIndex:0];
            self.shengID = [city objectForKey:@"Id"];
            //            [self addTabData];
            return [city objectForKey:@"Name"];
        }
            break;
        case 1:
        {
            KeShiModel *model = [self.keshiArray objectAtIndex:0];
            self.keShiID = model.Value;
            //            [self addTabData];
            return model.Name;
        }
            break;
        case 2:
        {
            BingZhongModel *mocel = [self.bingzhongArray objectAtIndex:0];
            self.jieRuID = mocel.Value;
            [self requestListDataArrray];
            return mocel.Name;
            
        }
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    // 地区
    if (indexPath.column==0) {
        
        HospitalExpertModel *model = [[HospitalExpertModel alloc]init];
       
        if (indexPath.leftOrRight==0) { // 左边表
        
            model = [self.areaArray objectAtIndex:indexPath.row];
            return model.AreaName;
        
        }
        else { // 右边表
        
            NSInteger leftRow = indexPath.row;
            HospitalExpertModel *model = [self.areaArray objectAtIndex:_currentData1Index];
            NSDictionary *city = [model.Citys objectAtIndex:leftRow];
            return [city objectForKey:@"Name"];
        
        }
        
    }
    else if (indexPath.column==1) {
    
        KeShiModel *model = self.keshiArray[indexPath.row];
        return model.Name;
        
    }
    else {
    
        BingZhongModel *mocel = self.bingzhongArray[indexPath.row];
        return mocel.Name;
        
    }
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column == 0) {
        if(indexPath.leftOrRight== 0){ // 左边
            _currentData1Index = indexPath.row;
        }
        else {
            
            NSInteger leftRow = indexPath.row;
            HospitalExpertModel *model = [self.areaArray objectAtIndex:_currentData1Index];
            NSDictionary *city = [model.Citys objectAtIndex:leftRow];
            self.shengID = [city objectForKey:@"Id"];
            [self requestListDataArrray];
        
        }
    }
    else if(indexPath.column == 1){
        _currentData2Index = indexPath.row;
        KeShiModel *model = self.keshiArray[indexPath.row];
        self.keShiID = model.Value;
        
        [self isSelectShengID];
        
        [self requestListDataArrray];
        
        
    } else{
        
        _currentData3Index = indexPath.row;
        BingZhongModel *model = self.bingzhongArray[indexPath.row];
        self.jieRuID = model.Value;
        
        [self isSelectShengID];
        
        [self requestListDataArrray];
        
    }
    
}

- (void)isSelectShengID {
    
    if ([self.shengID integerValue] > 0 ) {
        //        NSLog(@"省份Id - %@", self.shengID);
    }
    else {
        [self showMessage:@"请先选择地区"];
        return;
    }
}

#pragma mark - 请求数据列表
- (void)requestListDataArrray {
    NSString *url = @"api/Customer/SearchList";
    NSString *params = [NSString stringWithFormat:@"ZICBDYCArea=%@ZICBDYCKs=%@ZICBDYCBz=%@ZICBDYCKey=%@", self.shengID, self.keShiID, self.jieRuID, @""];
    
    self.pageSize = 10;//一次加载8条数据
    self.tableType = 1;//TableView表类
    self.baseTableView = self.tableView;//将本类表 赋值给父类去操作
    [self showLoadding:@"" time:20];
    [self loadDataApi:url withParams:params refresh:RefreshTypeBoth model:MyAttentionModel.class];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
