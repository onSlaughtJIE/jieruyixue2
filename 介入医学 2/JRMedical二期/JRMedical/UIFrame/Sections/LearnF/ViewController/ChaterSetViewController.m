//
//  ChaterSetViewController.m
//  JRMedical
//
//  Created by ww on 2016/12/21.
//  Copyright © 2016年 idcby. All rights reserved.
//

#define KNOTIFICATIONNAME_DELETEALLMESSAGE @"RemoveAllMessages"

#import "ChaterSetViewController.h"

@interface ChaterSetViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIView *emptyChatView;
- (IBAction)deleteChater:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *blackListView;

@end

@implementation ChaterSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.emptyChatView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emptyChatMessage)]];
    
    [self.blackListView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blackList)]];
    
    // 获取好友头像/昵称
    [self getUSerMessageWith:self.userid];
    
}

- (void)blackList {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确定加入黑名单吗?" message:@"加入黑名单后, 该好友不能发消息给你" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *actionCancle = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        // 加入黑名单
        [self showHudInView:self.view hint:NSLocalizedString(@"wait", @"Pleae wait...")];
        
        EMError *error = [[EMClient sharedClient].contactManager addUserToBlackList:self.userid relationshipBoth:YES];
        if (!error) {
            //由于加入黑名单成功后会刷新黑名单，所以此处不需要再更改好友列表
            [[NSNotificationCenter defaultCenter] postNotificationName:@"aboutBlackListRefreshAction" object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else {
            [self showHint:error.errorDescription];
        }
        [self hideHud];
        
    }];
    [alertVC addAction:actionCancle];
    [alertVC addAction:action];
    [self presentViewController:alertVC animated:YES completion:nil];
    
    
    
}

// 清空消息
- (void)emptyChatMessage {

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定清空消息记录吗?" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
    [alertView show];

}
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex != buttonIndex) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATIONNAME_DELETEALLMESSAGE object:nil];
        
    }
}

- (IBAction)deleteChater:(UIButton *)sender {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确定删除该好友吗?" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *actionCancle = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        // 删除好友
        EMError *error = [[EMClient sharedClient].contactManager deleteContact:self.userid isDeleteConversation:YES];
        if (!error) {
            [[EMClient sharedClient].chatManager deleteConversation:self.userid isDeleteMessages:YES completion:nil];
            [self showHint:@"删除成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else{
            [self showHint:[NSString stringWithFormat:NSLocalizedString(@"deleteFailed", @"Delete failed:%@"), error.errorDescription]];
            
        }
        
        
    }];
    [alertVC addAction:actionCancle];
    [alertVC addAction:action];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}


- (void)getUSerMessageWith:(NSString *)str {
    //    /IM/GetCustomerInfoByID
    NSString *urlS = [NSString stringWithFormat:@"%@/api/IM/GetCustomerInfoByID", Server_Int_Url];
    NSString *dataS = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCID=%@", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI,str, nil];
    NSString *dataEncrpyt = [TWDes encryptWithContent:dataS type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    NSDictionary *paraDic = @{kToken:token, kDatas:dataEncrpyt};
    
    [AFManegerHelp POST:urlS parameters:paraDic success:^(id responseObjeck) {
        NSLog(@"EaseUserCell - GetCustomerInfoByID - %@", responseObjeck);
        if ([responseObjeck[@"Success"] integerValue] == 1) {
            NSArray *array = responseObjeck[@"JsonData"];
            for (NSDictionary *d in array) {
                
                self.nameLab.text = d[@"CustomerName"];
                [self.imageView sd_setImageWithURL:[NSURL URLWithString:d[@"UserPic"]] placeholderImage:[UIImage imageNamed:@"chatListCellHead"]];
                
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"cuowu%@", error);
    }];
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
