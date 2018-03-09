//
//  PostSearchResultVC.m
//  JRMedical
//
//  Created by a on 16/12/12.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "PostSearchResultVC.h"

#import "VideoPlayVC.h"
#import "PatientDetailVC.h"
#import "NewestPostCell.h"
#import "NewestPostModel.h"
#import "NewesPostFooterView.h"

#import "UITableView+EmpayData.h"

#define Cell_GuTai_Height 95 //cell的固态高度
#define Cell_Text_ZD_Height 65 //cell的内容的最大高度
#define Cell_Img_Height(imgNum) ((Width_Screen-30)/3+5)*imgNum//cell数张图片的高度
#define Cell_OneImg_Weight (Width_Screen-20)/4*3//cell一个图片的宽度
#define Cell_OneImg_Height ((Width_Screen-20)/4*3)/3*2//cell一个图片的高度

@interface PostSearchResultVC ()<YHWorkGroupPhotoContainerDelegate>

@property (nonatomic, strong) NSMutableArray *thumImgs;//缩略图集合
@property (nonatomic, strong) NSMutableArray *hdImgs;//高清图集合
@property (nonatomic, strong) NSMutableArray *rTypes;//图片类型集合

@end

@implementation PostSearchResultVC

- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"搜索结果";
    
    self.thumImgs = [NSMutableArray arrayWithCapacity:0];//缩略图集合
    self.hdImgs = [NSMutableArray arrayWithCapacity:0];//高清图集合
    self.rTypes = [NSMutableArray arrayWithCapacity:0];//图片类型集合
    
    self.tableView.separatorColor  = BG_Color;
    self.tableView.backgroundColor = BG_Color;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.tableView registerClass:[NewestPostCell class] forCellReuseIdentifier:NSStringFromClass([NewestPostCell class])];
    
    [self requestListDataArrray];//请求搜索
}

#pragma mark - 请求数据列表
- (void)requestListDataArrray {
    
    NSString *url = @"api/Post/SearchPost";
    NSString *params = [NSString stringWithFormat:@"ZICBDYCDictType=%@ZICBDYCQuery=%@",self.dictType,self.searchKeyWord];
    
    [self showLoadding:@"正在搜索" time:20];
    [self loadDataApi:url withParams:params refresh:RefreshTypeBoth model:NewestPostModel.class];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataSource == nil) {
        [tableView tableViewDisplayWitMsg:@"" ifNecessaryForRowCount:self.dataSource.count];
    }
    else {
        [tableView tableViewDisplayWitMsg:@"暂无相关论坛信息!" ifNecessaryForRowCount:self.dataSource.count];
        
        if (self.dataSource.count > 0) {
            
            [self.thumImgs removeAllObjects];
            [self.hdImgs removeAllObjects];
            [self.rTypes removeAllObjects];
            
            //遍历数据源,取出并单独存储每条数据的  缩略图 高清图 和  视频地址  //视频地址 和 图片高清图 是 公用一个Url
            for (NewestPostModel *model  in self.dataSource) {
                
                NSMutableArray *tImgAry = [NSMutableArray arrayWithCapacity:0];
                NSMutableArray *hImgAry = [NSMutableArray arrayWithCapacity:0];
                NSMutableArray *rTypeAry = [NSMutableArray arrayWithCapacity:0];
                
                //如果没有发表图片视频信息 则 不存储
                if (model.List.count > 0) {
                    for (NSDictionary *data in model.List) {
                        
                        [rTypeAry addObject:data[@"RType"]];
                        
                        if ([data[@"RType"] integerValue] == 1) {
                            [tImgAry addObject:data[@"VideoPic"]];//如果是 视频类型 则 缩略图数组 储存 视频的图片
                            [hImgAry addObject:data[@"Uri"]];//将公用的Url储存到视频连接数组去
                        }
                        else {
                            [tImgAry addObject:data[@"ThumImg"]];//如果是 图片类型 则 缩略图数组 储存 图片缩略图片
                            [hImgAry addObject:data[@"Uri"]];//将公用的Url储存到图片高清图数组去
                        }
                    }
                }
                [self.thumImgs addObject:tImgAry];//存储遍历过来的缩略图片
                [self.hdImgs addObject:hImgAry];//存储遍历过来的高清图片
                [self.rTypes addObject:rTypeAry];//存储每个 视频 还是 图片 的类型
            }
        }
    }
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewestPostModel *model = self.dataSource[indexPath.section];
    
    NSArray *thumImgArray = self.thumImgs[indexPath.section];
    NSArray *hdImgArray = self.hdImgs[indexPath.section];
    NSArray *rTypeArray = self.rTypes[indexPath.section];
    
    NewestPostCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NewestPostCell class]) forIndexPath:indexPath];
    cell.picContainerView.delegate = self;
    [cell setIndexPath:indexPath];
    [cell setPicUrlArray:thumImgArray];
    [cell setPicOriArray:hdImgArray];
    [cell setRTypeArray:rTypeArray];
    [cell setModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewestPostModel *model = self.dataSource[indexPath.section];
    
    NSArray *thumImgArray = self.thumImgs[indexPath.section];
    
    NSInteger num;
    if (thumImgArray.count >= 9) {
        num = 9;
    }
    else {
        num = thumImgArray.count;
    }
    
    CGRect contantWidth = [Utils getTextRectWithString:model.Title withWidth:Width_Screen-20 withFontSize:16];
    
    if (contantWidth.size.height >= Cell_Text_ZD_Height) {
        contantWidth.size.height = Cell_Text_ZD_Height;
    }
    
    if (num == 1) {
        return Cell_GuTai_Height + contantWidth.size.height + Cell_OneImg_Height;
    }
    else if (num <= 3 && num >1) {
        return Cell_GuTai_Height + contantWidth.size.height + Cell_Img_Height(1) - 5;
    }
    else if (num >= 3 && num <= 6) {
        return Cell_GuTai_Height + contantWidth.size.height + Cell_Img_Height(2) - 5;
    }
    else if (num > 6) {
        return Cell_GuTai_Height + contantWidth.size.height + Cell_Img_Height(3) - 5;
    }
    else {
        return Cell_GuTai_Height + contantWidth.size.height - 10;
    }
}

/* 搜索结果隐藏工具栏
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    NewestPostModel *model = self.dataSource[section];
    
    NewesPostFooterView *footer = [NewesPostFooterView new];
    [footer setModel:model];
    return footer;
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

#pragma mark  点击cell的响应的代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NewestPostModel *model = self.dataSource[indexPath.section];
    NSArray *thumImgArray = self.thumImgs[indexPath.section];
    NSArray *hdImgArray = self.hdImgs[indexPath.section];
    NSArray *rTypeArray = self.rTypes[indexPath.section];
    
    PatientDetailVC *pdVC = [PatientDetailVC new];
    pdVC.model = model;
    pdVC.picUrlArray = thumImgArray;
    pdVC.picOriArray = hdImgArray;
    pdVC.rTypeArray = rTypeArray;
    [self.navigationController pushViewController:pdVC animated:YES];
}

#pragma mark - YHWorkGroupPhotoContainerDelegate
- (void)selectedVideoPushPostDetail:(NSString *)url {
    // 1.获得视频播放的URL
    VideoPlayVC *video = [VideoPlayVC new];
    video.url = url;
    BaseNavigationController *videoNC = [[BaseNavigationController alloc] initWithRootViewController:video];
    [self presentViewController:videoNC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
