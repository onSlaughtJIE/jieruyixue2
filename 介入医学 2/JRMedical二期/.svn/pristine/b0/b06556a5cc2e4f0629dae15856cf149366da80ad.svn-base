//
//  SearchResultVC.m
//  JRMedical
//
//  Created by a on 16/11/25.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "SearchResultVC.h"

#import "UITableView+EmpayData.h"

#import "StudyCellOne.h"
#import "StudyCellTwo.h"
#import "StudyCellThree.h"
#import "StudyVideoCell.h"

#import "EquipmentSuppliesCell.h"
#import "EquipmentSuppliesListModel.h"
#import "EquipmentSuppliesWebVC.h"

#import "LearnWebController.h"
#import "PublicNewsListModel.h"
#import "VideoSpecialDetailContentVC.h"
#import "PdfWebViewController.h"
#import "MedicalMeetWebDetailVC.h"
#import "CaseCatalogueWebController.h"
#import "MedicalCoursewareCell.h"

#define kCellOne @"cellOneSearch"
#define kCellTwo @"cellTwoSearch"
#define kCellThree @"cellThreeSearch"
#define kCellVideo @"cellVideoSearch"

@interface SearchResultVC ()

@end

@implementation SearchResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"搜索结果";

    self.tableView.separatorInset = UIEdgeInsetsMake(0, 8, 0, 0);
    self.tableView.backgroundColor = BG_Color;
    [self.tableView registerNib:[UINib nibWithNibName:@"StudyCellOne" bundle:nil] forCellReuseIdentifier:kCellOne];
    [self.tableView registerNib:[UINib nibWithNibName:@"StudyCellTwo" bundle:nil] forCellReuseIdentifier:kCellTwo];
    [self.tableView registerNib:[UINib nibWithNibName:@"StudyCellThree" bundle:nil] forCellReuseIdentifier:kCellThree];
    [self.tableView registerNib:[UINib nibWithNibName:@"StudyVideoCell" bundle:nil] forCellReuseIdentifier:kCellVideo];
    [self.tableView registerClass:[EquipmentSuppliesCell class] forCellReuseIdentifier:NSStringFromClass([EquipmentSuppliesCell class])];
    [self.tableView registerClass:[MedicalCoursewareCell class] forCellReuseIdentifier:NSStringFromClass([MedicalCoursewareCell class])];//病例分类
    
    //请求新闻资讯列表
    [self requestListDataArrray];
}

#pragma mark - 请求数据列表
- (void)requestListDataArrray {
    
    if ([self.groupCode isEqualToString:@"CompanyType"]) {
        NSString *params = [NSString stringWithFormat:@"ZICBDYCQuery=%@",self.searchKeyWord];
        NSString *url = @"api/CompanyInfo/CompanyInfoList";
        [self showLoadding:@"正在搜索" time:20];
        [self loadDataApi:url withParams:params refresh:RefreshTypeBoth model:EquipmentSuppliesListModel.class];
    }
    else if ([self.groupCode isEqualToString:@"CaseCatalogue"]) {
        // 病例分类搜索
        NSString *url = @"api/CaseCatalogue/CaseCatalogueList";
        NSString *params = [NSString stringWithFormat:@"ZICBDYCLableID=%@ZICBDYCQuery=%@", @"0", self.searchKeyWord];
        [self showLoadding:@"正在搜索" time:20];
        [self loadDataApi:url withParams:params refresh:RefreshTypeBoth model:PublicNewsListModel.class];
        
    } else {
        NSString *params = [NSString stringWithFormat:@"ZICBDYCType=%@ZICBDYCGroupCode=%@ZICBDYCSearchKeyWord=%@",self.searchType,self.groupCode,self.searchKeyWord];
        NSString *url = @"api/News/SearchZiXun";
        [self showLoadding:@"正在搜索" time:20];
        [self loadDataApi:url withParams:params refresh:RefreshTypeBoth model:PublicNewsListModel.class];
    }
}

#pragma mark - Table view datasource and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSource == nil) {
        [tableView tableViewDisplayWitMsg:@"" ifNecessaryForRowCount:self.dataSource.count];
    }
    else {
        [tableView tableViewDisplayWitMsg:@"未搜索到任何信息!" ifNecessaryForRowCount:self.dataSource.count];
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.groupCode isEqualToString:@"CompanyType"]) {
        
        EquipmentSuppliesListModel *model = self.dataSource[indexPath.row];
        EquipmentSuppliesCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EquipmentSuppliesCell class]) forIndexPath:indexPath];
        [cell setModel:model];
        return cell;
        
    } else if ([self.groupCode isEqualToString:@"CaseCatalogue"]) {
        
        PublicNewsListModel *model = self.dataSource[indexPath.row];
        MedicalCoursewareCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MedicalCoursewareCell class]) forIndexPath:indexPath];
        [cell setModel:model];
        return cell;
    }
    else {
        PublicNewsListModel *model = self.dataSource[indexPath.row];
        
        NSInteger imgNum = model.ImageNum;
        NSString *groupCode = model.GroupCode;
        
        if ([groupCode isEqualToString:@"VideoLecturesMajor"]) {//视频
            
            StudyVideoCell *cellVideo = [tableView dequeueReusableCellWithIdentifier:kCellVideo forIndexPath:indexPath];
            [cellVideo setModel:model];
            return cellVideo;
        }
        else {
            switch (imgNum) {
                case 0://没有图片
                {
                    StudyCellTwo *cellTwo = [tableView dequeueReusableCellWithIdentifier:kCellTwo forIndexPath:indexPath];
                    [cellTwo setModel:model];
                    return cellTwo;
                }
                    break;
                case 1://一张图片
                {
                    StudyCellOne *cellOne = [tableView dequeueReusableCellWithIdentifier:kCellOne forIndexPath:indexPath];
                    [cellOne setModel:model];
                    return cellOne;
                }
                    break;
                case 3://三张图片
                {
                    StudyCellThree *cellThree = [tableView dequeueReusableCellWithIdentifier:kCellThree forIndexPath:indexPath];
                    [cellThree setModel:model];
                    return cellThree;
                }
                    break;
                    
                default:
                    break;
            }
        }
        
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.groupCode isEqualToString:@"CompanyType"]) {
        return 100;
    }
    else if ([self.groupCode isEqualToString:@"CaseCatalogue"]) {
        return 100;
        
    } else {
        PublicNewsListModel *model = self.dataSource[indexPath.row];
        
        NSInteger imgNum = model.ImageNum;
        NSString *groupCode = model.GroupCode;
        
        if ([groupCode isEqualToString:@"VideoLecturesMajor"]) {//视频
            return 280;
        }
        else {
            switch (imgNum) {
                    break;
                case 1://一张图片
                {
                    return 95;
                }
                    break;
                case 3://三张图片
                {
                    return 180;
                }
                    break;
                default://没有图片
                {
                    return 95;
                }
                    break;
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}

#pragma mark  点击cell的响应的代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if ([self.groupCode isEqualToString:@"CompanyType"]) {
        EquipmentSuppliesListModel *mode = self.dataSource[indexPath.row];
        EquipmentSuppliesWebVC * eswVC = [[EquipmentSuppliesWebVC alloc] init];
        eswVC.model = mode;
        eswVC.title = mode.CompanyName;
        [self.navigationController pushViewController:eswVC animated:YES];
        
    } else if ([self.groupCode isEqualToString:@"CaseCatalogue"]) {
        // 病例分类
        PublicNewsListModel *model = self.dataSource[indexPath.row];
        CaseCatalogueWebController *webVC = [[CaseCatalogueWebController alloc] init];
        webVC.model = model;
        [self.navigationController pushViewController:webVC animated:YES];
        
    }
    else {
        PublicNewsListModel *model = self.dataSource[indexPath.row];
        NSString *groupCode = model.GroupCode;
        
        if ([groupCode isEqualToString:@"VideoLecturesMajor"]) {//视频
            
            VideoSpecialDetailContentVC *vSDContentVC = [[VideoSpecialDetailContentVC alloc] init];
            vSDContentVC.model = model;
            [self.navigationController pushViewController:vSDContentVC animated:YES];
        }
        else if ([groupCode isEqualToString:@"MedicalCourseware"])  {
            // 进入医学课件
            PdfWebViewController *webVC = [[PdfWebViewController alloc] init];
            webVC.model = model;
            [self.navigationController pushViewController:webVC animated:YES];
        }
        else if ([groupCode isEqualToString:@"MedicalCongress"]) {
            //医学会议
            MedicalMeetWebDetailVC *webVC = [[MedicalMeetWebDetailVC alloc] init];
            webVC.model = model;
            [self.navigationController pushViewController:webVC animated:YES];
            
        } else {
            LearnWebController *webVC = [[LearnWebController alloc] init];
            webVC.model = model;
            [self.navigationController pushViewController:webVC animated:YES];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
