//
//  WLZ_ShoppingCarController.m
//  WLZ_ShoppingCart
//
//  Created by lijiarui on 15/12/14.
//  Copyright © 2015年 lijiarui. All rights reserved.
//


//   MVVM (降低耦合) KVO(一处计算总价钱) 键盘处理(精确到每个cell) 代码适配(手动代码适配，无第三方) ，还有全选,侧滑操作等操作，仅供大家参考交流

#import "WLZ_ShoppingCarController.h"
#import "WLZ_HeardView.h"
//#import "WLZ_JieSuanViewController.h"
#import "GoodRootViewController.h"
#import "Masonry.h"

#import "FillInOrderVC.h"

#import "IQKeyboardManager.h"

#import "JRLoginViewController.h"

@interface WLZ_ShoppingCarController () <UITableViewDataSource,UITableViewDelegate,WLZ_ShoppingCarCellDelegate,WLZ_ShoppingCartEndViewDelegate>

{
    MBProgressHUD *HUD;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *carDataArrList;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIBarButtonItem *previousBarButton;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, strong) WLZ_ShoppingCartEndView *endView;
@property (nonatomic, strong) WLZ_ShopViewModel *vm;

@property (nonatomic, strong) NSMutableArray *commodityArray;

//pitchOn

@end

@implementation WLZ_ShoppingCarController {
    
    NSString *_totalPrice;//总价钱
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"购物车";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.endView];
    
    self.commodityArray = [NSMutableArray arrayWithCapacity:0];
    
//    [self finshBarView];
    [self loadNotificationCell];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payOrderReturnClick) name:@"payOrderReturn" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fromShoppingComeClick) name:@"fromShoppingCome" object:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(edits:)];
    
    //获取数据
    _vm = [[WLZ_ShopViewModel alloc]init];
    [self refreshShoppingData:200];//刷新购物车
}

#pragma mark - 购物车跳转详情页面添加购物车操作
- (void)fromShoppingComeClick {
    [self refreshShoppingData:200];
}

#pragma mark - 购买后返回购物车 刷新
- (void)payOrderReturnClick {
    [self refreshShoppingData:100];
}

#pragma mark - 购物车 刷新
- (void)refreshShoppingData:(NSInteger)isAllSelect {
    //获取数据
    __weak typeof (WLZ_ShoppingCarController) *waks = self;
    __weak typeof (NSMutableArray)* carDataArrList = self.carDataArrList;
    __weak typeof (UITableView ) *tableView = self.tableView;
    
    [_vm getShopData:^(NSArray *commonArry) {
        
        [self.hud hide:YES];
        
        NSLog(@"commonArry - %@", commonArry);
        NSLog(@"commonArry.count - %lu", (unsigned long)commonArry.count);
        
        [carDataArrList removeAllObjects]; // add on 8/2
        
        [carDataArrList addObject:commonArry];
        
        [tableView reloadData];
        
        if (commonArry.count != 0) {
            
            [waks numPrice];
            
            if (isAllSelect == 100) {
                self.endView.checkbt.selected = YES;
            }
        }
        
        if (commonArry.count == 0) {
            
            self.navigationItem.rightBarButtonItem = nil;
            
            UIView *emptyView = [[UIView alloc] initWithFrame:self.view.bounds];
            emptyView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:emptyView];
            
            UIImageView *topShopping = [UIImageView new];
            topShopping.image = [UIImage imageNamed:@"konggwc"];
            [emptyView addSubview:topShopping];
            topShopping.sd_layout.centerXEqualToView(emptyView).topSpaceToView(emptyView,Height_Screen/2-100).widthIs(30).heightIs(30);
            
            UILabel *lable1 = [[UILabel alloc] init];
            lable1.text = @"购物车空空的,";
            lable1.textColor = [UIColor lightGrayColor];
            lable1.font = [UIFont systemFontOfSize:14];
            lable1.textAlignment = NSTextAlignmentRight;
            [emptyView addSubview:lable1];
            lable1.sd_layout.topSpaceToView(topShopping,10).leftSpaceToView(emptyView,Width_Screen/2-85).heightIs(14).widthIs(90);
            
            UIButton *button1 = [UIButton buttonWithType:(UIButtonTypeSystem)];
            [button1 setTitle:@"去商城逛逛" forState:(UIControlStateNormal)];
            button1.tintColor = [UIColor redColor];
            button1.titleLabel.font = [UIFont systemFontOfSize:14];
            button1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [button1 addTarget:self action:@selector(gotoShp:) forControlEvents:(UIControlEventTouchUpInside)];
            [emptyView addSubview:button1];
            button1.sd_layout.topSpaceToView(topShopping,10).leftSpaceToView(lable1,0).heightIs(14).widthIs(80);
        }
        
    } priceBlock:^{
        [waks numPrice];
    }];
}

- (void)gotoShp:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// 貌似没用
-(void)finshBarView {
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, APPScreenHeight, APPScreenWidth, 44)];
    // _toolbar.frame = CGRectMake(0, 0, APPScreenWidth, 44);
    [_toolbar setBarStyle:UIBarStyleDefault];
    
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.previousBarButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(previousButtonIsClicked:)];
    NSArray *barButtonItems = @[flexBarButton,self.previousBarButton];
    _toolbar.items = barButtonItems;
    [self.view addSubview:_toolbar];
}

- (void) previousButtonIsClicked:(id)sender {
    [self.view endEditing:YES];
}

-(void)loadNotificationCell
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];

}

//本来想着kvo写在 Controller里面 但是想尝试不同的方式 试试在viewModel 里面 ，感觉还是在Controller 里面更 好点

- (void)numPrice {
    
    NSArray *lists =   [self.endView.Lab.text componentsSeparatedByString:@"￥"];
    float num = 0.00;
    for (int i=0; i<self.carDataArrList.count; i++) {
        NSArray *list = [self.carDataArrList objectAtIndex:i];
        for (int j = 0; j<list.count-1; j++) {
            WLZ_ShoppIngCarModel *model = [list objectAtIndex:j];
            NSInteger count = model.Number ;
            float sale = model.PromotionPrice ;
            if (model.isSelect) {
                num = count * sale + num;
            }
        }
    }
    self.endView.Lab.text = [NSString stringWithFormat:@"%@￥%.2f",lists[0],num];
    _totalPrice = [NSString stringWithFormat:@"%.2f",num];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    WLZ_ShoppIngCarModel *model;
    for (int i = 0; i<_carDataArrList.count; i++) {
     
     NSMutableArray *arry = [_carDataArrList objectAtIndex:i];
     
        if (arry.count > 0) {
 
              model = [arry objectAtIndex:indexPath.row];
  
        }
     
     }

    GoodRootViewController *dvc = [[GoodRootViewController alloc]init];
    dvc.commodityID = [NSString stringWithFormat:@"%ld",model.CommodityID];
    dvc.exchangeID = @"0";
    dvc.from = 1000;
    dvc.isShowTool = 300;//购物车
    [self.navigationController pushViewController:dvc animated:YES];
}

-(WLZ_ShoppingCartEndView *)endView {
    if (!_endView) {
        _endView = [[WLZ_ShoppingCartEndView alloc]initWithFrame:CGRectMake(0, APPScreenHeight-[WLZ_ShoppingCartEndView getViewHeight]-64, APPScreenWidth, [WLZ_ShoppingCartEndView getViewHeight])];
        _endView.delegate = self;
        _endView.isEdit = _isEdit;
        _endView.backgroundColor = BG_Color;
        _endView.layer.shadowColor = RGB(100, 100, 100).CGColor;//阴影颜色
        _endView.layer.shadowOffset = CGSizeMake(0 , 1);//偏移距离
        _endView.layer.shadowOpacity = 0.5;//不透明度
        _endView.layer.shadowRadius = 3.0;//半径
    }
    return _endView;
}

- (void)clickALLEnd:(UIButton *)bt {
    //全选 也可以在 VM里面 写  这次在Controller里面写了
    NSLog(@"全选了");
    NSMutableArray *arry = [_carDataArrList objectAtIndex:0];
//    NSLog(@"arry -- %@", arry);
    if (arry.count == 0) {
        NSLog(@"没商品,不能全选");
        return;
    }
    
    //
    bt.selected = !bt.selected;
    
    BOOL btselected = bt.selected;
    
    NSString *checked = @"";
    if (btselected) {
        checked = @"YES";
    }
    else
    {
        checked = @"NO";
    }
    
    if (self.isEdit) {
        //取消
        for (int i =0; i<_carDataArrList.count; i++) {
            NSArray *dataList = [_carDataArrList objectAtIndex:i];
            NSMutableDictionary *dic = [dataList lastObject];
            [dic setObject:checked forKey:@"checked"];
            
            for (int j=0; j<dataList.count-1; j++) {
                WLZ_ShoppIngCarModel *model = (WLZ_ShoppIngCarModel *)[dataList objectAtIndex:j];
                model.isSelect=btselected;
       
            }
        }
    }
    else
    {
        //编辑
        
        for (int i =0; i<_carDataArrList.count; i++) {
            NSArray *dataList = [_carDataArrList objectAtIndex:i];
            NSMutableDictionary *dic = [dataList lastObject];
            [dic setObject:checked forKey:@"checked"];
            
            for (int j=0; j<dataList.count-1; j++) {
                WLZ_ShoppIngCarModel *model = (WLZ_ShoppIngCarModel *)[dataList objectAtIndex:j];
                model.isSelect=btselected;
            }
        }
    }
    [_tableView reloadData];
}

- (void)clickRightBT:(UIButton *)bt
{
    if(bt.tag==19)
    {
        //删除
        NSMutableIndexSet *bigIndexSet = [[NSMutableIndexSet alloc]init];
        for (int i = 0; i<_carDataArrList.count; i++) {
            NSMutableArray *arry = [_carDataArrList objectAtIndex:i];
            NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc]init];
            for (int j=0 ; j<arry.count-1; j++) {
                WLZ_ShoppIngCarModel *model = [ arry objectAtIndex:j];
                
                if (model.isSelect==YES) {

                    [indexSet addIndex:j];
                    
                    [self deleteGoodFromList:model]; // add
                }
            }
            [arry removeObjectsAtIndexes:indexSet];
            
            if (arry.count<=1) {

                [bigIndexSet addIndex:i];
                
            }
        }
        
        [_carDataArrList removeObjectsAtIndexes:bigIndexSet];
        
        
        [_tableView reloadData];
    }
    else if (bt.tag==18)
    {
        //结算
        
        [self.commodityArray removeAllObjects];
        
        for (int i = 0; i<_carDataArrList.count; i++) {
            
            NSMutableArray *arry = [_carDataArrList objectAtIndex:i];
            
            if (arry.count > 0) {
                for (int j=0 ; j<arry.count-1; j++) {
                    WLZ_ShoppIngCarModel *model = [arry objectAtIndex:j];
                    if (model.isSelect) {  //  add
                        
                        NSString *ID = [NSString stringWithFormat:@"%ld",model.CommodityID];
                        NSString *num = [NSString stringWithFormat:@"%ld",model.Number];
                        
                        NSDictionary *commodityDic = @{@"CommodityID":ID,
                                                       @"Name":model.Name,
                                                       @"Pic":model.Pic1,
                                                       @"totalPrice":_totalPrice,
                                                       @"Num":num};
                        
                        [self.commodityArray addObject:commodityDic];
                    }
                }
            }
        }
        
        if (self.commodityArray.count > 0) {
            FillInOrderVC *orderVC = [FillInOrderVC new];
            orderVC.commodityAry = self.commodityArray;
            orderVC.from = @"购物车";
            [self.navigationController pushViewController:orderVC animated:YES];
        }
        else {
            [self showMessage:@"您没有选中任何商品"];
        }
    }
}
- (void)edits:(UIBarButtonItem *)item
{
    if (_carDataArrList.count > 0) {
        NSMutableArray *arry = [_carDataArrList objectAtIndex:0];
        //    NSLog(@"arry -- %@", arry);
        if (arry.count == 0) {
            NSLog(@"没商品,不能编辑");
            return;
        }
    }

    self.isEdit = !self.isEdit;
    if (self.isEdit) {
        item.title = @"取消";
        for (int i=0; i<_carDataArrList.count; i++) {
            NSArray *list = [_carDataArrList objectAtIndex:i];
            for (int j = 0; j<list.count-1; j++) {
                WLZ_ShoppIngCarModel *model = [list objectAtIndex:j];
                    model.isSelect=YES;
            }
        }
    }
    else{
        item.title = @"编辑";
        for (int i=0; i<_carDataArrList.count; i++) {
            NSArray *list = [_carDataArrList objectAtIndex:i];
            for (int j = 0; j<list.count-1; j++) {
                WLZ_ShoppIngCarModel *model = [list objectAtIndex:j];
                model.isSelect = YES;
            }
        }
        
        
    }
    
    self.endView.isEdit = self.isEdit;
    
    [self.endView.checkbt setSelected:[_vm pitchOn:_carDataArrList]];
    [_tableView reloadData];
}

- (NSMutableArray *)carDataArrList
{
    if (!_carDataArrList) {
        _carDataArrList = [NSMutableArray array];
    }
    return _carDataArrList;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, APPScreenWidth, APPScreenHeight-[WLZ_ShoppingCartEndView getViewHeight]) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.userInteractionEnabled=YES;
        _tableView.dataSource = self;
        _tableView.scrollsToTop=YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = BG_Color;
        
        UIView *footView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, Width_Screen, 60))];
        _tableView.tableFooterView = footView;
        
    }
    return _tableView;
}

- (void)endViewHidden {
    if (_carDataArrList.count==0) {
        self.endView.hidden=YES;
    }
    else
    {
        self.endView.hidden=NO;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    [self endViewHidden];
    return self.carDataArrList.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSArray *list = [self.carDataArrList objectAtIndex:section];
    return list.count-1;
 
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 50;
    }
    else
    {
        return 40;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    __weak typeof(WLZ_ShopViewModel ) *vm = _vm;
    __weak typeof (NSMutableArray ) *carDataArrList = _carDataArrList;
    __weak typeof (UITableView ) *tableViews = _tableView;
     __weak typeof (WLZ_ShoppingCartEndView ) *endView = self.endView;
    WLZ_HeardView * heardView =[[WLZ_HeardView alloc]initWithFrame:CGRectMake(0, 0, APPScreenWidth, 40) section:section carDataArrList:_carDataArrList block:^(UIButton *bt) {
     [endView.checkbt setSelected:   [vm clickAllBT:carDataArrList bt:bt]];
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:bt.tag-100];
        [tableViews reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    }];
    heardView.tag = 1999+section;
    heardView.backgroundColor=[UIColor whiteColor];
    return heardView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [WLZ_ShoppingCarCell getHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"self.carDataArrList - %@", self.carDataArrList);
    
    static NSString *shoppingCaridentis = @"WLZ_ShoppingCarCells";
    WLZ_ShoppingCarCell *cell = [tableView dequeueReusableCellWithIdentifier:shoppingCaridentis];
    if (!cell) {
        cell = [[WLZ_ShoppingCarCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:shoppingCaridentis tableView:tableView];
        cell.delegate=self;
    }
    if (self.carDataArrList.count > 0) {
        cell.isEdit = self.isEdit;
        NSArray *list = [self.carDataArrList objectAtIndex:indexPath.section];
        cell.row = indexPath.row+1;
        [cell setModel:[list objectAtIndex:indexPath.row]];
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
        if (list.count-2 !=indexPath.row) {
            UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(45, [WLZ_ShoppingCarCell getHeight]-0.5, APPScreenWidth-45, 0.5)];
            line.backgroundColor=[UIColor colorFromHexRGB:@"e2e2e2"];
            [cell addSubview:line];
        }
    }
    return cell;
}

- (void)singleClick:(WLZ_ShoppIngCarModel *)models row:(NSInteger)row
{
      [self.endView.checkbt setSelected:[_vm pitchOn:_carDataArrList]];
    if (models.type==1) {
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    }
//    else if(models.type==2)
//    {
//        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
//    }
    
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        NSMutableArray *list = [_carDataArrList objectAtIndex:indexPath.section];
        
        WLZ_ShoppIngCarModel *model = [ list objectAtIndex:indexPath.row];
        model.isSelect=NO;
        [list removeObjectAtIndex:indexPath.row];
        
        if (list.count==1) {
            
            [_carDataArrList removeObjectAtIndex:indexPath.section];
            
        }
        
        [self deleteGoodFromList:model]; // add
        
        [_tableView reloadData];
    }
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"payOrderReturn" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"fromShoppingCome" object:nil];
    
    _tableView = nil;
    _tableView.dataSource=nil;
    _tableView.delegate=nil;
    self.vm = nil;
    self.endView = nil;
    self.carDataArrList = nil;
    NSLog(@"Controller释放了。。。。。");
}

- (void)keyboardWillShow:(NSNotification *)notif {
    if (self.view.hidden == YES) {
        return;
    }
    
    CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat y = rect.origin.y;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    NSArray *subviews = [self.view subviews];
    for (UIView *sub in subviews) {
        CGFloat maxY = CGRectGetMaxY(sub.frame);
        if ([sub isKindOfClass:[UITableView class]]) {

                sub.frame = CGRectMake(0, 0, sub.frame.size.width, APPScreenHeight-_toolbar.frame.size.height-rect.size.height);
                sub.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.0, sub.frame.size.height/2);

        }else{
            if (maxY > y - 2) {
                sub.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.0, sub.center.y - maxY + y );
            }
        }
    }
    [UIView commitAnimations];
}

- (void)keyboardShow:(NSNotification *)notif {
    if (self.view.hidden == YES) {
        return;
    }
}

- (void)keyboardWillHide:(NSNotification *)notif {
    if (self.view.hidden == YES) {
        return;
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    NSArray *subviews = [self.view subviews];
    for (UIView *sub in subviews) {
        if (sub.center.y < CGRectGetHeight(self.view.frame)/2.0) {
            sub.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.0, CGRectGetHeight(self.view.frame)/2.0);
        }
    }
      _toolbar.frame=CGRectMake(0, APPScreenHeight, APPScreenWidth, _toolbar.frame.size.height);
    self.endView.frame = CGRectMake(0, self.view.frame.size.height-self.endView.frame.size.height, APPScreenWidth, self.endView.frame.size.height);

    self.tableView.frame=CGRectMake(0, 0, self.tableView.frame.size.width, APPScreenHeight-[WLZ_ShoppingCartEndView getViewHeight]);
    [UIView commitAnimations];
}

- (void)keyboardHide:(NSNotification *)notif {
    if (self.view.hidden == YES) {
        return;
    }
}

- (void)deleteGoodFromList:(WLZ_ShoppIngCarModel *)model {
    // add
    
    NSString *url = @"api/MallsInfo/DeleteShoppingCart";
    NSString *params = [NSString stringWithFormat:@"ZICBDYCID=%ld",(long)model.ID];
    
    [self showLoadding:@"" time:20];
    [BaseNetwork postLoadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        
        [self.hud hide:YES];
        
        NSLog(@"商品删除 - %@",modelData);
        if (isSuccess) {
            NSLog(@"删除成功");
            
            if (self.carDataArrList.count == 0) {
                
                self.navigationItem.rightBarButtonItem = nil;
                
                UIView *emptyView = [[UIView alloc] initWithFrame:self.view.bounds];
                emptyView.backgroundColor = [UIColor whiteColor];
                [self.view addSubview:emptyView];
                
                UIImageView *topShopping = [UIImageView new];
                topShopping.image = [UIImage imageNamed:@"konggwc"];
                [emptyView addSubview:topShopping];
                topShopping.sd_layout.centerXEqualToView(emptyView).topSpaceToView(emptyView,Height_Screen/2-100).widthIs(30).heightIs(30);
                
                UILabel *lable1 = [[UILabel alloc] init];
                lable1.text = @"购物车空空的,";
                lable1.textColor = [UIColor lightGrayColor];
                lable1.font = [UIFont systemFontOfSize:14];
                lable1.textAlignment = NSTextAlignmentRight;
                [emptyView addSubview:lable1];
                lable1.sd_layout.topSpaceToView(topShopping,10).leftSpaceToView(emptyView,Width_Screen/2-85).heightIs(14).widthIs(90);
                
                UIButton *button1 = [UIButton buttonWithType:(UIButtonTypeSystem)];
                [button1 setTitle:@"去商城逛逛" forState:(UIControlStateNormal)];
                button1.tintColor = [UIColor redColor];
                button1.titleLabel.font = [UIFont systemFontOfSize:14];
                button1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [button1 addTarget:self action:@selector(gotoShp:) forControlEvents:(UIControlEventTouchUpInside)];
                [emptyView addSubview:button1];
                button1.sd_layout.topSpaceToView(topShopping,10).leftSpaceToView(lable1,0).heightIs(14).widthIs(80);
            }
            
        }
        else {
            if (code == 999) {
                [self showMessage:@"服务器开小差了~请稍后再试"];
                return ;
            }
            NSString *msg  = [modelData objectForKey:@"Msg"];
            if (msg!=nil && ![msg isEqual:@""]) {
                [self showMessage:msg];
                if (code == 3) {
                    
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
            else{
                [self showMessage:[NSString stringWithFormat:@"请求失败 #%d",code]];
            }
        }
    }];
}
@end
