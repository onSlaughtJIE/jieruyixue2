//
//  AboutJRViewController.m
//  JRMedical
//
//  Created by ww on 2017/1/12.
//  Copyright © 2017年 idcby. All rights reserved.
//

#import "AboutJRViewController.h"
#import "HTMLViewController.h"

@interface AboutJRViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *versionLab;
@property (weak, nonatomic) IBOutlet UITableView *AboutTableView;
@property (weak, nonatomic) IBOutlet UIButton *xieyiButton;

- (IBAction)xieyiAction:(UIButton *)sender;

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation AboutJRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于介入医学";
    
    [self.AboutTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.dataArr = @[@"介入医学简介", @"声明"];
    
    self.versionLab.text = [NSString stringWithFormat:@"%@版", [self getCurrentAppVersion]];
    
    // underline Terms and condidtions
    NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:@"服务与隐私协议"];
    //设置下划线...
    /*
     NSUnderlineStyleNone                                    = 0x00, 无下划线
     NSUnderlineStyleSingle                                  = 0x01, 单行下划线
     NSUnderlineStyleThick NS_ENUM_AVAILABLE(10_0, 7_0)      = 0x02, 粗的下划线
     NSUnderlineStyleDouble NS_ENUM_AVAILABLE(10_0, 7_0)     = 0x09, 双下划线
     */
    [tncString addAttribute:NSUnderlineStyleAttributeName
                      value:@(NSUnderlineStyleSingle)
                      range:(NSRange){0,[tncString length]}];
    
    //设置下划线颜色...
    [tncString addAttribute:NSUnderlineColorAttributeName value:RGB(75, 155, 249) range:(NSRange){0,[tncString length]}];
    [self.xieyiButton setAttributedTitle:tncString forState:UIControlStateNormal];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = self.dataArr[indexPath.row];
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 0) {
        
        HTMLViewController * htmlVC = [[HTMLViewController alloc] init];
        htmlVC.urlStr = @"Web/BaseInfo/BriefInfoIndex";
        htmlVC.title = @"简介";
        [self.navigationController pushViewController:htmlVC animated:YES];
        
    } else {
        
        HTMLViewController * htmlVC = [[HTMLViewController alloc] init];
        htmlVC.urlStr = @"Web/BaseInfo/StatementInfoIndex";
        htmlVC.title = @"声明";
        [self.navigationController pushViewController:htmlVC animated:YES];
        
    }
}




- (IBAction)xieyiAction:(UIButton *)sender {
    
    HTMLViewController * htmlVC = [[HTMLViewController alloc] init];
    htmlVC.urlStr = @"Admin/APPDoc/RegDoc";
    htmlVC.title = @"服务与隐私协议";
    [self.navigationController pushViewController:htmlVC animated:YES];
    
}


//获取当前软件版本
- (NSString *)getCurrentAppVersion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
