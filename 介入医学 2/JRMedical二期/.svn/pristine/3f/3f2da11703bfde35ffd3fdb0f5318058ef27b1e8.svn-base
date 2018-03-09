 //
//  ExpertDetailsVC.m
//  JRMedical
//
//  Created by a on 16/12/26.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "ExpertDetailsVC.h"

#import "TopExpertDetailCell.h"
#import "ConsultationProjectCell.h"
#import "ExpertDataCell.h"
#import "UserPingJiaCell.h"
#import "MindWallCell.h"
#import "DoctorTopicCell.h"
#import "DoctorInfoViewController.h"

#import "ExpertPingJiaModel.h"
#import "ExpertXinYiModel.h"
#import "ReplyPostModel.h"
#import "VideoPlayVC.h"

#import <YYKit.h>

#import "GiveMindVC.h"

#import "MyPayOrder.h"
#import "Order.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "ChatViewController.h"

#import "ExpertPingJiaListVC.h"
#import "ExpertXinYiListVC.h"
#import "ExpertPostListVC.h"

//回帖
#define Cell_GuTai_Height 95 //cell的固态高度
#define Cell_Text_ZD_Height 65 //cell的内容的最大高度
#define Cell_Img_Height(imgNum) ((Width_Screen-94)/3+5)*imgNum//cell数张图片的高度
#define Cell_OneImg_Weight (Width_Screen-84)/4*3//cell一个图片的宽度
#define Cell_OneImg_Height ((Width_Screen-84)/4*3)/3*2//cell一个图片的高度

@interface ExpertDetailsVC ()<UITableViewDelegate,UITableViewDataSource,YHWorkGroupPhotoContainerDelegate>
{
    NSString *_expertID;
    NSString *_chatName;
    NSInteger _serviceTypeNum; // 1 图文咨询 ; 2 电话咨询
    ChatViewController *_chatVC;
    NSString *_tuwenPrice; // 医生的图文咨询价格, 零元时不再调支付, 直接进入聊天(调一下api/Customer/CreateCustomerService 新增服务)
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableDictionary *expertDetailDic;

@property (nonatomic, strong) NSMutableArray *pingJiaArray;
@property (nonatomic, strong) NSMutableArray *xinYiArray;
@property (nonatomic, strong) NSMutableArray *postArray;

//帖
@property (nonatomic, strong) NSMutableArray *thumImgs;//缩略图集合
@property (nonatomic, strong) NSMutableArray *hdImgs;//高清图集合
@property (nonatomic, strong) NSMutableArray *rTypes;//图片类型集合

@end

@implementation ExpertDetailsVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushXinYiRequestData" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pingJiaArray = [NSMutableArray arrayWithCapacity:0];
    self.xinYiArray = [NSMutableArray arrayWithCapacity:0];
    self.postArray = [NSMutableArray arrayWithCapacity:0];
    
    //帖
    self.thumImgs = [NSMutableArray arrayWithCapacity:0];//缩略图集合
    self.hdImgs = [NSMutableArray arrayWithCapacity:0];//高清图集合
    self.rTypes = [NSMutableArray arrayWithCapacity:0];//图片类型集合
    
    //支付后的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushXinYiRequestDataClick) name:@"pushXinYiRequestData" object:nil];
    
    [self.view addSubview:self.tableView];
    
    [self getExperDetailData];
    
    //
    // 接受支付宝支付回调结果的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aliPayCallBack2:) name:kAliPayCallBackInfo object:nil];
    // 接受微信支付回调结果的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixin_pay_result_success2:) name:kWeixin_pay_result_success object:nil];
}

#pragma mark - 刷新心意列表
- (void)pushXinYiRequestDataClick {
    
    [self getXinYiInfoData];
}

#pragma mark - 请求数据列表
- (void)requestListDataArrray {
}

#pragma mark - Table view datasource and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return self.pingJiaArray.count;
            break;
        case 4:
            return self.xinYiArray.count;
            break;
        default:
        {
            if (self.postArray.count > 0) {
                
                [self.thumImgs removeAllObjects];
                [self.hdImgs removeAllObjects];
                [self.rTypes removeAllObjects];
                
                //遍历数据源,取出并单独存储每条数据的  缩略图 高清图 和  视频地址  //视频地址 和 图片高清图 是 公用一个Url
                for (ReplyPostModel *model  in self.postArray) {
                    
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
            return self.postArray.count;
        }
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            TopExpertDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TopExpertDetailCell class]) forIndexPath:indexPath];
            [cell setModel:self.model];
            
            if (self.expertDetailDic.count > 0) {
                [cell setIsGZ:[self.expertDetailDic[@"IsFollow"] integerValue]];
            }
            
            [cell.followBtn bk_whenTapped:^{
                
                if (cell.followBtn.selected) {
                    NSString *params = [NSString stringWithFormat:@"ZICBDYCCustomerID=%@",self.model.CustomerID];
                    NSString *url = @"api/Customer/CancelCustomerFollow";
                    
                    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
                        NSLog(@"关注 - %@", modelData);
                        if (isSuccess) {
                            [self showMessage:@"取消关注"];
                            cell.followBtn.selected = NO;
                            
                            NSInteger num = [self.expertDetailDic[@"FollowCount"] integerValue];
                            [self.expertDetailDic setValue:@(num-1) forKey:@"FollowCount"];
                            [self.tableView reloadSection:2 withRowAnimation:UITableViewRowAnimationFade];
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
                else {
                    NSString *params = [NSString stringWithFormat:@"ZICBDYCCustomerID=%@",self.model.CustomerID];
                    NSString *url = @"api/Customer/AddCustomerFollow";
                    
                    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
                        NSLog(@"关注 - %@", modelData);
                        if (isSuccess) {
                            [self showMessage:@"关注成功"];
                            cell.followBtn.selected = YES;
                            
                            NSInteger num = [self.expertDetailDic[@"FollowCount"] integerValue];
                            [self.expertDetailDic setValue:@(num+1) forKey:@"FollowCount"];
                            [self.tableView reloadSection:2 withRowAnimation:UITableViewRowAnimationFade];
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
            }];
            
            [cell.giveMindBtn bk_whenTapped:^{
                GiveMindVC *gmVC = [GiveMindVC new];
                gmVC.ID = self.model.CustomerID;
                [self.navigationController pushViewController:gmVC animated:YES];
            }];
            
            return cell;
        }
            break;
        case 1:
        {
            ConsultationProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cpCell" forIndexPath:indexPath];
            if (self.expertDetailDic.count > 0) {
                [cell setDataDic:self.expertDetailDic];
            }
            
            _expertID = self.expertDetailDic[@"CustomerID"];
            _chatName = self.expertDetailDic[@"CustomerName"];
            
            [cell.tuWenView bk_whenTapped:^{
                // 会员咨询医生之前查询医生的在线状态
                _serviceTypeNum = 1; // ServiceType 服务类型 1图文 2电话
                [self GetIMUserStatuWithHuanXinID:_expertID];
                
                
            }];
            
            
            [cell.PhoneView bk_whenTapped:^{
//                _serviceTypeNum = 2;
//                [self addNewService];
                [self showMessage:@"功能未开通"];
            }];
            
            return cell;
        }
            break;
        case 2:
        {
            ExpertDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"edCell" forIndexPath:indexPath];
            if (self.expertDetailDic.count > 0) {
                [cell setDataDic:self.expertDetailDic];
            }
            return cell;
        }
            break;
        case 3:
        {
            ExpertPingJiaModel *model = self.pingJiaArray[indexPath.row];
            UserPingJiaCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UserPingJiaCell class]) forIndexPath:indexPath];
            [cell setModel:model];
            return cell;
        }
            break;
        case 4:
        {
            ExpertXinYiModel *model = self.xinYiArray[indexPath.row];
            MindWallCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MindWallCell class]) forIndexPath:indexPath];
            [cell setModel:model];
            return cell;
        }
            break;
        default:
        {
            ReplyPostModel *model = self.postArray[indexPath.row];
            
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
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            return 121;
        }
            break;
        case 1:
        {
            return 80;
        }
            break;
        case 2:
        {
            return 100;
        }
            break;
        case 3:
        {
            ExpertPingJiaModel *model = self.pingJiaArray[indexPath.row];
            CGRect contantWidth = [Utils getTextRectWithString:model.Content withWidth:Width_Screen-84 withFontSize:16];
            return 118 + contantWidth.size.height;
        }
            break;
        case 4:
        {
            ExpertXinYiModel *model = self.xinYiArray[indexPath.row];
            CGRect contantWidth = [Utils getTextRectWithString:model.HearInfo withWidth:Width_Screen-84 withFontSize:16];
            return 85 + contantWidth.size.height;
        }
            break;
        default:
        {
            ReplyPostModel *model = self.postArray[indexPath.row];
            
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
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [UIView new];
    header.backgroundColor = [UIColor whiteColor];
    header.userInteractionEnabled = YES;
    
    UIImageView *rightIcon = [UIImageView new];
    rightIcon.image = [UIImage imageNamed:@"小箭头"];
    [header addSubview:rightIcon];
    
    rightIcon.sd_layout.centerYEqualToView(header).rightSpaceToView(header,10).widthIs(7).heightIs(12);
    
    UILabel *rightLab = [UILabel new];
    rightLab.font = [UIFont systemFontOfSize:14];
    rightLab.textColor = [UIColor lightGrayColor];
    rightLab.textAlignment = NSTextAlignmentRight;
    [header addSubview:rightLab];
    
    rightLab.sd_layout.centerYEqualToView(header).rightSpaceToView(rightIcon,5).widthIs(58).heightIs(14);
    
    UILabel *titleLab = [UILabel new];
    titleLab.font = [UIFont systemFontOfSize:16];
    titleLab.textColor = Main_Color;
    [header addSubview:titleLab];
    
    titleLab.sd_layout.centerYEqualToView(header).leftSpaceToView(header,10).rightSpaceToView(rightLab,10).heightIs(16);
    
    if (section == 3) {
        titleLab.text = @"用户评价";
        
        if (self.pingJiaArray.count == 0) {
            rightLab.text = @"暂无信息";
        }
        else {
           rightLab.text = @"查看全部";
        }
        
        [header bk_whenTapped:^{
            ExpertPingJiaListVC *epjlVC = [ExpertPingJiaListVC new];
            epjlVC.ID = self.model.CustomerID;
            [self.navigationController pushViewController:epjlVC animated:YES];
        }];
        
    } else if (section == 4) {
        titleLab.text = @"心意墙";
        
        if (self.xinYiArray.count == 0) {
            rightLab.text = @"暂无信息";
        }
        else {
            rightLab.text = @"查看全部";
        }
        
        [header bk_whenTapped:^{
            ExpertXinYiListVC *exylVC = [ExpertXinYiListVC new];
            exylVC.ID = self.model.CustomerID;
            [self.navigationController pushViewController:exylVC animated:YES];
        }];
        
    } else if (section == 5) {
        titleLab.text = @"医生话题";
        
        if (self.postArray.count == 0) {
            rightLab.text = @"暂无信息";
        }
        else {
            rightLab.text = @"查看全部";
        }
        
        [header bk_whenTapped:^{
            ExpertPostListVC *eplVC = [ExpertPostListVC new];
            eplVC.ID = self.model.CustomerID;
            [self.navigationController pushViewController:eplVC animated:YES];
        }];
    }

    if (section == 3 || section == 4 || section == 5) {
        return header;
    }
    else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 3 || section == 4 || section == 5) {
        return 40;
    }
    else {
        return 0.00001;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

#pragma mark - YHWorkGroupPhotoContainerDelegate
- (void)selectedVideoPushPostDetail:(NSString *)url {
    // 1.获得视频播放的URL
    VideoPlayVC *video = [VideoPlayVC new];
    video.url = url;
    BaseNavigationController *videoNC = [[BaseNavigationController alloc] initWithRootViewController:video];
    [self presentViewController:videoNC animated:YES completion:nil];
}


#pragma mark  点击cell的响应的代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        DoctorInfoViewController *infoVC = [[DoctorInfoViewController alloc] init];
        infoVC.model = self.model;
        infoVC.dataInfo = self.expertDetailDic;
        infoVC.title = self.model.CustomerName;
        [self.navigationController pushViewController:infoVC animated:YES];
    }
}

#pragma mark - 获取专家详情资料
- (void)getExperDetailData {
    NSString *params = [NSString stringWithFormat:@"ZICBDYCCustomerID=%@",self.model.CustomerID];
    NSString *url = @"api/Customer/CustomerBaseInfo";
    
    [self showLoadding:@"正在加载" time:20];
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"获取专家详情 资料 - %@", modelData);
        if (isSuccess) {
            
            NSDictionary *dataDic = modelData[@"JsonData"];
            self.expertDetailDic = [dataDic mutableCopy];
            _tuwenPrice = self.expertDetailDic[@"DocAndPicPrice"];
            NSLog(@"医生的图文咨询价格 - %@", _tuwenPrice);
            
            [self.tableView reloadData];
            
            [self getPingJiaInfoData];
            [self getXinYiInfoData];
            [self getPostInfoData];
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

#pragma mark - 获取专家粉丝 服务人数 收到心意 状态数量
- (void)getExperFuWuNumData {
    NSString *params = [NSString stringWithFormat:@"ZICBDYCCustomerID=%@",self.model.CustomerID];
    NSString *url = @"api/Customer/CustomerBaseInfo";
    
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"获取专家粉丝 服务人数 收到心意 状态数量 - %@", modelData);
        if (isSuccess) {
            NSDictionary *dataDic = modelData[@"JsonData"];
            self.expertDetailDic = [dataDic mutableCopy];
            [self.tableView reloadSection:2 withRowAnimation:UITableViewRowAnimationFade];
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

#pragma mark - 获取评价列表
- (void)getPingJiaInfoData {

    NSString *params = [NSString stringWithFormat:@"ZICBDYCCurPage=%@ZICBDYCPageSize=%@ZICBDYCCustomerID=%@",@"0",@"10",self.model.CustomerID];
    NSString *url = @"api/Customer/CustomerEvaluateLst";
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"获取评价列表 - %@", modelData);
        if (isSuccess) {
            
            [self.pingJiaArray removeAllObjects];
            
            NSArray *dataAry = [modelData objectForKey:@"JsonData"];
            
            NSArray *data = [NSArray modelArrayWithClass:ExpertPingJiaModel.class json:dataAry];
            
            [self.pingJiaArray addObjectsFromArray:data];
            
            [self.tableView reloadSection:3 withRowAnimation:UITableViewRowAnimationFade];
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

#pragma mark - 获取心意列表
- (void)getXinYiInfoData {
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCCurPage=%@ZICBDYCPageSize=%@ZICBDYCCustomerID=%@",@"0",@"10",self.model.CustomerID];
    NSString *url = @"api/Customer/CustomerUMoneyLst";
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"获取心意列表 - %@", modelData);
        if (isSuccess) {
            
            [self.xinYiArray removeAllObjects];
            
            NSArray *dataAry = [modelData objectForKey:@"JsonData"];
            
            NSArray *data = [NSArray modelArrayWithClass:ExpertXinYiModel.class json:dataAry];
            
            [self.xinYiArray addObjectsFromArray:data];

            //刷新心意列表
            [self.tableView reloadSection:4 withRowAnimation:UITableViewRowAnimationFade];
            
            //刷新心意数量
            NSInteger num = self.xinYiArray.count;
            [self.expertDetailDic setValue:@(num) forKey:@"HeartCount"];
            [self.tableView reloadSection:2 withRowAnimation:UITableViewRowAnimationFade];
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

#pragma mark - 获取个人帖子列表
- (void)getPostInfoData {
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCCurPage=%@ZICBDYCPageSize=%@ZICBDYCCustomerID=%@",@"0",@"10",self.model.CustomerID];
    NSString *url = @"api/Post/CustomerPost";
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"获取个人帖子列表 - %@", modelData);
        if (isSuccess) {
            
            [self.postArray removeAllObjects];
            
            NSArray *dataAry = [modelData objectForKey:@"JsonData"];
            
            NSArray *data = [NSArray modelArrayWithClass:ReplyPostModel.class json:dataAry];
            
            [self.postArray addObjectsFromArray:data];
            
            [self.tableView reloadSection:5 withRowAnimation:UITableViewRowAnimationFade];
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

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width_Screen, Height_Screen-64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.backgroundColor = BG_Color;
        _tableView.separatorColor = BG_Color;
        [_tableView registerClass:[TopExpertDetailCell class] forCellReuseIdentifier:NSStringFromClass([TopExpertDetailCell class])];
        [_tableView registerNib:[UINib nibWithNibName:@"ConsultationProjectCell" bundle:nil] forCellReuseIdentifier:@"cpCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"ExpertDataCell" bundle:nil] forCellReuseIdentifier:@"edCell"];
        [_tableView registerClass:[UserPingJiaCell class] forCellReuseIdentifier:NSStringFromClass([UserPingJiaCell class])];
        [_tableView registerClass:[MindWallCell class] forCellReuseIdentifier:NSStringFromClass([MindWallCell class])];
        [_tableView registerClass:[DoctorTopicCell class] forCellReuseIdentifier:NSStringFromClass([DoctorTopicCell class])];
    }
    return _tableView;
}


#pragma mark - 会员咨询医生之前查询医生的在线状态
- (void) GetIMUserStatuWithHuanXinID:(NSString *)huanxinID {
    
    NSString *url = [NSString stringWithFormat:@"%@//api/Customer/GetIMUserStatu", Server_Int_Url];
    NSString *datasStr = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCCustomerID=%@", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI, huanxinID, nil];
    NSString *DataEncrypt = [TWDes encryptWithContent:datasStr type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    NSDictionary *paraDic = @{kToken:token, kDatas:DataEncrypt};
    
    
    [AFManegerHelp POST:url parameters:paraDic success:^(id responseObjeck) {
        NSLog(@"GetIMUserStatu - %@", responseObjeck);
        
        if ([responseObjeck[@"Success"] integerValue] == 1) {
            
            NSDictionary *dic = responseObjeck[@"JsonData"];
            
            if ([dic[@"Online"] integerValue] == 1) {
                NSLog(@"--------在线");
                if (_tuwenPrice.floatValue > 0) {
                    [self alertThing];
                } else {
                    // 调取新增服务的接口api/Customer/CreateCustomerService
                    [self addNewService];
                
                }
                
            } else {
                NSLog(@"-----------不在线");
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示"
                                                                   message:@"您想咨询的医生不在线"
                                                                  delegate:self
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:nil, nil];
                [alertView show];
            }
            
        }else {
            [self showMessage:@"获取医生在线状态失败"];
        }
        
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"cuowu%@", error);
    }];
}

- (void)alertThing {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"支付宝支付" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"支付宝支付");
        [self AliPayWithDocID:_expertID ServiceType:_serviceTypeNum];
    }];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"微信支付" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"微信支付");
        [self WXinPayWithDocID:_expertID ServiceType:_serviceTypeNum];
    }];
    
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"余额支付" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"余额支付");
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确定使用余额支付吗?"
                                                           message:nil
                                                          delegate:self
                                                 cancelButtonTitle:@"取消"
                                                 otherButtonTitles:@"确定", nil];
        [alertView show];
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    
    
    [alert addAction:action2];
    [alert addAction:action3];
    [alert addAction:action4];
    [alert addAction:action1];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}


#pragma mark - 余额支付

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSLog(@"余额 - 确认支付");
        [self RemainPayWithDocID:_expertID ServiceType:_serviceTypeNum];
    }
}

- (void)RemainPayWithDocID:(NSString *)docID ServiceType:(NSInteger)serviceType {
    NSString *url = [NSString stringWithFormat:@"%@/api/MallsInfo/ServiceBalancePay", Server_Int_Url];
    NSString *datasStr = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCDocID=%@ZICBDYCServiceType=%ld", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI, docID, (long)serviceType, nil];
    NSString *DataEncrypt = [TWDes encryptWithContent:datasStr type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    NSDictionary *paraDic = @{kToken:token, kDatas:DataEncrypt};
    
    [AFManegerHelp POST:url parameters:paraDic success:^(id responseObjeck) {
        
        if ([responseObjeck[@"Success"] integerValue] == 1) {
            
            [SVProgressHUD showSuccessWithStatus:@"支付成功"];
            _chatVC = [[ChatViewController alloc] initWithConversationChatter:_expertID
                                                             conversationType:EMConversationTypeChat];
            _chatVC.title = _chatName;
            _chatVC.userid =  _expertID;
//            _chatVC.moneyStr = @"官方提醒：当前聊天由付费模式发起！";
            
            switch (serviceType) {
                case 1:
                    //                    _chatVC.isTextl = YES;
                    [self.navigationController pushViewController:_chatVC animated:YES];
                    break;
                case 2:
                    // (调起本地通话)
                    //                    [self alertPhoneCall];
                    break;
                default:
                    break;
            }
            
            [self getExperFuWuNumData];//刷新列表数据
            
        }else { // 余额不足
            
            [self showMessage:responseObjeck[@"Msg"]];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error - %@", error);
    }];
}


#pragma mark - 微信支付
- (void)WXinPayWithDocID:(NSString *)docID ServiceType:(NSInteger)serviceType {
    
    [SVProgressHUD show];
    
    NSString *url = [NSString stringWithFormat:@"%@/api/MallsInfo/ServiceWxPay", Server_Int_Url];
    NSString *datasStr = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCDocID=%@ZICBDYCServiceType=%ld", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI, docID, (long)serviceType, nil];
    
    NSString *DataEncrypt = [TWDes encryptWithContent:datasStr type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    NSDictionary *paraDic = @{kToken:token, kDatas:DataEncrypt};
    
    [AFManegerHelp POST:url parameters:paraDic success:^(id responseObjeck) {
        NSLog(@"微信支付 - %@", responseObjeck);
        if ([responseObjeck[@"Success"] integerValue] == 1) {
            
            [SVProgressHUD dismiss];
            
            NSDictionary *dic = responseObjeck[@"JsonData"];
            //构造支付请求
            PayReq *request   = [[PayReq alloc]init];
            request.partnerId = [dic objectForKey:@"partnerid"];
            request.prepayId  = [dic objectForKey:@"prepayid"];
            request.package   = [dic objectForKey:@"packages"];
            request.nonceStr  = [dic objectForKey:@"noncestr"];
            request.timeStamp = [[dic objectForKey:@"timestamp"]intValue];
            request.sign = [dic objectForKey:@"sign"];
            [WXApi sendReq:request];
            
        }else {
            
            [SVProgressHUD dismiss];
            [self showMessage:responseObjeck[@"Msg"]];
        }
        
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"cuowu%@", error);
    }];
}



#pragma mark - 支付宝支付 获取支付宝订单号
- (void)AliPayWithDocID:(NSString *)docID ServiceType:(NSInteger)serviceType{
    
    NSString *url = [NSString stringWithFormat:@"%@/api/MallsInfo/ServiceAliPay", Server_Int_Url];
    NSString *datasStr = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCDocID=%@ZICBDYCServiceType=%ld", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI, docID, (long)serviceType, nil];
    NSLog(@"datasStr - %@", datasStr);
    
    NSString *DataEncrypt = [TWDes encryptWithContent:datasStr type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    NSDictionary *paraDic = @{kToken:token, kDatas:DataEncrypt};
    
    [AFManegerHelp POST:url parameters:paraDic success:^(id responseObjeck) {
        
        NSLog(@"支付宝支付 - %@", responseObjeck);
        
        if ([responseObjeck[@"Success"] integerValue] == 1) {
            
            NSDictionary *dic = responseObjeck[@"JsonData"];
            NSString *serviceNO = dic[@"ServiceNO"];
            CGFloat serviceMoney = [dic[@"ServiceMoney"] floatValue];
            
            [self aliPayWithServiceNO:serviceNO ServiceMoney:serviceMoney];
            
        }else {
            
            [self showMessage:responseObjeck[@"Msg"]];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error - %@", error);
    }];
}

#pragma mark - 支付宝支付
- (void)aliPayWithServiceNO:(NSString *)aliPayOrderID ServiceMoney:(CGFloat)serviceMoney{
    
    NSLog(@"支付宝支付");
    
    MyPayOrder * payOrder = [[MyPayOrder alloc] init];
    payOrder.tradeNO = aliPayOrderID;
    payOrder.seller = @"3378128098@qq.com";
    payOrder.partner = @"2088421318655339";
    payOrder.totalMoney = [NSString stringWithFormat:@"%.2f", serviceMoney];
    payOrder.privateKey = @"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAKaSYIA6++s8RKWV6z1QF78RwcDquw7slnjXK16ZAFPSbUW6STwaZIbZiHVJ9UowI06TDLI1nMpkRn69bLZfLyzlTOjwHITx0qUa2sm7AbHkJJGFxrVvsd7djK765kUT1bF6Y7X5ryhkcmG3S/rBB4EBxyR/97KfJ8Y3O1ya0vA9AgMBAAECgYAxO04+WDChBD0d28OdaZC7Llpf1IDZFmAa8y2kVgBcxfL6CuceVoajvKOyVtuiw7uLu7ai7WmcACs9xmrdNCDS39bTSGou6IFJXyZXWwkylYbJHZzbKPmJkKEz8zhyF2p8tXDXKGf0+oaKGKtWIL1tYqwtLBmgmByNNcVzmyfo2QJBANxzboVt1640I7oY3YXGF6Oit9kF7Rpmfksm2MNEE+tYySgamJBwJiqLdvwUWH9IxwdFfm7ooTjBAupPFfNCSS8CQQDBbrp5GF0IMi+ke1CAZmAkvCAxGgJGlrP9tEE2BBTFdrG2axluBATqenSkCxxZHgp27jxpaZ3yG/DrPuLdBKpTAkBsZ2rqvAf6RvNmmMGd/bo0IljrpGliuRHTnMesxbZR3bgVO3bYV/28oBYjgVG/TadpYPf6S/Sztt3bIIa3t1nLAkAC9ptMt57VPU+ViX4WOXtHlMo5dliKlEx1molVNoLK86KNVN6y3MTmgrG+wZzRkLBAWi36v294Ag2SzQfUsvmZAkB0LN/P6BQOGi24VTTVeK1Z1vW2r3zO3hb4yEzSExbdJJ92KW+Bs97n0VQfMh49O+7+gYmjneOYbIgJAMw3Jyr/";
    [self aliPayFor:payOrder];
    
}


//支付宝支付
- (void)aliPayFor:(MyPayOrder *)getOrder
{
    //partner和seller获取失败,提示
    if ([[getOrder partner] length] == 0 ||
        [[getOrder seller] length] == 0 ||
        [[getOrder privateKey] length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = getOrder.partner;
    order.sellerID = getOrder.seller;
    order.outTradeNO = getOrder.tradeNO; //订单ID（由商家自行制定）
    order.subject = @"介入医学服务"; //商品标题
    order.body = @"支付金额"; //商品描述
    order.totalFee = getOrder.totalMoney; //商品价格
    order.notifyURL = [NSString stringWithFormat:@"%@/AlipayNotify/ServiceIndex", Server_Int_Url]; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showURL = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"jieruyixue";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(getOrder.privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            
            
            NSString *codeStr = [resultDic objectForKey:@"resultStatus"];
            
            NSLog(@"resultDic === %@",resultDic);
            // 这块一直不走 网页的支付回调会走这里
            
            if ([codeStr isEqualToString:@"9000"]) {
                
                [self getExperFuWuNumData];//刷新列表数据
                
                [self showImage:SUCCESS_ICON time:1.5 message:@"支付成功"];
                
                _chatVC = [[ChatViewController alloc] initWithConversationChatter:_expertID
                                                                 conversationType:EMConversationTypeChat];
                _chatVC.title = _chatName;
                _chatVC.userid =  _expertID;
                
                NSLog(@"支付宝 - _serviceTypeNum - 1图文咨询 - 2电话咨询 - %ld", (long)_serviceTypeNum);
                switch (_serviceTypeNum) {
                    case 1:
                        //                        _chatVC.isTextl = YES;
                        [self.navigationController pushViewController:_chatVC animated:YES];
                        break;
                    case 2:
                        // (调起本地通话)
                        //                        [self alertPhoneCall];
                        break;
                        
                    default:
                        break;
                }
            }
            else if ([codeStr isEqualToString:@"8000"]) {
                [self showMessage:@"正在处理中..."];
            }
            else if ([codeStr isEqualToString:@"4000"]) {
                [self showImage:FAIL_ICON time:1.5 message:@"充值失败"];
            }
            else if ([codeStr isEqualToString:@"6002"]) {
                [self showImage:FAIL_ICON time:1.5 message:@"网络连接出错"];
            }
            else if ([codeStr isEqualToString:@"6001"]) {
                [self showImage:FAIL_ICON time:1.5 message:@"取消充值"];
            }
            else {
                [self showImage:FAIL_ICON time:1.5 message:@"充值失败"];
            }
            
            NSURL *myUrl = [NSURL URLWithString:@"jieruyixue"];
            if([[UIApplication sharedApplication] canOpenURL:myUrl]){
                [[UIApplication sharedApplication] openURL:myUrl];
            }
            
            
        }];
    }
}


// 支付宝回调  支付成功后 进入订单详情界面
- (void)aliPayCallBack2:(NSNotification *)resultDic {
    
    NSLog(@"resultDic.userInfo - %@", resultDic.userInfo);
    
    NSString *codeStr = resultDic.userInfo[@"resultStatus"];
    
    if ([codeStr isEqualToString:@"9000"]) {

        [self getExperFuWuNumData];//刷新列表数据
        
        [self showImage:SUCCESS_ICON time:1.5 message:@"支付成功"];
        
        _chatVC = [[ChatViewController alloc] initWithConversationChatter:_expertID
                                                         conversationType:EMConversationTypeChat];
        _chatVC.title = _chatName;
        _chatVC.userid =  _expertID;
        
        NSLog(@"支付宝 - _serviceTypeNum - 1图文咨询 - 2电话咨询 - %ld", (long)_serviceTypeNum);
        switch (_serviceTypeNum) {
            case 1:
                [self.navigationController pushViewController:_chatVC animated:YES];
                break;
            case 2:
                // (调起本地通话)
                //                [self alertPhoneCall];
                break;
                
            default:
                break;
        }
    }
    else if ([codeStr isEqualToString:@"8000"]) {
        [self showMessage:@"正在处理中..."];
    }
    else if ([codeStr isEqualToString:@"4000"]) {
        [self showImage:FAIL_ICON time:1.5 message:@"充值失败"];
    }
    else if ([codeStr isEqualToString:@"6002"]) {
        [self showImage:FAIL_ICON time:1.5 message:@"网络连接出错"];
    }
    else if ([codeStr isEqualToString:@"6001"]) {
        [self showImage:FAIL_ICON time:1.5 message:@"取消充值"];
    }
    else {
        [self showImage:FAIL_ICON time:1.5 message:@"充值失败"];
    }
}

// 微信回调 支付成功后 进入订单详情界面
- (void)weixin_pay_result_success2:(NSNotification *)sender {
    
    int code = [sender.object intValue];
    
    switch (code) {
        case 0:
        {
            [self showImage:SUCCESS_ICON time:1.5 message:@"支付成功"];
            
            [self getExperFuWuNumData];//刷新列表数据
            
            NSLog(@"医生服务 - 微信支付成功");
            _chatVC = [[ChatViewController alloc] initWithConversationChatter:_expertID
                                                             conversationType:EMConversationTypeChat];
            _chatVC.title = _chatName;
            _chatVC.userid =  _expertID;
            
            NSLog(@"微信 - _serviceTypeNum - 1图文咨询 - 2电话咨询 - %ld", (long)_serviceTypeNum);
            switch (_serviceTypeNum) {
                case 1:
                    [self.navigationController pushViewController:_chatVC animated:YES];
                    break;
                case 2:
                    // (调起本地通话)
                    //            [self alertPhoneCall];
                    break;
                default:
                    break;
            }
        }
            break;
        case -2:
        {
            [self showImage:FAIL_ICON time:1.5 message:@"退出支付"];
        }
            break;
        default:
        {
            [self showImage:FAIL_ICON time:1.5 message:@"支付失败"];
        }
            break;
    }
    

    
}

- (void)addNewService {
    
    NSString *url = [NSString stringWithFormat:@"%@/api/Customer/CreateCustomerService", Server_Int_Url];
    NSString *datasStr = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCDoctorID=%@ZICBDYCServiceType=%ld", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI, _expertID, (long)_serviceTypeNum, nil];
    
    NSString *DataEncrypt = [TWDes encryptWithContent:datasStr type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    NSDictionary *paraDic = @{kToken:token, kDatas:DataEncrypt};
    
    [SVProgressHUD show];
    [AFManegerHelp POST:url parameters:paraDic success:^(id responseObjeck) {
        
        [SVProgressHUD dismiss];
        NSLog(@"新增服务 - %@", responseObjeck);
        
        if ([responseObjeck[@"Success"] integerValue] == 1) {
            
            [self getExperFuWuNumData];//刷新列表数据
            
            _chatVC = [[ChatViewController alloc] initWithConversationChatter:_expertID
                                                             conversationType:EMConversationTypeChat];
            _chatVC.title = _chatName;
            _chatVC.userid =  _expertID;
            
            [self.navigationController pushViewController:_chatVC animated:YES];
            
        }else {
            [SVProgressHUD dismissWithError:responseObjeck[@"Msg"]];
            NSLog(@"%@", responseObjeck[@"Msg"]);
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismissWithError:@"服务器出错"];
        NSLog(@"error - %@", error);
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
