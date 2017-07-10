//
//  PresignedViewController.m
//  WZYD
//
//  Created by 吴定如 on 16/11/8.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "PresignedViewController.h"
#import "DatePickerView.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "Global.h"

//static CGFloat KeyBoardHeight = 282.0;

@interface PresignedViewController () <UITextFieldDelegate>

@property(nonatomic,strong) DatePickerView *datePicker;
@property(nonatomic,strong) UILabel *reasonLabel;
@property(nonatomic,strong) UITextField *reasonText;
@property(nonatomic,strong) UILabel *startLabel;
@property(nonatomic,strong) UILabel *finishLabel;
@property(nonatomic,strong) UITextField *startText;
@property(nonatomic,strong) UITextField *startTypeText;
@property(nonatomic,strong) UITextField *finishText;
@property(nonatomic,strong) UITextField *finishTypeText;
@property(nonatomic,strong) UIButton *presignBtn;

@end

@implementation PresignedViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    //self.navigationItem.title = @"预签";
    [self initNavigationBarTitle:@"预签"];
    
    
    [self createUI];
    
    //键盘唤起和隐藏的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //监听屏幕旋转的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    
}
//屏幕旋转改变视图的Frame
-(void)screenRotation:(NSNotification *)noti
{
    _startLabel.frame = CGRectMake(20, 20, 90, 40);
    
    _startText.frame = CGRectMake(CGRectGetMaxX(_startLabel.frame), 20, MainR.size.width-130, 40);
    _startTypeText.frame = CGRectMake(_startText.frame.origin.x, CGRectGetMaxY(_startText.frame)+10, MainR.size.width-130, 40);
    _finishLabel.frame = CGRectMake(20, CGRectGetMaxY(_startTypeText.frame)+20, 90, 40);
    
    _finishText.frame = CGRectMake(CGRectGetMaxX(_finishLabel.frame), _finishLabel.frame.origin.y, MainR.size.width-130, 40);
    _finishTypeText.frame = CGRectMake(_finishText.frame.origin.x, CGRectGetMaxY(_finishText.frame)+10, MainR.size.width-130, 40);
    _reasonLabel.frame = CGRectMake(20, CGRectGetMaxY(_finishTypeText.frame)+20, 90, 40);
    _reasonText.frame = CGRectMake(CGRectGetMaxX(_reasonLabel.frame), _reasonLabel.frame.origin.y, MainR.size.width-130, 40);
    _presignBtn.frame = CGRectMake(20, CGRectGetMaxY(_reasonText.frame)+50, SCREEN_WIDTH-40, 40);
    
    _datePicker.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height);
    [_datePicker screenRotation];
}
//导航栏标题
-(void)initNavigationBarTitle:(NSString *)title
{
    UILabel *lab      = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    lab.textColor     = [UIColor whiteColor];
    lab.font          = [UIFont boldSystemFontOfSize:17.0];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text          = title;
    
    self.navigationItem.titleView = lab;
}


-(void)createUI
{
    UILabel *startLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 90, 40)];
    startLabel.text = @"开始时间";
    startLabel.font = [UIFont boldSystemFontOfSize:17.5];
    startLabel.textColor = BLUECOLOR;
    _startLabel = startLabel;
    [self.view addSubview:startLabel];
    
    UITextField *startText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(startLabel.frame), 20, MainR.size.width-130, 40)];
    startText.delegate = self;
    startText.placeholder = @"请选择开始日期";
    startText.borderStyle = UITextBorderStyleRoundedRect;
    startText.clearButtonMode = UITextFieldViewModeAlways;
    startText.returnKeyType = UIReturnKeyDone;
    _startText = startText;
    [self.view addSubview:startText];
    
    UITextField *startTypeText = [[UITextField alloc] initWithFrame:CGRectMake(startText.frame.origin.x, CGRectGetMaxY(startText.frame)+10, MainR.size.width-130, 40)];
    startTypeText.delegate = self;
    startTypeText.placeholder = @"时间类型";
    startTypeText.borderStyle = UITextBorderStyleRoundedRect;
    startTypeText.clearButtonMode = UITextFieldViewModeAlways;
    startTypeText.returnKeyType = UIReturnKeyDone;
    _startTypeText = startTypeText;
    [self.view addSubview:startTypeText];
    
    UILabel *finishLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(startTypeText.frame)+20, 90, 40)];
    finishLabel.text = @"结束时间";
    finishLabel.font = [UIFont boldSystemFontOfSize:17.5];
    finishLabel.textColor = BLUECOLOR;
    _finishLabel = finishLabel;
    [self.view addSubview:finishLabel];
    
    UITextField *finishText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(finishLabel.frame), finishLabel.frame.origin.y, MainR.size.width-130, 40)];
    finishText.delegate = self;
    finishText.placeholder = @"请选择结束日期";
    finishText.clearButtonMode = UITextFieldViewModeAlways;
    finishText.borderStyle = UITextBorderStyleRoundedRect;
    finishText.returnKeyType = UIReturnKeyDone;
    _finishText = finishText;
    [self.view addSubview:finishText];
    
    UITextField *finishTypeText = [[UITextField alloc] initWithFrame:CGRectMake(finishText.frame.origin.x, CGRectGetMaxY(finishText.frame)+10, MainR.size.width-130, 40)];
    finishTypeText.delegate = self;
    finishTypeText.placeholder = @"时间类型";
    finishTypeText.borderStyle = UITextBorderStyleRoundedRect;
    finishTypeText.clearButtonMode = UITextFieldViewModeAlways;
    finishTypeText.returnKeyType = UIReturnKeyDone;
    _finishTypeText = finishTypeText;
    [self.view addSubview:finishTypeText];
    
    UILabel *reasonLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(finishTypeText.frame)+20, 90, 40)];
    reasonLabel.text = @"预签原因";
    reasonLabel.font = [UIFont boldSystemFontOfSize:17.5];
    reasonLabel.textColor = BLUECOLOR;
    _reasonLabel = reasonLabel;
    [self.view addSubview:reasonLabel];
    
    UITextField *reasonText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(reasonLabel.frame), reasonLabel.frame.origin.y, MainR.size.width-130, 40)];
    reasonText.delegate = self;
    reasonText.placeholder = @"请输入原因";
    reasonText.clearButtonMode = UITextFieldViewModeAlways;
    reasonText.borderStyle = UITextBorderStyleRoundedRect;
    reasonText.returnKeyType = UIReturnKeyDone;
    _reasonText = reasonText;
    [self.view addSubview:reasonText];
    
    
    UIButton *presignBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    presignBtn.frame = CGRectMake(20, CGRectGetMaxY(reasonText.frame)+50, SCREEN_WIDTH-40, 40);
    presignBtn.backgroundColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:239/255.0 alpha:1.0];
    [presignBtn setTitle:@"预签" forState:UIControlStateNormal];
    [presignBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [presignBtn addTarget:self action:@selector(submitPresign) forControlEvents:UIControlEventTouchUpInside];
    presignBtn.layer.cornerRadius = 3;
    presignBtn.clipsToBounds = YES;
    _presignBtn = presignBtn;
    [self.view addSubview:presignBtn];
}

#pragma mark -- 预签
-(void)submitPresign
{
    [self.view endEditing:YES];
    
    if ([_startText.text isEqualToString:@""]||[_finishText.text isEqualToString:@""]||[_startTypeText.text isEqualToString:@""]||[_finishTypeText.text isEqualToString:@""]||[_reasonText.text isEqualToString:@""])
    {
        [MBProgressHUD showError:@"请先将内容填写完全"];
    }
    else
    {
        //加载提示框
        [MBProgressHUD showMessage:@"正在预签" toView:self.view];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
    //61.153.29.236:8891/mobileService/service/PreSign.ashx?userID=580&reason=原因&timeStart=2016-11-01&timeEnd=2016-11-11&startType=1&endType=2&deviceId=c9e9163d-5619-3b91-af06-34cb890c496f&username=李卫
        
        NSString *startType = @"";
        NSString *endType = @"";
        if ([_startTypeText.text isEqualToString:@"上午"])
        {
            startType = @"1";
        }
        else if ([_startTypeText.text isEqualToString:@"下午"])
        {
            startType = @"2";
        }
        if ([_finishTypeText.text isEqualToString:@"上午"])
        {
            endType = @"1";
        }
        else if ([_finishTypeText.text isEqualToString:@"下午"])
        {
            endType = @"2";
        }


        NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/PreSign.ashx"];
        NSDictionary *parameters = @{@"userID":[Global userId],@"reason":_reasonText.text,@"timeStart":_startText.text,@"timeEnd":_finishText.text,@"startType":startType,@"endType":endType,@"deviceNumber":[Global deviceUUID],@"username":[Global userName]};
        
       [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             [MBProgressHUD hideHUDForView:self.view animated:NO];
             
             NSDictionary *JsonDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
             if ([[JsonDic objectForKey:@"result"]isEqual:@1])
             {
                 [UIView animateWithDuration:1.5 animations:^{
                     
                     [MBProgressHUD showSuccess:@"预签成功"];
                     
                 } completion:^(BOOL finished) {
                     
                     [self.navigationController popViewControllerAnimated:YES];
                 } ];
             }else
             {
                 [MBProgressHUD showError:@"预签失败"];
             }
             
         }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
             NSLog(@"%@",error);
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            [MBProgressHUD showError:@"预签失败"];
                  
        }];
    }
}


#pragma mark -- textField代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _startText)
    {
        [self selectTimePicker:_startText];
    }
    else if (textField == _startTypeText)
    {
        [self selectedAMOrPM:_startTypeText];
    }
    else if (textField == _finishText)
    {
        [self selectTimePicker:_finishText];
    }
    else if (textField == _finishTypeText)
    {
        [self selectedAMOrPM:_finishTypeText];
    }
    else if (textField == _reasonText)
    {
        return YES;
    }
    return NO;
    
}

//日期选择
-(void)selectTimePicker:(UITextField *)textField
{
    
    DatePickerView *datePicker  = [[DatePickerView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, MainR.size.height) AndDatePickerMode:UIDatePickerModeDate];
    _datePicker = datePicker;
    [_datePicker showInView:self.view.window.rootViewController.view animated:YES];
    
    
    DefineWeakSelf(weakSelf);
    //选择
    _datePicker.dateSelectBlock = ^(NSDate *selectDate){
        
        //定义日期显示的格式
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *selectDateStr = [dateFormatter stringFromDate:selectDate];
        
        if (textField == _startText)
        {
            weakSelf.startText.text = selectDateStr;
        }
        else if (textField == _finishText)
        {
            weakSelf.finishText.text = selectDateStr;
        }
        
    };
    //取消
    _datePicker.cancelSelectBlock = ^(NSDate *date)
    {
        
    };
    
}
-(void)selectedAMOrPM:(UITextField *)textField
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"下午" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        if (textField == _startTypeText)
        {
            _startTypeText.text = @"下午";
        }
        else if (textField == _finishTypeText)
        {
            _finishTypeText.text = @"下午";
        }
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"上午" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        if (textField == _startTypeText)
        {
            _startTypeText.text = @"上午";
        }
        else if (textField == _finishTypeText)
        {
            _finishTypeText.text = @"上午";
        }
        
    }];
    [alert addAction:sureAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark --  键盘升起/隐藏
-(void)keyboardWillShow:(NSNotification *)noti
{
    // 获取键盘弹出的动画时间
    CGFloat durtion = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGSize keyboardSize = [noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].size;
    //CGFloat keyboard_h = keyboardSize.height;
    //NSLog(@"1=====%@",noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"]);
    if (MainR.size.height < 768)
    {
        
        [UIView animateWithDuration:durtion animations:^{
            
            CGRect footerFrame = self.view.frame;
            footerFrame.origin.y = 64 - keyboardSize.height*2/3;
            self.view.frame = footerFrame;
            
        }];
    }
}

#pragma mark -- 键盘收起
-(void)keyboardWillHide:(NSNotification *)noti
{
    // 获取键盘弹出的动画时间
    CGFloat durtion = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGSize keyboardSize = [noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].size ;
    CGFloat keyboard_h = keyboardSize.height;
    //NSLog(@"2=====%f",keyboard_h);
    if (MainR.size.height < 768)
    {
        [UIView animateWithDuration:durtion animations:^{
            
            CGRect foorterFrame = self.view.frame;
            foorterFrame.origin.y = 64;
            self.view.frame = foorterFrame;

        }];
    }
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end

