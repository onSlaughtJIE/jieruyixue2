//
//  WLZ_ShopViewModel.m
//  WLZ_ShoppingCart
//
//  Created by lijiarui on 15/12/14.
//  Copyright © 2015年 lijiarui. All rights reserved.
//

#import "WLZ_ShopViewModel.h"
#import "WLZ_ShoppIngCarModel.h"
#import "MJExtension.h"
@implementation WLZ_ShopViewModel


- (void)getNumPrices:(void (^)()) priceBlock
{
    _priceBlock = priceBlock;
}

#pragma mark - 购物车数据源获取
- (void)getShopData:(void (^)(NSArray * commonArry))shopDataBlock  priceBlock:(void (^)()) priceBlock
{
    
    NSString *url = @"api/MallsInfo/GetShoppingCart";
    NSString *params = @"";
    
    NSMutableArray *commonMuList = [NSMutableArray array];
    __block NSMutableArray *commonList = [NSMutableArray array];

    [BaseNetwork postLoadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        
        NSLog(@"购物车数据源获取 - %@",modelData);
        if (isSuccess) {
            
            [commonMuList removeAllObjects]; // add on 8/2
            
            commonList = modelData[@"JsonData"];
            
            for (int i = 0; i<commonList.count; i++) {
                
                WLZ_ShoppIngCarModel *model = [WLZ_ShoppIngCarModel mj_objectWithKeyValues:[commonList objectAtIndex:i]];
                model.vm = self;
                model.type = 1;
                model.isSelect = YES;
                [commonMuList addObject:model];

            }
            
            if (commonMuList.count>0) {
                
                [commonMuList addObject:[self verificationSelect:commonMuList type:@"1"]];
                
            }
            
            _priceBlock = priceBlock;
            
            //            NSLog(@"commonMuList - %@", commonMuList);
            shopDataBlock(commonMuList);
        }
        else {
            
            shopDataBlock(nil);
            
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


- (NSDictionary *)verificationSelect:(NSMutableArray *)arr type:(NSString *)type
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"YES" forKey:@"checked"];
    [dic setObject:type forKey:@"type"];
    for (int i =0; i<arr.count; i++) {
        WLZ_ShoppIngCarModel *model = (WLZ_ShoppIngCarModel *)[arr objectAtIndex:i];
        if (!model.isSelect) {
            [dic setObject:@"NO" forKey:@"checked"];
            break;
        }
    }
    
    return dic;
}


//点击单个按钮
- (BOOL)pitchOn:(NSMutableArray *)carDataArrList
{
    
    BOOL isCheck =YES;
    for (int i =0; i<carDataArrList.count; i++) {
        NSArray *dataList = [carDataArrList objectAtIndex:i];
        NSMutableDictionary *dic = [dataList lastObject];
         [dic setObject:@"YES" forKey:@"checked"];
        for (int j=0; j<dataList.count-1; j++) {
            WLZ_ShoppIngCarModel *model = (WLZ_ShoppIngCarModel *)[dataList objectAtIndex:j];
            if (!model.isSelect) {
                [dic setObject:@"NO" forKey:@"checked"];
                break;
            }
        }
        if ([[dic objectForKey:@"checked"] isEqualToString:@"NO"]) {
            isCheck = NO;
        }
    }
    return isCheck;
}


//点击item上的全选
-(BOOL)clickAllBT:(NSMutableArray *)carDataArrList bt:(UIButton *)bt {
    bt.selected = !bt.selected;

    BOOL isCheck =YES;
    
//    NSLog(@"carDataArrList.count - %ld", (unsigned long)carDataArrList.count);
 
    for (int i =0; i<carDataArrList.count; i++) {
        NSArray *dataList = [carDataArrList objectAtIndex:i];
        NSMutableDictionary *dic = [dataList lastObject];
        
//        NSLog(@"dataList.count - %ld", (unsigned long)dataList.count);
        
        if (dataList.count != 0) {
            
            for (int j=0; j<dataList.count-1; j++) {
                WLZ_ShoppIngCarModel *model = (WLZ_ShoppIngCarModel *)[dataList objectAtIndex:j];
                if (model.type==1 && bt.tag==100) {
                    if (bt.selected) {
                        [dic setObject:@"YES" forKey:@"checked"];
                    }
                    else
                    {
                        [dic setObject:@"NO" forKey:@"checked"];
                    }
                    
                    model.isSelect=bt.selected;
                    
                }
            }
        }

        if ([[dic objectForKey:@"checked"] isEqualToString:@"NO"]) {
            isCheck = NO;
        }
        
    }
    return isCheck;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    NSLog(@"开始计算价钱");
    if ([keyPath isEqualToString:@"isSelect"]) {
        if (_priceBlock!=nil) {
             _priceBlock();
        }
       
    }
}

@end
