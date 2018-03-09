//
//  GoodFirstViewController.m
//  JRMedical
//
//  Created by ww on 2016/11/16.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "GoodFirstViewController.h"
#import "DetailGoodNameCell.h"
#import "DetailGoodUBNameCell.h"
#import "DetailGoodAddressCell.h"
#import "DetailGoodCommentCell.h"
#import "MerchandisePingLunListModel.h"
#import "MyAddressVC.h"
#import "MyAddressModel.h"
//#import "WLZ_ChangeCountView.h"

#import <YYKit.h>

//评论列表
#define Cell_GuTai_Height 118 //cell的固态高度
#define Cell_Img_Height(imgNum) ((Width_Screen-94)/3+5)*imgNum//cell数张图片的高度
#define Cell_OneImg_Weight (Width_Screen-84)/4*3//cell一个图片的宽度
#define Cell_OneImg_Height ((Width_Screen-84)/4*3)/3*2//cell一个图片的高度

@interface GoodFirstViewController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIScrollView *topScroll;

@property (nonatomic, strong) UILabel *numLab;

@property (nonatomic, strong) NSMutableDictionary *detailDataDic;
@property (nonatomic, strong) NSMutableArray *addressArray;

//评论列表
@property (nonatomic, strong) NSMutableArray *thumImgs;//缩略图集合
@property (nonatomic, strong) NSMutableArray *hdImgs;//高清图集合


@end

@implementation GoodFirstViewController {
    
    NSArray *_imageArray;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"detailDataDicNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"selectMyAddress" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //评论列表
    self.thumImgs = [NSMutableArray arrayWithCapacity:0];//缩略图集合
    self.hdImgs = [NSMutableArray arrayWithCapacity:0];//高清图集合
    
    //详情数据请求过来的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detailDataDicNotificationClick:) name:@"detailDataDicNotification" object:nil];
    
    //选择地址传过来的数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectMyAddressClick:) name:@"selectMyAddress" object:nil];
    
    [self getAddressInfoData];//获取地址信息
    
    [self getPingJiaInfoData];//评价列表
    
    [self.view addSubview:self.tableView];
    
    
}

#pragma mark - //选择分类下的分类后刷新数据的通知
- (void)detailDataDicNotificationClick:(NSNotification *)sender {
    self.detailDataDic = sender.userInfo[@"DetailDataDic"];
    
    //设置顶部轮播
    _imageArray = self.detailDataDic[@"PicList"];
    if (_imageArray.count > 0) {
        [self setHeaderTableView:_imageArray];
    }
    
    [self.tableView reloadData];
    
    
}

#pragma mark - 选择地址
- (void)selectMyAddressClick:(NSNotification *)sender {
    
    MyAddressModel *model = sender.userInfo[@"myAddressModel"];
    
    [self.addressArray removeAllObjects];
    
    NSDictionary *addressDic = @{@"ID":model.ID,
                                 @"DetailAddress":model.DetailAddress,
                                 @"ConsigneeName":model.ConsigneeName,
                                 @"Consigneephone":model.Consigneephone,
                                 @"OrderIndex":model.OrderIndex,
                                 @"Province":model.Province,
                                 @"City":model.City,
                                 @"County":model.County,
                                 @"IsDefault":@(model.IsDefault)};
    
    [self.addressArray addObject:addressDic];
    
    NSMutableDictionary *allInfoDic = [[NSMutableDictionary alloc] init];
    [allInfoDic setObject:self.addressArray forKey:@"AddressArray"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FillInOrderAddressArray" object:nil userInfo:allInfoDic];
    
    [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
}

- (void)setHeaderTableView:(NSArray *)imgAry {
    
    self.topScroll.contentSize = CGSizeMake(Width_Screen * imgAry.count, 300);
    for (int i = 0; i < imgAry.count; i ++) {
        UIImageView *picImageView = [[UIImageView alloc] initWithFrame:(CGRectMake(Width_Screen*i, 0, Width_Screen, 300))];
        picImageView.backgroundColor = KMRC;
        picImageView.clipsToBounds = YES;
        picImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        NSString *imgUrl = imgAry[i][@"Uri"];
        
        [picImageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"jiazai"]];
        [self.topScroll addSubview:picImageView];
    }
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, Width_Screen, 300))];
    [self.tableView.tableHeaderView addSubview:_topScroll];
    
    _numLab = [[UILabel alloc] initWithFrame:(CGRectMake(Width_Screen-60, 240, 40, 40))];
    _numLab.backgroundColor = [UIColor blackColor];
    _numLab.alpha = 0.6;
    _numLab.layer.cornerRadius = 20;
    _numLab.layer.masksToBounds = YES;
    _numLab.textColor = [UIColor whiteColor];
    _numLab.textAlignment = NSTextAlignmentCenter;
    _numLab.font = [UIFont boldSystemFontOfSize:14];
    _numLab.text = [NSString stringWithFormat:@"1/%ld",imgAry.count];
    [self.tableView.tableHeaderView addSubview:_numLab];
}

- (UIScrollView *)topScroll {
    if (!_topScroll) {
        self.topScroll = [[UIScrollView alloc] initWithFrame:(CGRectMake(0, 0, Width_Screen, 300))];
        self.topScroll.backgroundColor = Main_Color;
        self.topScroll.showsHorizontalScrollIndicator = NO;
        self.topScroll.showsVerticalScrollIndicator = NO;
        self.topScroll.pagingEnabled = YES;
        self.topScroll.delegate = self;
        self.topScroll.bounces = NO;
    }
    return _topScroll;
}

- (UITableView *)tableView {
    if (!_tableView) {
        
        if (self.isShowTool == 100) {
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width_Screen, Height_Screen-64) style:(UITableViewStyleGrouped)];
        }
        else {
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width_Screen, Height_Screen-108) style:(UITableViewStyleGrouped)];
        }
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = BG_Color;
        _tableView.separatorColor = BG_Color;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 74, 0, 0);
        [_tableView registerNib:[UINib nibWithNibName:@"DetailGoodNameCell" bundle:nil] forCellReuseIdentifier:@"nameCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"DetailGoodAddressCell" bundle:nil] forCellReuseIdentifier:@"addressCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"DetailGoodUBNameCell" bundle:nil] forCellReuseIdentifier:@"detailGoodUBNameCell"];
        [_tableView registerClass:[DetailGoodCommentCell class] forCellReuseIdentifier:NSStringFromClass([DetailGoodCommentCell class])];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

#pragma mark - UITableView Delagate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        default:
        {
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
            return self.dataSource.count > 0 ? self.dataSource.count : 1;
        }
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0: // 标题
        {
            
            if (self.from == 1000) {
                DetailGoodNameCell *nameCell = [tableView dequeueReusableCellWithIdentifier:@"nameCell" forIndexPath:indexPath];
                
                if (self.detailDataDic.count > 0) {
                    [nameCell setDataDic:self.detailDataDic];
                    
                    //收藏按钮
                    [nameCell.shouChangBtn bk_whenTapped:^{
                        NSString *params = [NSString stringWithFormat:@"ZICBDYCCommodityID=%@",self.commodityID];
                        NSString *url = @"api/CommodityInfo/CollectionCommodity";
                        
                        [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
                            NSLog(@"收藏 - %@", modelData);
                            if (isSuccess) {
                                NSDictionary *data = modelData[@"JsonData"];
                                if ([data[@"IsCollection"] integerValue] == 1) {
                                    [self showMessage:@"收藏成功"];
                                    nameCell.shouChangLab.textColor = RGB(230, 79, 70);
                                    [nameCell.shouChangBtn setImage:[UIImage imageNamed:@"shoucangz"] forState:(UIControlStateNormal)];
                                }
                                else {
                                    [self showMessage:@"取消收藏"];
                                    nameCell.shouChangLab.textColor = [UIColor lightGrayColor];;
                                    [nameCell.shouChangBtn setImage:[UIImage imageNamed:@"shoucang_gray"] forState:(UIControlStateNormal)];
                                }
                                
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"cleanCollectionShangPing" object:nil userInfo:nil];
                            }
                            else {
                                NSString *msg  = [modelData objectForKey:@"Msg"];
                                if (msg!=nil && ![msg isEqual:@""]) {
                                    [self showMessage:msg];
                                }
                                else {
                                    [self showMessage:[NSString stringWithFormat:@"请求失败 #%d",code]];
                                }
                            }
                        }];
                    }];
                }
                return nameCell;
            }
            else {
                DetailGoodUBNameCell *nameCell = [tableView dequeueReusableCellWithIdentifier:@"detailGoodUBNameCell" forIndexPath:indexPath];
                if (self.detailDataDic.count > 0) {
                    [nameCell setDataDic:self.detailDataDic];
                    
                    //收藏按钮
                    [nameCell.shouChangBtn bk_whenTapped:^{
                        NSString *params = [NSString stringWithFormat:@"ZICBDYCCommodityID=%@",self.commodityID];
                        NSString *url = @"api/CommodityInfo/CollectionCommodity";
                        
                        [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
                            NSLog(@"收藏 - %@", modelData);
                            if (isSuccess) {
                                NSDictionary *data = modelData[@"JsonData"];
                                if ([data[@"IsCollection"] integerValue] == 1) {
                                    [self showMessage:@"收藏成功"];
                                    nameCell.shouChangLab.textColor = RGB(230, 79, 70);
                                    [nameCell.shouChangBtn setImage:[UIImage imageNamed:@"shoucangz"] forState:(UIControlStateNormal)];
                                }
                                else {
                                    [self showMessage:@"取消收藏"];
                                    nameCell.shouChangLab.textColor = [UIColor lightGrayColor];;
                                    [nameCell.shouChangBtn setImage:[UIImage imageNamed:@"shoucang_gray"] forState:(UIControlStateNormal)];
                                }
                                
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"cleanCollectionShangPing" object:nil userInfo:nil];
                            }
                            else {
                                NSString *msg  = [modelData objectForKey:@"Msg"];
                                if (msg!=nil && ![msg isEqual:@""]) {
                                    [self showMessage:msg];
                                }
                                else {
                                    [self showMessage:[NSString stringWithFormat:@"请求失败 #%d",code]];
                                }
                            }
                        }];
                    }];
                }
                return nameCell;
            }
            
            }
            break;
        case 1: // 地址
        {
            DetailGoodAddressCell *addressCell = [tableView dequeueReusableCellWithIdentifier:@"addressCell" forIndexPath:indexPath];
            if (self.addressArray.count > 0) {
                NSDictionary *dataDic = self.addressArray[0];
                NSString *province = dataDic[@"Province"];
                NSString *city = dataDic[@"City"];
                NSString *county = dataDic[@"County"];
                NSString *detailAddress = dataDic[@"DetailAddress"];
                
                NSString *msg = @"";
                if ([province isEqualToString:city]) {
                    msg = [NSString stringWithFormat:@"%@%@%@",province,county,detailAddress];
                }
                else {
                    msg = [NSString stringWithFormat:@"%@%@%@%@",province,city,county,detailAddress];
                }
                [addressCell setDetailStr:msg];
            }
            
            [addressCell.bianJiBtn bk_whenTapped:^{
                MyAddressVC *myaddressVC = [MyAddressVC new];
                myaddressVC.from = 1000;
                [self.navigationController pushViewController:myaddressVC animated:YES];
            }];
            
            return addressCell;
        }
            break;
        default: // 评论
        {
            if ( self.dataSource.count == 0) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
                cell.textLabel.text = @"还没有人评论过,快来评论吧!";
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.textLabel.textColor = RGB(0, 164, 156);
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.sd_layout.centerXEqualToView(cell.contentView).centerYEqualToView(cell.contentView).widthIs(Width_Screen).heightIs(40);
                return cell;
            }
            else {
                
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
        }
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 2) {
        UIView *view = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, Width_Screen, 50))];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *seperateLab = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, Width_Screen, 10))];
        seperateLab.backgroundColor = BG_Color;
        [view addSubview:seperateLab];
        
        UIImageView *right = [[UIImageView alloc] initWithFrame:(CGRectMake(Width_Screen-20, 21, 10, 18))];
        right.image = [UIImage imageNamed:@"yougengduo"];
        right.userInteractionEnabled = YES;
        [right bk_whenTapped:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"goToPingLun" object:nil userInfo:nil];
        }];
        [view addSubview:right];
        
        UILabel *label = [[UILabel alloc] initWithFrame:(CGRectMake(15, 20, Width_Screen, 20))];
        
        NSInteger num = [self.detailDataDic[@"EvaluateCount"] integerValue];
        label.text = [NSString stringWithFormat:@"评论(%ld)",num];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:14];
        [view addSubview:label];
        
        UILabel *lineLab = [[UILabel alloc] initWithFrame:(CGRectMake(0, 49, Width_Screen, 1))];
        lineLab.backgroundColor = BG_Color;
        [view addSubview:lineLab];
        
        return view;
    }
    else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return 50;
    }
    else if (section == 1){
        return 10;
    }
    else {
        return 0.0001;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
            return 120;
            break;
        case 1:
            return 99;
            break;
        default:
        {
            if (self.dataSource.count > 0) {
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
            return 40;
        }
            break;
    }
}

//滚动结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.topScroll) {
        NSInteger num = scrollView.contentOffsetX / scrollView.frame.size.width + 1;
        self.numLab.text = [NSString stringWithFormat:@"%ld/%ld", (long)num,_imageArray.count];
    }
}

#pragma mark - 获取默认地址信息
- (void)getAddressInfoData {
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCOpeType=%@",@"IsDefault"];
    NSString *url = @"api/MallsInfo/ReceiptAddressLst";
    
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"获取默认地址信息 - %@", modelData);
        if (isSuccess) {
            NSArray *dataAry = modelData[@"JsonData"];
            self.addressArray = [NSMutableArray arrayWithArray:dataAry];
            
            NSMutableDictionary *allInfoDic = [[NSMutableDictionary alloc] init];
            [allInfoDic setObject:self.addressArray forKey:@"AddressArray"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FillInOrderAddressArray" object:nil userInfo:allInfoDic];
            
            [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
        }
        else {
            NSString *msg  = [modelData objectForKey:@"Msg"];
            if (msg!=nil && ![msg isEqual:@""]) {
                [self showMessage:msg];
            }
            else {
                [self showMessage:[NSString stringWithFormat:@"请求失败 #%d",code]];
            }
        }
    }];
}

#pragma mark - 获取评论列表
- (void)getPingJiaInfoData {
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCID=%@",self.commodityID];
    NSString *url = @"api/CommodityInfo/CommodityEvaluate";
    
    self.tableType = 1;//表类
    self.pageSize = 3;//一次加载3条
    self.baseTableView = self.tableView;//将本类表 赋值给父类去操作
    [self loadDataApi:url withParams:params refresh:RefreshTypeFooter model:MerchandisePingLunListModel.class];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
