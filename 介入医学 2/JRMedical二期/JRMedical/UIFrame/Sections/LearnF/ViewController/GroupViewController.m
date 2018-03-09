//
//  GroupViewController.m
//  JRMedical
//
//  Created by ww on 2016/12/13.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "GroupViewController.h"
#import "UITableView+EmpayData.h"
#import "GroupTypeView.h"
#import "GroupTableViewCell.h"
#import "GroupApplyJoinController.h"

#import "GuanFangTypeModel.h"
#import "GroupModel.h"
#import "SheHuiModel.h"

#import "CreateGroupViewController.h"
#import "PublicGroupListViewController.h"
#import "ChatViewController.h"
#import "EMSearchBar.h"
#import "PublicGroupDetailViewController.h"
#import "RealtimeSearchUtil.h"
#import "GroupSearchViewController.h"
#import "JRLoginViewController.h"

@interface GroupViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _currentGroupType; // 当前选中的群类型(官方群0, 社会群1, 学术群2, 默认官方群0)
    EMGroup *_group;
    NSInteger _page;
}

@property (nonatomic, strong) UIView *topSearchBGView;
@property (nonatomic, strong) UIView *topSearchView;
@property (nonatomic, strong) UIImageView *searchImg;
@property (nonatomic, strong) UILabel *textLab;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) GroupTypeView *groupTypeView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableDictionary *dataDic;    // 所有个分区的子内容
@property (nonatomic, strong) NSMutableArray *stateArray;   // 每个分区的闭合状态
@property (nonatomic, strong) NSMutableArray *sectionArray; // 区头分类

@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BG_Color;
    
    [self setTopSearchView];//设置顶部 搜索 视图
    [self addTopView];// 官方群/社会群/技术群
    [self.view addSubview:self.tableView];
    [self initDataSource];
    
    NSLog(@"_currentGroupType - %ld", _currentGroupType);
    
    [self setRefresh];
    
}

/**
 *  初始化数组
 */
- (void)initDataSource
{
    self.dataDic = [NSMutableDictionary dictionary];
    self.stateArray = [NSMutableArray array];
    self.sectionArray = [NSMutableArray array];
    
    [self getGuanFangGroupType];// 获取官方群分类
    
//    _sectionArray  = [NSMutableArray arrayWithObjects:@"北京",@"上海",@"广州",@"河南",nil];
//    
//    NSArray *one = @[@"工程狮"];
//    NSArray *two = @[@"管理层"];
//    NSArray *three = @[@"服务员"];
//    NSArray *four = @[@"证券分析师"];
//
//    _dataArray = [NSMutableArray arrayWithObjects:one,two,three,four,nil];
//    _stateArray = [NSMutableArray array];
//    
//    for (int i = 0; i < _dataArray.count; i++)
//    {
//        //所有的分区都是闭合
//        [_stateArray addObject:@"0"];
//    }
}


- (void)addTopView {
    
    self.topView = [[UIView alloc] initWithFrame:(CGRectMake(0, 50, Width_Screen, 80))];
    _topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_topView];
    
    NSArray *nameArr = @[@"官方群", @"社会群", @"学术群"];
    NSArray *imageArr = @[@"guanfangrenzhengq", @"qunq", @"yishengmenq"];
    for (int i = 0 ; i < 3; i++) {
        self.groupTypeView = [[GroupTypeView alloc] initWithFrame:(CGRectMake(i*Width_Screen/3, 0, Width_Screen/3, 80))];
        self.groupTypeView.tag = i+100;
        self.groupTypeView.titleLab.text = nameArr[i];
        self.groupTypeView.imageView.image = [UIImage imageNamed:imageArr[i]];
        [self.groupTypeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGroup:)]];
        [_topView addSubview:self.groupTypeView];
        if (i == 0) {
            self.groupTypeView.backgroundColor = BG_Color;
        }
    }

    
}

- (void)tapGroup:(UITapGestureRecognizer *)sender {

    NSInteger tag = sender.view.tag;
    for (GroupTypeView *view in self.topView.subviews) {
        if (view.tag == tag) {
            view.backgroundColor = BG_Color;
        } else {
            view.backgroundColor = [UIColor whiteColor];
        }
    }
    
    switch (tag) {
        case 100:
            NSLog(@"官方群");
            _currentGroupType = 0;
            [self getGuanFangGroupType];
            break;
        case 101:
            NSLog(@"社会群");
            _currentGroupType = 1;
            [self showSiYouQun];
            break;
        case 102:
            NSLog(@"学术群");
            _currentGroupType = 2;
            [self getXueShuGroupType];
            break;
        default:
            break;
    }
    
}


#pragma mark - 设置顶部 搜索 视图
- (void)setTopSearchView {
    
    //进入搜索页面
    [self.topSearchView bk_whenTapped:^{
        GroupSearchViewController *findVC = [[GroupSearchViewController alloc] init];
        [self.navigationController pushViewController:findVC animated:YES];
    }];
    
    [self.view addSubview:self.topSearchBGView];
    [self.topSearchBGView addSubview:self.topSearchView];
    [self.topSearchView addSubview:self.searchImg];
    [self.topSearchView addSubview:self.textLab];
    
    self.topSearchBGView.sd_layout.topEqualToView(self.view).widthIs(Width_Screen).heightIs(50);
    self.topSearchView.sd_layout.centerXEqualToView(self.topSearchBGView).centerYEqualToView(self.topSearchBGView).leftSpaceToView(self.topSearchBGView,20).rightSpaceToView(self.topSearchBGView,20).heightIs(30);
    self.searchImg.sd_layout.centerYEqualToView(self.topSearchView).leftSpaceToView(self.topSearchView,10).widthIs(18).heightIs(18);
    self.textLab.sd_layout.centerYEqualToView(self.topSearchView).leftSpaceToView(self.searchImg,10).rightSpaceToView(self.topSearchView,20).heightIs(30);
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([_stateArray[section] isEqualToString:@"1"]){
        //如果是展开状态
        NSArray *array = [_dataDic objectForKey:@(section)];
        return array.count;
    }else{
        //如果是闭合，返回0
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_currentGroupType == 1) { // 社会群
        
        GroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupCell" forIndexPath:indexPath];
        NSArray *array = [self.dataDic objectForKey:@(indexPath.section)];
        SheHuiModel *model = array[indexPath.row];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellAccessoryNone;
        cell.tag = indexPath.row;
        [cell setValueSheHuiModel:model];
        
        return cell;
        
    } else {
        
        GroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupCell" forIndexPath:indexPath];
        
        NSArray *array = [self.dataDic objectForKey:@(indexPath.section)];
        GroupModel *model = array[indexPath.row];
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellAccessoryNone;
        cell.tag = indexPath.row;
        
        [cell setValueByModel:model];
        
        return cell;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GroupTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"%ld --- %ld", indexPath.section, cell.tag);
    NSArray *array = [self.dataDic objectForKey:@(indexPath.section)];
    
    
    if (_currentGroupType == 0) {
        //官方群
        GroupModel *model = array[indexPath.row];
        GroupApplyJoinController *applyVC = [[GroupApplyJoinController alloc] initWithGroupId:model.GroupID];
        applyVC.imageStr = model.Pic;
        applyVC.title = model.GroupName;
        [self.navigationController pushViewController:applyVC animated:YES];
        
    } else if (_currentGroupType == 1){
        // 社会群(不需要先加群)
        SheHuiModel *model = array[indexPath.row];
        ChatViewController *chatVC = [[ChatViewController alloc]
                                      initWithConversationChatter:model.groupid conversationType:EMConversationTypeGroupChat];
        chatVC.title = model.groupname;
        chatVC.userid = model.groupid;
        [self.navigationController pushViewController:chatVC animated:YES];
        
    } else {
        // 学术群
        GroupModel *model = array[indexPath.row];
        GroupApplyJoinController *applyVC = [[GroupApplyJoinController alloc] initWithGroupId:model.GroupID];
        applyVC.imageStr = model.Pic;
        applyVC.title = model.GroupName;
        [self.navigationController pushViewController:applyVC animated:YES];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70;
}


/**
 *  设置头标题的样式,我这里是手写了一个button,在button上放的图片,文字.可以用别的方式
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [button setTag:section+1];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 60)];
    [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, button.frame.size.height-1, button.frame.size.width, 1)];
    [line setImage:[UIImage imageNamed:@"case_cell_Line"]];
    
    [button addSubview:line];
    
    UIImageView *_imgView = [[UIImageView alloc]init];
    if ([_stateArray[section] isEqualToString:@"0"]) {
        _imgView.frame = CGRectMake(10, (44-6)/2, 6, 10);
        _imgView.image = [UIImage imageNamed:@"rightyou"];
        
    }else if ([_stateArray[section] isEqualToString:@"1"]) {
        _imgView.frame = CGRectMake(10, (44-6)/2, 10, 6);
        _imgView.image = [UIImage imageNamed:@"xialaxll"];
        
    }
    [button addSubview:_imgView];
    
    UILabel *tlabel = [[UILabel alloc]initWithFrame:CGRectMake(40, (44-20)/2, 200, 20)];
    [tlabel setBackgroundColor:[UIColor clearColor]];
    [tlabel setFont:[UIFont systemFontOfSize:16]];
    if (_currentGroupType == 1) { // 社会群
        NSString *titleStr = self.sectionArray.firstObject;
        [tlabel setText:titleStr];
    } else { // 官方群/学术群
        GuanFangTypeModel *model = self.sectionArray[section];
        [tlabel setText:model.Name];
    }
    [button addSubview:tlabel];
    return button;
}

/**
 *  headButton点击
 */
- (void)buttonPress:(UIButton *)sender
{
    NSLog(@"button tag - %ld", (long)sender.tag);
    //判断状态值
    if ([_stateArray[sender.tag - 1] isEqualToString:@"1"]){
        //修改
        [_stateArray replaceObjectAtIndex:sender.tag - 1 withObject:@"0"];
    }else{
        [_stateArray replaceObjectAtIndex:sender.tag - 1 withObject:@"1"];
    }
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag - 1] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

/**
 *  返回section的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

#pragma mark - 懒加载
- (UIView *)topSearchBGView {
    if (!_topSearchBGView) {
        _topSearchBGView = [UIView new];
        _topSearchBGView.backgroundColor = RGB(245, 245, 245);
    }
    return _topSearchBGView;
}
- (UIView *)topSearchView {
    if (!_topSearchView) {
        _topSearchView = [UIView new];
        _topSearchView.backgroundColor = [UIColor whiteColor];
        _topSearchView.clipsToBounds = YES;
        _topSearchView.layer.cornerRadius = 5;
        _topSearchView.userInteractionEnabled = YES;
    }
    return _topSearchView;
}
- (UIImageView *)searchImg {
    if (!_searchImg) {
        _searchImg = [UIImageView new];
        _searchImg.image = [UIImage imageNamed:@"search"];
    }
    return _searchImg;
}
- (UILabel *)textLab {
    if (!_textLab) {
        _textLab = [UILabel new];
        _textLab.textColor = HuiText_Color;
        _textLab.text = @"搜索";
        _textLab.font = [UIFont systemFontOfSize:14];
    }
    return _textLab;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 132, Width_Screen, Height_Screen-238) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor  = [UIColor clearColor];
        _tableView.backgroundColor = BG_Color;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerNib:[UINib nibWithNibName:@"GroupTableViewCell" bundle:nil] forCellReuseIdentifier:@"groupCell"];
        
    }
    return _tableView;
}

/**
 * 官方群分类
 */

- (void)getGuanFangGroupType {
    
    NSString *urlS = [NSString stringWithFormat:@"%@/api/IM/GetIMGroupList", Server_Int_Url];
    NSString *dataS = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI, nil];
    NSString *dataEncrpyt = [TWDes encryptWithContent:dataS type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    NSDictionary *paraDic = @{kToken:token, kDatas:dataEncrpyt};
    [SVProgressHUD show]; // 菊花转起来
    self.view.userInteractionEnabled = NO; // 停止交互
    [AFManegerHelp POST:urlS parameters:paraDic success:^(id responseObjeck) {
        
        
        NSLog(@"官方群分组 - %@", responseObjeck);
        if ([responseObjeck[@"Success"] integerValue] == 1) {
            
            [self.sectionArray removeAllObjects];
            [self.stateArray removeAllObjects];
            
            NSArray *array = responseObjeck[@"JsonData"];

            for (NSDictionary *dic in array) {
                GuanFangTypeModel *model = [[GuanFangTypeModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.sectionArray addObject:model];
                [self.stateArray addObject:@"0"];//所有的分区默认都是闭合
            }

            NSLog(@"sectionArray - %@", self.sectionArray);
            
            [self.tableView reloadData];
            // 获取所有分区列表
            [self getGuanFangQuanAllList];
            
        } else {
            self.view.userInteractionEnabled = YES;
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            
            [self showHint:responseObjeck[@"Msg"]];
            
            if ([responseObjeck[@"Code"] integerValue] == 3) {
                
                [UserInfo removeAccessToken];//移除token
                [UserInfo removeDevIdentity];//移除单点登录
                NSUserDf_Set(kNoLogin,JRIsLogin);//修改登录状态
                NSUserDf_Remove(kDoctor);//移除是否是医师信息
                [UserInfo removeUserInfo];//移除用户信息
                EMError *error = [[EMClient sharedClient] logout:YES];
                if (!error) {
                    NSLog(@"环信退出成功");
                }
                NSUserDf_Set(nil, kHXName);
                NSUserDf_Set(nil, kHXPwd);
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5/*延迟执行时间*/ * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    JRLoginViewController *loginVC = [[JRLoginViewController alloc] init];
                    loginVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                    [self presentViewController:loginVC animated:YES completion:nil];
                });
                
                return ;
            }
            
        }
        
    } failure:^(NSError *error) {
        self.view.userInteractionEnabled = YES;
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        NSLog(@"获取官方群分类-错误信息%@", error);
    }];

    
}

- (void)getGuanFangQuanAllList {
    
    [self.dataDic removeAllObjects];
    
    _page = 0;
    NSString *type = @"";
    NSString *urlS = [NSString stringWithFormat:@"%@/api/IM/GetIMListByGroup", Server_Int_Url];
    
    for (int i = 0; i < self.sectionArray.count; i++) {
        
        GuanFangTypeModel *model = self.sectionArray[i];
        type = model.Value;
        NSLog(@"type - %@", type);
        NSString *dataS = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@  ZICBDYCGroupType=%@ZICBDYCKeyword=%@ZICBDYCCurPage=%ldZICBDYCPageSize=%@", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI, type, @"", _page, @200, nil];
        NSString *dataEncrpyt = [TWDes encryptWithContent:dataS type:kDesType key:kDesKey];
        NSString *token = [UserInfo getAccessToken];
        NSDictionary *paraDic = @{kToken:token, kDatas:dataEncrpyt};
        
        [AFManegerHelp POST:urlS parameters:paraDic success:^(id responseObjeck) {
            
            NSLog(@"官方群列表%@", responseObjeck);
            if ([responseObjeck[@"Success"]integerValue] == 1) {
                
                NSMutableArray *tempArr = [[NSMutableArray alloc] initWithCapacity:0];
                NSArray *array = responseObjeck[@"JsonData"];
                for (NSDictionary *d in array) {
                    GroupModel *model = [[GroupModel alloc]init];
                    [model setValuesForKeysWithDictionary:d];
                    [tempArr addObject:model];
                }
                
                [self.dataDic setObject:tempArr forKey:@(i)]; // 所有分区列表 形式: @{0 : @[], 1 : @[], 2 : @[]}
                [SVProgressHUD dismiss]; // 菊花停
                self.view.userInteractionEnabled = YES; // 打开交互
                [self.tableView.mj_header endRefreshing];
                
            }else {
                self.view.userInteractionEnabled = YES;
                [SVProgressHUD dismiss];
                NSLog(@"%@", responseObjeck[@"Msg"]);
                [self.tableView.mj_header endRefreshing];
            }
            
        } failure:^(NSError *error) {
            self.view.userInteractionEnabled = YES;
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            NSLog(@"官方群列表 - 错误信息%@", error);
        }];
        
    }
    
}

/**
 * 学术群分类
 */
- (void)getXueShuGroupType {
    
    NSString *urlS = [NSString stringWithFormat:@"%@/api/IM/GetStudyGroupList", Server_Int_Url];
    NSString *dataS = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI, nil];
    NSString *dataEncrpyt = [TWDes encryptWithContent:dataS type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    NSDictionary *paraDic = @{kToken:token, kDatas:dataEncrpyt};
    [SVProgressHUD show]; // 菊花转
    self.view.userInteractionEnabled = NO; // 停止交互
    [AFManegerHelp POST:urlS parameters:paraDic success:^(id responseObjeck) {
        
        NSLog(@"学术群分类 - %@", responseObjeck);
        if ([responseObjeck[@"Success"]integerValue] == 1) {
            
            [self.sectionArray removeAllObjects];
            [self.stateArray removeAllObjects];
            
            NSArray *array = responseObjeck[@"JsonData"];
            for (NSDictionary *d in array) {
                GuanFangTypeModel *model = [[GuanFangTypeModel alloc]init];
                [model setValuesForKeysWithDictionary:d];
                [self.sectionArray addObject:model];
                [self.stateArray addObject:@"0"];//所有的分区默认都是闭合
            }
            
            [self.tableView reloadData];
            // 获取所有分区列表
            [self getXueShuGroupAllList];

        } else {
            self.view.userInteractionEnabled = YES;
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            
            [self showHint:responseObjeck[@"Msg"]];
            if ([responseObjeck[@"Code"] integerValue] == 3) {
                
                [UserInfo removeAccessToken];//移除token
                [UserInfo removeDevIdentity];//移除单点登录
                NSUserDf_Set(kNoLogin,JRIsLogin);//修改登录状态
                NSUserDf_Remove(kDoctor);//移除是否是医师信息
                [UserInfo removeUserInfo];//移除用户信息
                EMError *error = [[EMClient sharedClient] logout:YES];
                if (!error) {
                    NSLog(@"环信退出成功");
                }
                NSUserDf_Set(nil, kHXName);
                NSUserDf_Set(nil, kHXPwd);
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5/*延迟执行时间*/ * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    JRLoginViewController *loginVC = [[JRLoginViewController alloc] init];
                    loginVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                    [self presentViewController:loginVC animated:YES completion:nil];
                });
                
                return ;
            }
            
        }
        
    } failure:^(NSError *error) {
        self.view.userInteractionEnabled = YES;
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        NSLog(@"学术群分类接口错误信息%@", error);
    }];
    
}

- (void)getXueShuGroupAllList {
    
    [self.dataDic removeAllObjects];
    
    _page = 0;
    NSString *type = @"";
    NSString *urlS = [NSString stringWithFormat:@"%@/api/IM/GetStudyListByGroup", Server_Int_Url];
    
    for (int i = 0; i < self.sectionArray.count; i++) {
        
        GuanFangTypeModel *model = self.sectionArray[i];
        type = model.Value;
        
        NSString *dataS = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@  ZICBDYCGroupType=%@ZICBDYCKeyword=%@ZICBDYCCurPage=%ldZICBDYCPageSize=%@", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI, type, @"", _page, @200, nil];
        NSString *dataEncrpyt = [TWDes encryptWithContent:dataS type:kDesType key:kDesKey];
        NSString *token = [UserInfo getAccessToken];
        NSDictionary *paraDic = @{kToken:token, kDatas:dataEncrpyt};
        
        [AFManegerHelp POST:urlS parameters:paraDic success:^(id responseObjeck) {
            
            NSLog(@"学术群列表 - %@", responseObjeck);
            if ([responseObjeck[@"Success"]integerValue] == 1) {
                NSLog(@"学术群type - %@", type);
                NSMutableArray *tempArr = [[NSMutableArray alloc] initWithCapacity:0];
                NSArray *array = responseObjeck[@"JsonData"];
                for (NSDictionary *d in array) {
                    GroupModel *model = [[GroupModel alloc]init];
                    [model setValuesForKeysWithDictionary:d];
                    [tempArr addObject:model];
                    
                }
                NSLog(@"i --- %d", i);
                [self.dataDic setObject:tempArr forKey:@(i)]; // 所有分区列表 形式: @{0 : @[], 1 : @[], 2 : @[]}
                NSLog(@"dataDic - %@", self.dataDic);
                [SVProgressHUD dismiss]; // 菊花停
                self.view.userInteractionEnabled = YES;
                [self.tableView.mj_header endRefreshing];
                
            }else {
                self.view.userInteractionEnabled = YES;
                [SVProgressHUD dismiss];
                [self.tableView.mj_header endRefreshing];
                NSLog(@"%@", responseObjeck[@"Msg"]);
            }
            
        } failure:^(NSError *error) {
            self.view.userInteractionEnabled = YES;
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            NSLog(@"学术群列表 - 错误信息%@", error);
        }];
        
    }
    
    
    
}


/**
 *  私有群(社会群)
 */
- (void)showSiYouQun {
    
    NSString *urlS = [NSString stringWithFormat:@"%@/api/IM/PrivateGroupLst", Server_Int_Url];
    NSString *dataS = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCkey=%@", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI,@"", nil];
    NSString *dataEncrpyt = [TWDes encryptWithContent:dataS type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    NSDictionary *paraDic = @{kToken:token, kDatas:dataEncrpyt};
    [SVProgressHUD show]; // 菊花转
    self.view.userInteractionEnabled = NO;
    [AFManegerHelp POST:urlS parameters:paraDic success:^(id responseObjeck) {
        
        NSLog(@"PrivateGroupLst---%@", responseObjeck);
        if ([responseObjeck[@"Success"]integerValue] == 1) {
            
            [SVProgressHUD dismiss]; // 菊花停
            [self.sectionArray removeAllObjects];
            [self.stateArray removeAllObjects];
            [self.dataDic removeAllObjects];
            
            NSArray *array = responseObjeck[@"JsonData"];
            if (array.count == 0) {
                [self showHint:@"您还未添加或加入过社会群" yOffset:-100];
            } else {
                NSMutableArray *tempArr = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSDictionary *d in array) {
                    SheHuiModel *model = [[SheHuiModel alloc]init];
                    [model setValuesForKeysWithDictionary:d];
                    [tempArr addObject:model];
                    
                }
                [self.sectionArray addObject:@"社会群"];
                [self.stateArray addObject:@"0"];//所有的分区默认都是闭合
                [self.dataDic setObject:tempArr forKey:@(0)];
            }
            
            [self.tableView reloadData];
            self.view.userInteractionEnabled = YES;
            [self.tableView.mj_header endRefreshing];
            
        } else {
            [SVProgressHUD dismiss];
            self.view.userInteractionEnabled = YES;
            [self.tableView.mj_header endRefreshing];
            
            [self showHint:responseObjeck[@"Msg"]];
            
            if ([responseObjeck[@"Code"] integerValue] == 3) {
                
                [UserInfo removeAccessToken];//移除token
                [UserInfo removeDevIdentity];//移除单点登录
                NSUserDf_Set(kNoLogin,JRIsLogin);//修改登录状态
                NSUserDf_Remove(kDoctor);//移除是否是医师信息
                [UserInfo removeUserInfo];//移除用户信息
                EMError *error = [[EMClient sharedClient] logout:YES];
                if (!error) {
                    NSLog(@"环信退出成功");
                }
                NSUserDf_Set(nil, kHXName);
                NSUserDf_Set(nil, kHXPwd);
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5/*延迟执行时间*/ * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    JRLoginViewController *loginVC = [[JRLoginViewController alloc] init];
                    loginVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                    [self presentViewController:loginVC animated:YES completion:nil];
                });
                
                return ;
            }
            
        }
        
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        self.view.userInteractionEnabled = YES;
        [self.tableView.mj_header endRefreshing];
        NSLog(@"社会群错误信息%@", error);
    }];
    
}

- (void)setRefresh {
    _page = 0;
    __block typeof(self)weakself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        NSLog(@"%ld", (long)_currentGroupType);
        
        switch (_currentGroupType) {
            case 0: // 当前是官方群
                [weakself getGuanFangGroupType];
                break;
            case 1: // 当前是社会群
                [weakself showSiYouQun];
                break;
            case 2: // 当前是学术群
                [weakself getXueShuGroupType];
                break;
            default:
                break;
        }
    }];
    
    // 进入界面时刷新
//    [self.zqTableView.mj_header beginRefreshing];
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
