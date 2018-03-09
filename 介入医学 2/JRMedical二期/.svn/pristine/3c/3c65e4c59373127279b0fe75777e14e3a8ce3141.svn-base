//
//  HosShuruViewController.m
//  JRMedical
//
//  Created by apple on 16/7/19.
//  Copyright © 2016年 ZC. All rights reserved.
//

#import "HosShuruViewController.h"
#import "MyCertificationVC.h"
#import <YYKit.h>

@interface HosShuruViewController ()

@property (weak, nonatomic) IBOutlet UITextField *shuruTf;

@end

@implementation HosShuruViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"手动输入医院名称";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:(UIBarButtonItemStylePlain) target:self action:@selector(saveHos)];
}

- (void)saveHos {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [dic setObject:_shuruTf.text forKey:@"hosName"];
    [dic setObject:_AreaID  forKey:@"hosID"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"passHosShouShu" object:nil userInfo:dic];
    
    NSArray * ctrlArray = self.navigationController.viewControllers;
    
//    [self.navigationController popToViewController:[ctrlArray objectAtIndex:2] animated:YES];
    
    NSInteger renzhengNum = 0;
    
    int i = 0;
    
    for (UIViewController *controller in ctrlArray) {
        
        //        NSLog(@"controller.nibName - %@", controller.nibName);
        
        if ([controller.className isEqualToString:@"MyCertificationVC"]) {
            renzhengNum = i;
        }
        i++;
    }
    
    [self.navigationController popToViewController:[ctrlArray objectAtIndex:renzhengNum] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
