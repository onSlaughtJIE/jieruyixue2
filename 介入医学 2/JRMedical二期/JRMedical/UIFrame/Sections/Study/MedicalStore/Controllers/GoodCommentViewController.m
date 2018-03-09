//
//  GoodCommentViewController.m
//  JRMedical
//
//  Created by ww on 2016/11/16.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "GoodCommentViewController.h"
#import "DetailGoodCommentCell.h"
#import "MerchandisePingLunListModel.h"

#import "UITableView+EmpayData.h"

//评论列表
#define Cell_GuTai_Height 118 //cell的固态高度
#define Cell_Img_Height(imgNum) ((Width_Screen-94)/3+5)*imgNum//cell数张图片的高度
#define Cell_OneImg_Weight (Width_Screen-84)/4*3//cell一个图片的宽度
#define Cell_OneImg_Height ((Width_Screen-84)/4*3)/3*2//cell一个图片的高度

@interface GoodCommentViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *commentTab;

//评论列表
@property (nonatomic, strong) NSMutableArray *thumImgs;//缩略图集合
@property (nonatomic, strong) NSMutableArray *hdImgs;//高清图集合

@end

@implementation GoodCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //评论列表
    self.thumImgs = [NSMutableArray arrayWithCapacity:0];//缩略图集合
    self.hdImgs = [NSMutableArray arrayWithCapacity:0];//高清图集合
    
    [self getPingJiaInfoData];
    
    [self.view addSubview:self.commentTab];
}

#pragma mark - 获取评论列表
- (void)getPingJiaInfoData {
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCID=%@",self.commodityID];
    NSString *url = @"api/CommodityInfo/CommodityEvaluate";
    [self showLoadding:@"正在加载" time:20];
    self.tableType = 1;//表类
    self.baseTableView = self.commentTab;//将本类表 赋值给父类去操作
    [self loadDataApi:url withParams:params refresh:RefreshTypeBoth model:MerchandisePingLunListModel.class];
}

- (UITableView *)commentTab {
    if (!_commentTab) {
        
        if (self.isShowTool == 100) {
            _commentTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width_Screen, Height_Screen-64) style:(UITableViewStyleGrouped)];
        }
        else {
            _commentTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width_Screen, Height_Screen-108) style:(UITableViewStyleGrouped)];
        }
        
        _commentTab.delegate = self;
        _commentTab.dataSource = self;
        _commentTab.backgroundColor = BG_Color;
        _commentTab.separatorInset = UIEdgeInsetsMake(0, 74, 0, 0);
        [_commentTab registerClass:[DetailGoodCommentCell class] forCellReuseIdentifier:NSStringFromClass([DetailGoodCommentCell class])];
        [_commentTab registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _commentTab;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.dataSource == nil) {
        [tableView tableViewDisplayWitMsg:@"" ifNecessaryForRowCount:self.dataSource.count];
    }
    else {
        [tableView tableViewDisplayWitMsg:@"暂无相关评论信息!" ifNecessaryForRowCount:self.dataSource.count];
        
        if (self.dataSource.count > 0) {
            
            [self.thumImgs removeAllObjects];
            [self.hdImgs removeAllObjects];
            
            //遍历数据源,取出并单独存储每条数据的  缩略图 高清图 和  视频地址  //视频地址 和 图片高清图 是 公用一个Url
            for (MerchandisePingLunListModel *model  in self.dataSource) {
                
                NSMutableArray *tImgAry = [NSMutableArray arrayWithCapacity:0];
                NSMutableArray *hImgAry = [NSMutableArray arrayWithCapacity:0];
                
                //如果没有发表图片视频信息 则 不存储
                if (model.PicList.count > 0) {
                    for (NSDictionary *data in model.PicList) {
                        
                        [tImgAry addObject:data[@"ThumImg"]];//如果是 图片类型 则 缩略图数组 储存 图片缩略图片
                        [hImgAry addObject:data[@"ThumImg"]];//将公用的Url储存到图片高清图数组去
                    }
                }
                [self.thumImgs addObject:tImgAry];//存储遍历过来的缩略图片
                [self.hdImgs addObject:hImgAry];//存储遍历过来的高清图片
            }
        }
    }

    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MerchandisePingLunListModel *model = self.dataSource[indexPath.row];
    
    NSArray *thumImgArray = self.thumImgs[indexPath.row];
    NSArray *hdImgArray = self.hdImgs[indexPath.row];
    
    DetailGoodCommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DetailGoodCommentCell class]) forIndexPath:indexPath];
    [commentCell setIndexPath:indexPath];
    [commentCell setPicUrlArray:thumImgArray];
    [commentCell setPicOriArray:hdImgArray];
    [commentCell setModel:model];
    return commentCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MerchandisePingLunListModel *model = self.dataSource[indexPath.row];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
