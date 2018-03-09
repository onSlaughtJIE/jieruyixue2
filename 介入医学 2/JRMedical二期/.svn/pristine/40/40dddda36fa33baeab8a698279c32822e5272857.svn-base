//
//  ApplyLiveViewController.m
//  JRMedical
//
//  Created by ww on 2016/12/29.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "ApplyLiveViewController.h"
#import <IQKeyboardManager.h>
#import "IQTextView.h"
#import <YYKit.h>

@interface ApplyLiveViewController ()<UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *contactTF;
@property (weak, nonatomic) IBOutlet UITextField *telTF;
@property (weak, nonatomic) IBOutlet IQTextView *resonTextView;

@property (weak, nonatomic) IBOutlet UIButton *timeBtn;

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, copy) NSString *timeStr;

- (IBAction)chooseTimeAction:(UIButton *)sender;
- (IBAction)summit:(UIButton *)sender;

@end

@implementation ApplyLiveViewController

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
    
    // 当值发生改变的时候调用的方法
//    [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];

    [_timeBtn addTarget:self  action:@selector(xianshiDateView) forControlEvents:UIControlEventTouchUpInside];
    
    self.datePicker = [[UIDatePicker alloc]init];
    _datePicker.frame = CGRectMake(0, 40, Width_Screen-20, 200);
    _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    _datePicker.minuteInterval = 30;
    _datePicker.date = [NSDate date];
    _datePicker.minimumDate = [NSDate date];
    
    _contactTF.delegate = self;
    _telTF.delegate = self;
    _resonTextView.placeholder = @"请填写申请描述";
}

- (void)xianshiDateView {
    
    _datePicker.hidden = NO;
    
}

/*
- (void)datePickerValueChanged:(UIDatePicker *)sender {
    
    NSDate *theDate = _datePicker.date;
    NSLog(@"%@",[theDate descriptionWithLocale:[NSLocale currentLocale]]);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm";
    NSLog(@"%@",[dateFormatter stringFromDate:theDate]);
    
    self.timeStr = [dateFormatter stringFromDate:theDate];
    
    [self.timeBtn setTitle:_timeStr forState:(UIControlStateNormal)];
    
}
*/

- (IBAction)chooseTimeAction:(UIButton *)sender {
    
    // 选择预计直播时间
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSDate *date = _datePicker.date;
        self.timeStr = [date stringWithFormat:@"yyyy-MM-dd HH:mm"];
        [self.timeBtn setTitle:_timeStr forState:(UIControlStateNormal)];
        
    }];
    
    UIAlertAction *cancelAction2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController.view addSubview:_datePicker];
    [alertController addAction:cancelAction];
    [alertController addAction:cancelAction2];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
 
}

- (IBAction)summit:(UIButton *)sender {
    
    
    [self summitApply];
}

- (void)summitApply {
    
    
    if (_contactTF.text.length > 0 && _telTF.text.length && _resonTextView.text && _timeStr) {
        
        NSString *url = @"api/LiveVideo/AddLiveVideo";
        NSString *params = [NSString stringWithFormat:@"ZICBDYCContacts=%@ZICBDYCContactsPhone=%@ZICBDYCApplyExplain=%@ZICBDYCEstimateBeginTime=%@", _contactTF.text, _telTF.text, _resonTextView.text, _timeStr];
        
        [self showLoadding:@"" time:20];
        [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
            
            NSLog(@"直播申请 - %@", modelData);
            if (isSuccess) {
                
                [self showMessage:@"申请已发送"];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5/*延迟执行时间*/ * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                    
                });
                
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
        
        
        
    } else {
        [self showMessage:@"请填写完整信息"];
    }
    
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (![self.resonTextView isExclusiveTouch]) {
        [_resonTextView resignFirstResponder];
    }
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
