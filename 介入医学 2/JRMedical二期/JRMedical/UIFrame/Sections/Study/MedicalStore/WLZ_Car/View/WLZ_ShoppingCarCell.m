//
//  WLZ_ShoppingCarCell.m
//  WLZ_ShoppingCart
//
//  Created by lijiarui on 15/12/14.
//  Copyright © 2015年 lijiarui. All rights reserved.
//

#import "WLZ_ShoppingCarCell.h"
#import "UIImageView+WebCache.h"
#import "WLZ_ShoppingCarController.h"
#import "UIColor+WLZ_HexRGB.h"

static CGFloat CELL_HEIGHT = 120;

@interface WLZ_ShoppingCarCell () <UITextFieldDelegate>

@property(nonatomic,strong)UIButton *selectBt;
@property(nonatomic,strong)UIImageView *shoppingImgView;
@property(nonatomic,strong)UIImageView *spuImgView;
@property(nonatomic,strong)UILabel *title ;
@property(nonatomic,strong)WLZ_ChangeCountView *changeView;
@property(nonatomic,strong)UILabel *priceLab;
@property(nonatomic,strong)UILabel *sizeLab;

@property(nonatomic,assign)CGRect tableVieFrame;

@property(nonatomic,strong)UILabel *soldoutLab;

@end

@implementation WLZ_ShoppingCarCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    _soldoutLab.hidden=YES;
    [_shoppingImgView sd_setImageWithURL:nil];
    [_changeView removeFromSuperview];
    _spuImgView.image = nil;
    _changeView = nil;
    _sizeLab.text = nil;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier tableView:(UITableView *)tableView
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        _tableView = tableView;
        [self initCellView];
    }
    return self;
}
- (void)initCellView
{
    
    UIImage *btimg = [UIImage imageNamed:@"weixuan"];
    UIImage *selectImg = [UIImage imageNamed:@"duidui"];
    
    _selectBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, btimg.size.width+20, CELL_HEIGHT)];
    [_selectBt addTarget:self action:@selector(clickSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_selectBt setImage:btimg forState:UIControlStateNormal];
    [_selectBt setImage:selectImg forState:UIControlStateSelected];
    [self.contentView addSubview:_selectBt];
    
    _shoppingImgView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_selectBt.frame)+7, 15, 80, 90)];
    _shoppingImgView.clipsToBounds = YES;
    _shoppingImgView.contentMode = UIViewContentModeScaleAspectFill;
    _shoppingImgView.layer.borderColor = RGB(180, 180, 180).CGColor;
    _shoppingImgView.layer.cornerRadius = 3;
    _shoppingImgView.layer.borderWidth = 0.4;
    [self.contentView addSubview:_shoppingImgView];
    
    _spuImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [_shoppingImgView addSubview:_spuImgView];
    
    _title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_shoppingImgView.frame)+10, 15, APPScreenWidth-CGRectGetMaxX(_shoppingImgView.frame)-15, 34)];
    _title.font = [UIFont systemFontOfSize:14];
    _title.numberOfLines = 0;
    _title.textColor = [UIColor colorFromHexRGB:@"666666"];

    [self.contentView addSubview:_title];
    
    
    _sizeLab = [[UILabel alloc] initWithFrame:CGRectMake(_title.frame.origin.x, CGRectGetMaxY(_title.frame), 200, 17)];
    _sizeLab.font = [UIFont systemFontOfSize:12];
    _sizeLab.textColor = [UIColor colorFromHexRGB:@"666666"];
    [self.contentView addSubview:_sizeLab];
    
    _soldoutLab = [[UILabel alloc]initWithFrame:CGRectMake(_title.frame.origin.x, CGRectGetMaxY(_sizeLab.frame)+15, 100, 17)];
    _soldoutLab.hidden = YES;
    _soldoutLab.text = @"无货";
    _soldoutLab.font =  [UIFont systemFontOfSize:14];
    _soldoutLab.textColor = [UIColor colorFromHexRGB:@"666666"];
    [self.contentView addSubview:_soldoutLab];
    
    _priceLab = [[UILabel alloc]initWithFrame:CGRectMake(APPScreenWidth-18-100, CGRectGetMaxY(_sizeLab.frame)+5+5, 100, 17)];
    _priceLab.textAlignment = NSTextAlignmentRight;
    _priceLab.font = [UIFont systemFontOfSize:14];
    _priceLab.textColor = RGB(232, 78, 64);
    [self.contentView addSubview:_priceLab];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _changeView.numberFD = textField;
    if ([self isPureInt:_changeView.numberFD.text]) {
        if ([_changeView.numberFD.text integerValue]<0) {
            _changeView.numberFD.text = @"1";
        }
    }
    else
    {
        _changeView.numberFD.text = @"1";
    }
    
    if ([_changeView.numberFD.text isEqualToString:@""] || [_changeView.numberFD.text isEqualToString:@"0"]) {
        self.choosedCount = 1;
        _changeView.numberFD.text = @"1";
    }
    NSString *numText = _changeView.numberFD.text;
    
    if ([numText intValue] >10000) {
        [SVProgressHUD showErrorWithStatus:@"最多支持购买10000个"];
        _changeView.numberFD.text = @"10000";
    }
    
    _changeView.addButton.enabled = YES;
    _changeView.subButton.enabled = YES;
    
    NSString *url = @"api/MallsInfo/AddShoppingCart";
    NSString *params = [NSString stringWithFormat:@"ZICBDYCCommodityID=%ldZICBDYCNumber=%ld",(long)_model.CommodityID, [_changeView.numberFD.text integerValue]];
    
    [BaseNetwork postLoadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        
        NSLog(@"手动输入数量加购物车商品数量 - %@",modelData);
        if (isSuccess) {
            
            self.choosedCount = [_changeView.numberFD.text integerValue];
            NSLog(@"self.choosedCount - %ld", (long)self.choosedCount);
            
            _changeView.numberFD.text=[NSString stringWithFormat:@"%zi",self.choosedCount];
            _model.Number = [_changeView.numberFD.text integerValue];
            _model.isSelect=_selectBt.selected;
        }
        else {
            if (code == 999) {
                //[self alert:@"服务器错误!"];
                NSLog(@"服务器错误!");
                return ;
            }
            NSString *msg  = [modelData objectForKey:@"Msg"];
            if (msg!=nil && ![msg isEqual:@""]) {
                NSLog(@"%@",msg);
            }else{
                NSLog(@"%@",[NSString stringWithFormat:@"请求失败 #%d",code]);
            }
        }
    }];

//    self.choosedCount = [_changeView.numberFD.text integerValue];
//    _model.Number = [_changeView.numberFD.text integerValue];
//    _model.isSelect = _selectBt.selected;
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}


- (void)setModel:(WLZ_ShoppIngCarModel *)model
{
    
//     NSLog(@"model.Name - %@", model.Name);
    
    _model = model;
    _selectBt.selected=model.isSelect;
    if (_changeView.numberFD.text) {
        self.choosedCount = [_changeView.numberFD.text integerValue];
    }
    else{
        self.choosedCount = model.Number;
    }

    [_shoppingImgView sd_setImageWithURL:[NSURL URLWithString:model.Pic1] placeholderImage:[UIImage imageNamed:@"jiazai"]];
 
    _priceLab.text=[NSString stringWithFormat:@"￥%.2f",model.PromotionPrice];

    _title.text= model.Name;
    
    _selectBt.enabled=YES;
    _changeView = [[WLZ_ChangeCountView alloc] initWithFrame:CGRectMake(_title.frame.origin.x, CGRectGetMaxY(_sizeLab.frame)+5, 160, 35) chooseCount:self.choosedCount totalCount: 10001];
    
    [_changeView.subButton addTarget:self action:@selector(subButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _changeView.numberFD.delegate = self;
    
    [_changeView.addButton addTarget:self action:@selector(addButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:_changeView];
}
//加
- (void)addButtonPressed:(id)sender
{
    NSLog(@"加入购物车");
//    NSLog(@" 777 model.Name - %@", _model.Name);
//    ++self.choosedCount ;
    
    if (self.choosedCount>0) {
        _changeView.subButton.enabled=YES;
    }
    
    
    if(self.choosedCount>=10000)
    {
        self.choosedCount  = 10000;
        _changeView.addButton.enabled = NO;
        return;
    }
    
//    _changeView.numberFD.text=[NSString stringWithFormat:@"%zi",self.choosedCount];
//    
//    _model.Number = [_changeView.numberFD.text integerValue];
    
//    _model.isSelect=_selectBt.selected;
    
    NSString *url = @"api/MallsInfo/AddShoppingCart";
    NSString *params = [NSString stringWithFormat:@"ZICBDYCCommodityID=%ldZICBDYCNumber=%d",(long)_model.CommodityID, 1];
    
    [BaseNetwork postLoadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        
        NSLog(@"减添加购物车商品数量+1 - %@",modelData);
        if (isSuccess) {
            //            NSLog(@"数量加一个");
            ++self.choosedCount ;
            //            NSLog(@"self.choosedCount - %ld", (long)self.choosedCount);
            
            _changeView.numberFD.text=[NSString stringWithFormat:@"%zi",self.choosedCount];
            
            _model.Number = [_changeView.numberFD.text integerValue];
            
            _model.isSelect=_selectBt.selected;
        }
        else {
            if (code == 999) {
                //[self alert:@"服务器错误!"];
                NSLog(@"服务器错误!");
                return ;
            }
            NSString *msg  = [modelData objectForKey:@"Msg"];
            if (msg!=nil && ![msg isEqual:@""]) {
                NSLog(@"%@",msg);
            }else{
                NSLog(@"%@",[NSString stringWithFormat:@"请求失败 #%d",code]);
            }
        }
    }];
}


-(void)clickSelect:(UIButton *)bt
{
    
    //  _selectBt.selected = !_selectBt.selected;
    if (!_soldoutLab.hidden && !self.isEdit) {
        return;
    }
    _selectBt.selected = !_selectBt.selected;
    _model.isSelect = _selectBt.selected;
    
    if (_changeView.numberFD.text!=nil) {
        _model.Number = [_changeView.numberFD.text integerValue];
    }
    
    [self.delegate singleClick:_model row:self.row];
}

//减
- (void)subButtonPressed:(id)sender
{

//    -- self.choosedCount ;
    
    if (self.choosedCount==1) {
        self.choosedCount= 1;
        _changeView.subButton.enabled=NO;
        return;
    }
    else
    {
        _changeView.addButton.enabled=YES;
        
    }
//    _changeView.numberFD.text=[NSString stringWithFormat:@"%zi",self.choosedCount];
//    
//    _model.Number = [_changeView.numberFD.text integerValue];
    
//    _model.isSelect=_selectBt.selected;
    
    NSString *url = @"api/MallsInfo/AddShoppingCart";
    NSString *params = [NSString stringWithFormat:@"ZICBDYCCommodityID=%ldZICBDYCNumber=%d",(long)_model.CommodityID, -1];
    
    [BaseNetwork postLoadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        
        NSLog(@"减去购购物车商品数量-1 - %@",modelData);
        if (isSuccess) {
            //            NSLog(@"商品数量减一个");
            -- self.choosedCount;
            //            NSLog(@"self.choosedCount - %ld", (long)self.choosedCount);
            
            _changeView.numberFD.text=[NSString stringWithFormat:@"%zi",self.choosedCount];
            
            _model.Number = [_changeView.numberFD.text integerValue];
            
            _model.isSelect=_selectBt.selected;
        }
        else {
            if (code == 999) {
                //[self alert:@"服务器错误!"];
                NSLog(@"服务器错误!");
                return ;
            }
            NSString *msg  = [modelData objectForKey:@"Msg"];
            if (msg!=nil && ![msg isEqual:@""]) {
                NSLog(@"%@",msg);
            }else{
                NSLog(@"%@",[NSString stringWithFormat:@"请求失败 #%d",code]);
            }
        }
    }];
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


+(CGFloat)getHeight
{
    return CELL_HEIGHT;
}

@end
