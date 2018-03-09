//
//  FamousHosViewController.m
//  JRMedical
//
//  Created by ww on 16/11/15.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "FamousHosViewController.h"
#import "JSDropDownMenu.h"
#import "FamousHospitalCell.h"
#import "HospitalExpertModel.h"
#import "HosLevelModel.h"
#import "FamousHosModel.h"
#import "UITableView+EmpayData.h"
#import "FamousDoctorVC.h"

@interface FamousHosViewController ()<UITableViewDelegate, UITableViewDataSource, JSDropDownMenuDataSource,JSDropDownMenuDelegate, UISearchBarDelegate>

{
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    
    JSDropDownMenu *menu;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *navSearchBar;
@property (nonatomic, copy) NSString *shengID;
@property (nonatomic, copy) NSString *levelID;

@end

@implementation FamousHosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setTableView];
    
    [self addDaoHang];
}

- (void)setTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, Width_Screen, Height_Screen-104) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"FamousHospitalCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
}

#pragma mark 搜索
- (void)initNavSearchBar {
    
    self.navSearchBar = [[UISearchBar alloc]initWithFrame:(CGRectMake(50, 0, Width_Screen - 60, 44))];
    
    self.navSearchBar.delegate = self;
    
    self.navSearchBar.placeholder = @"搜索医院";
    
    [self.navigationController.navigationBar addSubview:self.navSearchBar];
    
}

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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    NSLog(@"点击了搜索按钮");
    [self requestListDataArrray];
    
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

- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    
    return 2;
}

-(BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    
    return NO;
}

-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
    
    if (column==1) {
        return YES;
    }
    return NO;
}

-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    
    if (column==1) {
        return 0.3;
    }
    
    return 1;
}
// 返回当前菜单左边表选中行
-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
    
    if (column==0) {
        
        return _currentData1Index;
        
    }
    if (column==1) {
        
        return _currentData2Index;
    }
    
    return 0;
}
// 每列的显示个数
- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    
    if (column==1) {
        
        if (leftOrRight==0) {
            return self.areaArray.count;
            
        } else {
            HospitalExpertModel *model = [self.areaArray objectAtIndex:leftRow];
            return model.Citys.count;
            
        }
        
    } else if (column==0){
        return self.levelArray.count;
        
    }
    
    return 0;
}

// 返回每列的默认名字
- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    switch (column) {
        case 1:
        {
            HospitalExpertModel *model = [self.areaArray objectAtIndex:0];
            NSDictionary *city = [model.Citys objectAtIndex:0];
            self.shengID = [city objectForKey:@"Id"];
            [self requestListDataArrray]; // 列表默认全部等级下的河南医院
            return [city objectForKey:@"Name"];
        }
            break;
        case 0:
        {
            HosLevelModel *model = self.levelArray[0];
            self.levelID = model.Name;
            return model.Name;
        }
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column==1) {

        HospitalExpertModel *model = [[HospitalExpertModel alloc]init];
        
        if (indexPath.leftOrRight==0) { // 左边表
            
            model = [self.areaArray objectAtIndex:indexPath.row];
            return model.AreaName;
            
        }
        else { // 右边表
            
            NSInteger leftRow = indexPath.row;
            HospitalExpertModel *model = [self.areaArray objectAtIndex:_currentData2Index];
            NSDictionary *city = [model.Citys objectAtIndex:leftRow];
            return [city objectForKey:@"Name"];
            
        }
        
    } else {
        
        HosLevelModel *model = self.levelArray[indexPath.row];
        return model.Name;
        
    }
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column == 1) {
        
        if(indexPath.leftOrRight== 0){ // 左边
            _currentData2Index = indexPath.row;
        }
        else {
            
            NSInteger leftRow = indexPath.row;
            HospitalExpertModel *model = [self.areaArray objectAtIndex:_currentData2Index];
            NSDictionary *city = [model.Citys objectAtIndex:leftRow];
            self.shengID = [city objectForKey:@"Id"];
            [self requestListDataArrray];
            
        }
        
    } else if(indexPath.column == 0){
        
        _currentData1Index = indexPath.row;
        HosLevelModel *model = self.levelArray[indexPath.row];
        self.levelID = model.Name;
        [self requestListDataArrray];
        
    }
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.dataSource == nil) {
        [tableView tableViewDisplayWitMsg:@"" ifNecessaryForRowCount:self.dataSource.count];
    }
    else {
        [tableView tableViewDisplayWitMsg:@"暂无相关信息!" ifNecessaryForRowCount:self.dataSource.count];
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FamousHospitalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    FamousHosModel *model = self.dataSource[indexPath.row];
    
    [cell setFamousHospitalCellWithModel:model];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FamousHosModel *model = self.dataSource[indexPath.row];
    FamousDoctorVC *doctorVC = [[FamousDoctorVC alloc] init];
    doctorVC.HospitalID = model.HospitalID;
    doctorVC.hosPic = model.Pic;
    doctorVC.title = model.HospitalName;
    [self.navigationController pushViewController:doctorVC animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}

#pragma mark - 请求数据列表
- (void)requestListDataArrray {
    
    NSString *searchStr = [[NSString alloc] init];
    BOOL isNull = [Utils isBlankString:_navSearchBar.text];
    if (isNull) {
        searchStr = @"";
        NSLog(@"空的 - %@", _navSearchBar.text);
    }else {
        NSLog(@"不是空的 - %@", _navSearchBar.text);
        searchStr = _navSearchBar.text;
    }
    
    NSString *url = @"api/Customer/HospitalList";
    NSString *params = [NSString stringWithFormat:@"ZICBDYCArea=%@ZICBDYCCLevel=%@ZICBDYCKey=%@", self.shengID, self.levelID, searchStr];
    
    self.pageSize = 8;//一次加载8条数据
    self.tableType = 1;//TableView表类
    self.baseTableView = self.tableView;//将本类表 赋值给父类去操作
    [self showLoadding:@"" time:20];
    [self loadDataApi:url withParams:params refresh:RefreshTypeBoth model:FamousHosModel.class];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
