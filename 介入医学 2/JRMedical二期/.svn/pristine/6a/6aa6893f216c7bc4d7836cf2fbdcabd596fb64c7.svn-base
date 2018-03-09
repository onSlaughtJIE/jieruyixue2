//
//  ExpertPostListVC.m
//  JRMedical
//
//  Created by a on 17/1/4.
//  Copyright © 2017年 idcby. All rights reserved.
//

#import "ExpertPostListVC.h"

#import "ReplyPostModel.h"
#import "DoctorTopicCell.h"
#import "VideoPlayVC.h"

#import "UITableView+EmpayData.h"

//回帖
#define Cell_GuTai_Height 95 //cell的固态高度
#define Cell_Text_ZD_Height 65 //cell的内容的最大高度
#define Cell_Img_Height(imgNum) ((Width_Screen-94)/3+5)*imgNum//cell数张图片的高度
#define Cell_OneImg_Weight (Width_Screen-84)/4*3//cell一个图片的宽度
#define Cell_OneImg_Height ((Width_Screen-84)/4*3)/3*2//cell一个图片的高度

@interface ExpertPostListVC ()<YHWorkGroupPhotoContainerDelegate>

//帖
@property (nonatomic, strong) NSMutableArray *thumImgs;//缩略图集合
@property (nonatomic, strong) NSMutableArray *hdImgs;//高清图集合
@property (nonatomic, strong) NSMutableArray *rTypes;//图片类型集合

@end

@implementation ExpertPostListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"医生话题";
    
    //帖
    self.thumImgs = [NSMutableArray arrayWithCapacity:0];//缩略图集合
    self.hdImgs = [NSMutableArray arrayWithCapacity:0];//高清图集合
    self.rTypes = [NSMutableArray arrayWithCapacity:0];//图片类型集合
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.backgroundColor = BG_Color;
    self.tableView.separatorColor = BG_Color;
    [self.tableView registerClass:[DoctorTopicCell class] forCellReuseIdentifier:NSStringFromClass([DoctorTopicCell class])];
    
    [self requestListDataArrray];
}

#pragma mark - YHWorkGroupPhotoContainerDelegate
- (void)selectedVideoPushPostDetail:(NSString *)url {
    // 1.获得视频播放的URL
    VideoPlayVC *video = [VideoPlayVC new];
    video.url = url;
    BaseNavigationController *videoNC = [[BaseNavigationController alloc] initWithRootViewController:video];
    [self presentViewController:videoNC animated:YES completion:nil];
}

#pragma mark - 请求数据列表
- (void)requestListDataArrray {
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCCustomerID=%@",self.ID];
    NSString *url = @"api/Post/CustomerPost";
    
    [self showLoadding:@"正在加载" time:20];
    [self loadDataApi:url withParams:params refresh:RefreshTypeBoth model:ReplyPostModel.class];
}

#pragma mark - Table view datasource and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSource == nil) {
        [tableView tableViewDisplayWitMsg:@"" ifNecessaryForRowCount:self.dataSource.count];
    }
    else {
        [tableView tableViewDisplayWitMsg:@"暂无医生话题信息!" ifNecessaryForRowCount:self.dataSource.count];
        
        if (self.dataSource.count > 0) {
            
            [self.thumImgs removeAllObjects];
            [self.hdImgs removeAllObjects];
            [self.rTypes removeAllObjects];
            
            //遍历数据源,取出并单独存储每条数据的  缩略图 高清图 和  视频地址  //视频地址 和 图片高清图 是 公用一个Url
            for (ReplyPostModel *model  in self.dataSource) {
                
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ReplyPostModel *model = self.dataSource[indexPath.row];
    
    NSArray *thumImgArray = self.thumImgs[indexPath.row];
    NSArray *hdImgArray = self.hdImgs[indexPath.row];
    NSArray *rTypeArray = self.rTypes[indexPath.row];
    
    DoctorTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DoctorTopicCell class]) forIndexPath:indexPath];
    
    cell.picContainerView.delegate = self;
    [cell setIndexPath:indexPath];
    [cell setPicUrlArray:thumImgArray];
    [cell setPicOriArray:hdImgArray];
    [cell setRTypeArray:rTypeArray];
    [cell setModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReplyPostModel *model = self.dataSource[indexPath.row];
    
    NSArray *thumImgArray = self.thumImgs[indexPath.row];
    
    NSInteger num;
    if (thumImgArray.count >= 9) {
        num = 9;
    }
    else {
        num = thumImgArray.count;
    }
    
    CGRect contantWidth = [Utils getTextRectWithString:model.Content withWidth:Width_Screen-84 withFontSize:16];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
