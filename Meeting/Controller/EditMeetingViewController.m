//
//  EditMeetingViewController.m
//  WZYD
//
//  Created by 吴定如 on 16/10/27.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "EditMeetingViewController.h"
#import "DatePickerView.h"
#import "HourDatePicker.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "Global.h"


@interface EditMeetingViewController () <UITextFieldDelegate,UITextViewDelegate>

@property(nonatomic,strong) DatePickerView *datePicker;
@property(nonatomic,strong) HourDatePicker *hourPicker;
@property(nonatomic,strong) UITextField *startText;
@property(nonatomic,strong) UITextField *finishText;
@property(nonatomic,strong) UITextView *contentText;
@property(nonatomic,strong) UIButton *searchBtn;
@property(nonatomic,strong) UIButton *clearBtn;

@end

@implementation EditMeetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    //self.navigationItem.title = @"编辑日程";
    [self initNavigationBarTitle:@"编辑日程"];
    
    
    [self createUI];
    //监听屏幕旋转的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}
//屏幕旋转改变视图的Frame
-(void)screenRotation:(NSNotification *)noti
{
    _startText.frame = CGRectMake(20, 20, MainR.size.width-40, 40);
    _finishText.frame = CGRectMake(20, CGRectGetMaxY(_startText.frame)+20, MainR.size.width-40, 40);
    _contentText.frame = CGRectMake(20, CGRectGetMaxY(_finishText.frame)+20, MainR.size.width-40, 80);
    
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
    UITextField *startText = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, MainR.size.width-40, 40)];
    startText.delegate = self;
//    startText.placeholder = @"会议日期";
    startText.text = [_model.start substringToIndex:10];
    startText.borderStyle = UITextBorderStyleRoundedRect;
    startText.clearButtonMode = UITextFieldViewModeAlways;
    startText.returnKeyType = UIReturnKeyDone;
    _startText = startText;
    [self.view addSubview:startText];
    
    UITextField *finishText = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(startText.frame)+20, MainR.size.width-40, 40)];
    finishText.delegate = self;
//    finishText.placeholder = @"会议时间";
    finishText.text = _model.startTime;
    finishText.clearButtonMode = UITextFieldViewModeAlways;
    finishText.borderStyle = UITextBorderStyleRoundedRect;
    finishText.returnKeyType = UIReturnKeyDone;
    _finishText = finishText;
    [self.view addSubview:finishText];
    
    UITextView *contentText = [[UITextView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(finishText.frame)+20, MainR.size.width-40, 80)];
    contentText.text = _model.context;
    contentText.font = [UIFont systemFontOfSize:17.0];
    contentText.textColor = [UIColor blackColor];
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
    [clearBtn setTitle:@"删除" forState:UIControlStateNormal];
    clearBtn.backgroundColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:239/255.0 alpha:1.0];
    clearBtn.layer.borderWidth = 1;
    clearBtn.layer.borderColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:239/255.0 alpha:1.0].CGColor;
    [clearBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(deleteMeeting) forControlEvents:UIControlEventTouchUpInside];
    clearBtn.layer.cornerRadius = 3;
    clearBtn.clipsToBounds = YES;
    _clearBtn = clearBtn;
    [self.view addSubview:clearBtn];
    
    
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    searchBtn.frame = CGRectMake(CGRectGetMaxX(clearBtn.frame)+20, clearBtn.frame.origin.y, btn_W, 40);
    searchBtn.backgroundColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:239/255.0 alpha:1.0];
    searchBtn.layer.borderWidth = 1;
    searchBtn.layer.borderColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:239/255.0 alpha:1.0].CGColor;
    [searchBtn setTitle:@"修改" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(editMeeting) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.layer.cornerRadius = 3;
    searchBtn.clipsToBounds = YES;
    _searchBtn = searchBtn;
    [self.view addSubview:searchBtn];
}

#pragma mark -- 编辑会议
-(void)editMeeting
{
    NSString *start = [_model.start substringToIndex:10];
    if ([_startText.text isEqualToString:start] &&[_finishText.text isEqualToString:_model.startTime]&& ([_contentText.text isEqualToString:@""]||[_contentText.text isEqualToString:_model.context]))
    {
        [MBProgressHUD showError:@"内容没有修改"];
    }
    else
    {
        [self.view endEditing:YES];
        NSString *hour = [_finishText.text substringToIndex:2];
        NSString *minute = [_finishText.text substringWithRange:NSMakeRange(3, 2)];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        
        NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/calendar/CalendarUpdate.ashx"];
        NSDictionary *paremeters = @{@"userId":[Global userId],@"date":_startText.text,@"hour":hour,@"min":minute,@"context":_contentText.text,@"scheduleId":_model.Id,@"deviceNumber":[Global deviceUUID],@"username":[Global userName]};
        
        [manager POST:url parameters:paremeters success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSDictionary *JsonDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];

             if ([[JsonDic objectForKey:@"msg"]isEqualToString:@"保存成功"])
             {
                 [UIView animateWithDuration:1.0 delay:2.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                     
                     [MBProgressHUD showSuccess:@"编辑成功"];
                 } completion:^(BOOL finished) {
                     
                     if (_editSuccessBlock)
                     {
                         _model.start = _startText.text;
                         _model.startTime = _finishText.text;
                         _model.context = _contentText.text;
                         _editSuccessBlock(YES,_model);
                         [self.navigationController popViewControllerAnimated:YES];
                     }
                 }];
                 
             }
            
         }
         
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            [MBProgressHUD showError:@"编辑失败"];
                  
        }];
         
    }
    
}

#pragma mark -- 删除会议
-(void)deleteMeeting
{
    [self.view endEditing:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/calendar/CalendarDelete.ashx"];
    NSDictionary *paremeters = @{@"scheduleId":_model.Id,@"deviceNumber":[Global deviceUUID],@"username":[Global userName]};
    
    [manager POST:url parameters:paremeters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *JsonDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
         
         if ([[JsonDic objectForKey:@"msg"]isEqualToString:@"删除成功"])
         {
             [UIView animateWithDuration:1.5 animations:^{
                                  
                 [MBProgressHUD showSuccess:@"删除成功"];
                 
             } completion:^(BOOL finished) {
                 
                 if (_deleteSuccessBlock)
                 {
                     _deleteSuccessBlock(YES);
                     [self.navigationController popViewControllerAnimated:YES];
                 }
             }];
             
         }
     }
     
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [MBProgressHUD showError:@"删除失败"];
         
     }];
}

#pragma mark -- textField代理
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
    textView.text = @"";
    textView.textColor =[UIColor blackColor];
}
//点击键盘右下角的键收起键盘
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
