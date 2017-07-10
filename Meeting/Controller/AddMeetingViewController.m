//
//  AddMeetingViewController.m
//  WZYD
//
//  Created by 吴定如 on 16/10/27.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "AddMeetingViewController.h"
#import "DatePickerView.h"
#import "HourDatePicker.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "Global.h"


@interface AddMeetingViewController () <UITextFieldDelegate,UITextViewDelegate>

@property(nonatomic,strong) DatePickerView *datePicker;
@property(nonatomic,strong) HourDatePicker *hourPicker;
@property(nonatomic,strong) UILabel *startLabel;
@property(nonatomic,strong) UILabel *finishLabel;
@property(nonatomic,strong) UILabel *contextLabel;
@property(nonatomic,strong) UITextField *startText;
@property(nonatomic,strong) UITextField *finishText;
@property(nonatomic,strong) UITextView *contentText;
@property(nonatomic,strong) UIButton *searchBtn;
@property(nonatomic,strong) UIButton *clearBtn;

@end

@implementation AddMeetingViewController

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    //self.navigationItem.title = @"添加日程";
    [self initNavigationBarTitle:@"添加日程"];
    
    
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
    _finishLabel.frame = CGRectMake(20, CGRectGetMaxY(_startLabel.frame)+20, 90, 40);
    _finishText.frame = CGRectMake(CGRectGetMaxX(_finishLabel.frame), CGRectGetMaxY(_startLabel.frame)+20, MainR.size.width-130, 40);
    _contextLabel.frame = CGRectMake(20, CGRectGetMaxY(_finishLabel.frame)+20, 90, 40);
    _contentText.frame = CGRectMake(CGRectGetMaxX(_contextLabel.frame), CGRectGetMaxY(_finishText.frame)+20, MainR.size.width-130, 80);
    
    CGFloat btn_W = (MainR.size.width-60)/2;
    _clearBtn.frame = CGRectMake(20, CGRectGetMaxY(_contentText.frame) + 50, btn_W, 40);
    _searchBtn.frame = CGRectMake(CGRectGetMaxX(_clearBtn.frame)+20, _clearBtn.frame.origin.y, btn_W, 40);
    
    _datePicker.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height);
    [_datePicker screenRotation];
    
    _hourPicker.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height);
    [_hourPicker screenRotation];
}

-(void)createUI
{
    UILabel *startLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 90, 40)];
    startLabel.text = @"日程日期";
    startLabel.font = [UIFont boldSystemFontOfSize:17.5];
    startLabel.textColor = BLUECOLOR;
    _startLabel = startLabel;
    [self.view addSubview:startLabel];
    
    UITextField *startText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(startLabel.frame), 20, MainR.size.width-130, 40)];
    startText.delegate = self;
    startText.placeholder = @"请选择日程日期";
    startText.borderStyle = UITextBorderStyleRoundedRect;
    startText.clearButtonMode = UITextFieldViewModeAlways;
    startText.returnKeyType = UIReturnKeyDone;
    _startText = startText;
    [self.view addSubview:startText];
    
    UILabel *finishLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(startLabel.frame)+20, 90, 40)];
    finishLabel.text = @"日程时间";
    finishLabel.font = [UIFont boldSystemFontOfSize:17.5];
    finishLabel.textColor = BLUECOLOR;
    _finishLabel = finishLabel;
    [self.view addSubview:finishLabel];
    
    UITextField *finishText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(startLabel.frame), CGRectGetMaxY(startText.frame)+20, MainR.size.width-130, 40)];
    finishText.delegate = self;
    finishText.placeholder = @"请选择日程时间";
    finishText.clearButtonMode = UITextFieldViewModeAlways;
    finishText.borderStyle = UITextBorderStyleRoundedRect;
    finishText.returnKeyType = UIReturnKeyDone;
    _finishText = finishText;
    [self.view addSubview:finishText];
    
    UILabel *contextLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(finishLabel.frame)+20, 90, 40)];
    contextLabel.text = @"日程内容";
    contextLabel.font = [UIFont boldSystemFontOfSize:17.5];
    contextLabel.textColor = BLUECOLOR;
    _contextLabel = contextLabel;
    [self.view addSubview:contextLabel];
    
    UITextView *contentText = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(startLabel.frame), CGRectGetMaxY(finishText.frame)+20, MainR.size.width-130, 80)];
    contentText.text = @"请输入日程内容";
    contentText.font = [UIFont systemFontOfSize:17.0];
    if ([contentText.text isEqualToString:@"请输入日程内容"])
    {
        contentText.textColor = [UIColor lightGrayColor];
    }
    contentText.layer.borderWidth = 0.5;
    contentText.layer.borderColor = GRAYCOLOR_MIDDLE.CGColor;
    contentText.layer.cornerRadius = 5;
    contentText.clipsToBounds = YES;
    contentText.returnKeyType = UIReturnKeyDone;
    contentText.delegate = self;
    _contentText = contentText;
    [self.view addSubview:contentText];
    
    CGFloat btn_W = (MainR.size.width-60)/2;
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    clearBtn.frame = CGRectMake(20, CGRectGetMaxY(contentText.frame) + 50, btn_W, 40);
    [clearBtn setTitle:@"重置" forState:UIControlStateNormal];
    clearBtn.backgroundColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:239/255.0 alpha:1.0];
    clearBtn.layer.borderWidth = 1;
    clearBtn.layer.borderColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:239/255.0 alpha:1.0].CGColor;
    [clearBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clearText) forControlEvents:UIControlEventTouchUpInside];
    clearBtn.layer.cornerRadius = 3;
    clearBtn.clipsToBounds = YES;
    _clearBtn = clearBtn;
    [self.view addSubview:clearBtn];
    
    
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    searchBtn.frame = CGRectMake(CGRectGetMaxX(clearBtn.frame)+20, clearBtn.frame.origin.y, btn_W, 40);
    searchBtn.backgroundColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:239/255.0 alpha:1.0];
    searchBtn.layer.borderWidth = 1;
    searchBtn.layer.borderColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:239/255.0 alpha:1.0].CGColor;
    [searchBtn setTitle:@"添加" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(addMeeting) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.layer.cornerRadius = 3;
    searchBtn.clipsToBounds = YES;
    _searchBtn = searchBtn;
    [self.view addSubview:searchBtn];
}

#pragma mark -- 添加会议
-(void)addMeeting
{
    if ([_startText.text isEqualToString:@""]||[_finishText.text isEqualToString:@""]||[_contentText.text isEqualToString:@""]||[_contentText.text isEqualToString:@"请输入日程内容"])
    {
        [MBProgressHUD showError:@"请先将内容填写完全"];
    }
    else
    {
        [self.view endEditing:YES];
        NSString *hour = [_finishText.text substringToIndex:2];
        NSString *minute = [_finishText.text substringWithRange:NSMakeRange(3, 2)];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];

        
        NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/calendar/CalendarAdd.ashx"];
        NSDictionary *paremeters = @{@"userId":[Global userId],@"date":_startText.text,@"hour":hour,@"min":minute,@"context":_contentText.text,@"deviceNumber":[Global deviceUUID],@"username":[Global userName]};
        
        [manager POST:url parameters:paremeters success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSDictionary *JsonDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
             
             if ([[JsonDic objectForKey:@"msg"]isEqualToString:@"保存成功"])
             {
                 if (_addMeetingSuccessBlock) {
                     _addMeetingSuccessBlock(YES);
                 }
                 [self.navigationController popViewControllerAnimated:YES];
//                 [UIView animateWithDuration:1.5 animations:^{
//
//                     [MBProgressHUD showSuccess:@"添加成功"];
//                     
//                 } completion:^(BOOL finished) {
//                     
//                     [self.navigationController popViewControllerAnimated:YES];
//                 } ];
             }
             
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             [MBProgressHUD showError:@"添加失败"];
             
         }];
    }

}

// 重置
-(void)clearText
{
    _startText.text = @"";
    _finishText.text = @"";
    _contentText.text = @"请输入日程内容";
    _contentText.textColor = [UIColor lightGrayColor];
    [self.view endEditing:YES];
    
    
}

#pragma mark -- textField代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _startText)
    {
        [self selectTimePicker];
    }
    else if (textField == _finishText)
    {
        [self selectHourAndMinutePicker];
    }
    return NO;
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入日程内容"])
    {
        textView.text = @"";
    }
    textView.textColor =[UIColor blackColor];
}
//点击键盘右下角的键收起键盘
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        if (textView.text.length == 0)
        {
            textView.textColor =[UIColor lightGrayColor];
            textView.text = @"请输入日程内容";
        }
        else
        {
            textView.textColor =[UIColor blackColor];
        }
        [textView resignFirstResponder];
    }
    return YES;
}

//日期选择
-(void)selectTimePicker
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
        
        weakSelf.startText.text = selectDateStr;

        
    };
    //取消
    _datePicker.cancelSelectBlock = ^(NSDate *date)
    {
        
    };
    
}
-(void)selectHourAndMinutePicker
{
    HourDatePicker *hourPicker = [[HourDatePicker alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, MainR.size.height)];
    _hourPicker = hourPicker;
    [hourPicker showInView:self.view.window.rootViewController.view animated:YES];
    
    __weak typeof (*&self)weakSelf = self;
    hourPicker.dateSelectBlock = ^(NSInteger year,NSInteger month)
    {
        NSString *selectDateStr = [NSString stringWithFormat:@"%02ld:%02ld",(long)year,(long)month];
        weakSelf.finishText.text = selectDateStr;
        
    };

}

#pragma mark --  键盘升起/隐藏
-(void)keyboardWillShow:(NSNotification *)noti
{
    // 获取键盘弹出的动画时间
    CGFloat durtion = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGSize keyboardSize = [noti.userInfo[@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue].size ;
    CGFloat keyboard_h = keyboardSize.height;
    // NSLog(@"1=====%f",keyboard_h);
    if (MainR.size.height < 768)
    {
        
        [UIView animateWithDuration:durtion animations:^{
            
            CGRect footerFrame = self.view.frame;
            
            footerFrame.origin.y = footerFrame.origin.y-keyboard_h*1/3;
            
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
