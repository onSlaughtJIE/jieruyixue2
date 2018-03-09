//
//  DoctorInfoViewController.m
//  JRMedical
//
//  Created by ww on 2016/12/28.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "DoctorInfoViewController.h"

#import "MyAttentionCell.h"
#import "DoctorInfoJianLiCell.h"

#import "KMImageBrowser.h"

@interface DoctorInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *sectionHeaderArr;

@end

@implementation DoctorInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view addSubview:self.tableView];
    
    self.sectionHeaderArr = @[@"医生擅长", @"成果", @"简历"];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.backgroundColor = BG_Color;
        _tableView.separatorColor = RGB(230, 230, 230);
        [_tableView registerClass:[MyAttentionCell class] forCellReuseIdentifier:@"attentionCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"DoctorInfoJianLiCell" bundle:nil] forCellReuseIdentifier:@"dijLiCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        MyAttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"attentionCell" forIndexPath:indexPath];
        [cell setModel:self.model];
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        if ([self.dataInfo[@"SpecialtyMsg"] isEqualToString:@""] || self.dataInfo[@"SpecialtyMsg"] == nil) {
            cell.textLabel.text = @"目前还没上传擅长信息";
            cell.textLabel.textColor = [UIColor lightGrayColor];
        }
        else {
            cell.textLabel.text = self.dataInfo[@"SpecialtyMsg"];
            cell.textLabel.textColor = [UIColor blackColor];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        return cell;
    }
    else if (indexPath.section == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        if ([self.dataInfo[@"AchievementsMsg"] isEqualToString:@""] || self.dataInfo[@"AchievementsMsg"] == nil) {
            cell.textLabel.text = @"目前还没上传成果信息";
            cell.textLabel.textColor = [UIColor lightGrayColor];
        }
        else {
            cell.textLabel.text = self.dataInfo[@"AchievementsMsg"];
            cell.textLabel.textColor = [UIColor blackColor];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        return cell;
    }
    else {
        
        NSArray *imgArray = self.dataInfo[@"ResumeList"];
        if (imgArray.count == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.selectionStyle  = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"目前还没上传简历信息";
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            return cell;
        }
        else {
            DoctorInfoJianLiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dijLiCell" forIndexPath:indexPath];
            [cell setDataImgAry:imgArray];
            
            [cell.image1 bk_whenTapped:^{
                [KMImageBrowser showImage:cell.image1];
            }];
            [cell.image2 bk_whenTapped:^{
                [KMImageBrowser showImage:cell.image2];
            }];
            [cell.image3 bk_whenTapped:^{
                [KMImageBrowser showImage:cell.image3];
            }];
            [cell.image4 bk_whenTapped:^{
                [KMImageBrowser showImage:cell.image4];
            }];
            [cell.image5 bk_whenTapped:^{
                [KMImageBrowser showImage:cell.image5];
            }];
            [cell.image6 bk_whenTapped:^{
                [KMImageBrowser showImage:cell.image6];
            }];
            
            return cell;
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 90;
    }
    else if (indexPath.section == 1) {
        
        if ([self.dataInfo[@"SpecialtyMsg"] isEqualToString:@""] || self.dataInfo[@"SpecialtyMsg"] == nil) {
            return 44;
        }
        else {
            CGRect contantWidth = [Utils getTextRectWithString:self.dataInfo[@"SpecialtyMsg"] withWidth:Width_Screen-30 withFontSize:14];
            return 30+contantWidth.size.height;
        }
    }
    else if (indexPath.section == 2) {
        
        if ([self.dataInfo[@"AchievementsMsg"] isEqualToString:@""] || self.dataInfo[@"AchievementsMsg"] == nil) {
            return 44;
        }
        else {
            CGRect contantWidth = [Utils getTextRectWithString:self.dataInfo[@"AchievementsMsg"] withWidth:Width_Screen-30 withFontSize:14];
            return 30+contantWidth.size.height;
        }
    }
    else {
        
        NSArray *imgArray = self.dataInfo[@"ResumeList"];
        if (imgArray.count == 0) {
            return 44;
        } else if (imgArray.count > 0 && imgArray.count <= 3) {
            return (Width_Screen-60)/3+30;
        } else {
           return ((Width_Screen-60)/3)*2+45;
        }
        
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        return nil;
    }
    else {
        UIView *header = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, Width_Screen, 40))];
        header.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:(CGRectMake(15, 0, 200, 40))];
        label.textColor = Main_Color;
        label.font = [UIFont boldSystemFontOfSize:16];
        [header addSubview:label];
        label.text = self.sectionHeaderArr[section-1];
        return header;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0001;
    }
    else {
        return 40;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
