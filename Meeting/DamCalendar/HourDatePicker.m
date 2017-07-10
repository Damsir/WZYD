//
//  HourDatePicker.m
//  WZYD
//
//  Created by 吴定如 on 16/10/27.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "HourDatePicker.h"

static NSDateFormatter *dateFormatter;


@interface HourDatePicker() <UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic,strong) UIView *dateBackView;
@property(nonatomic,strong) UIPickerView *datePicker;
@property(nonatomic,strong) UIButton *sureBtn;
@property(nonatomic,strong) UIButton *cancelBtn;
@property(nonatomic,strong) NSMutableArray *hourArray;
@property(nonatomic,strong) NSMutableArray *minuteArray;
@property(nonatomic,assign) NSInteger hour;
@property(nonatomic,assign) NSInteger minute;
@property(nonatomic,strong) UIView *viewH;
@property(nonatomic,strong) UIView *viewV;

@end

@implementation HourDatePicker

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //蒙版(自己)
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self loadDateArray];
        [self createDatePiker];
        
    }
    return self;
}

-(void)screenRotation
{
    _dateBackView.center = CGPointMake(MainR.size.width/2, MainR.size.height/2);
}

-(void)loadDateArray
{
    _hourArray = [NSMutableArray array];
    for (NSInteger i = 0; i<24; i++) {
        NSString *str = [NSString stringWithFormat:@"%02ld",(long)i];
        [_hourArray addObject:str];
    }
    _minuteArray = [NSMutableArray array];
    for (NSInteger i = 0; i<60; i++) {
        NSString *str = [NSString stringWithFormat:@"%02ld",(long)i];
        [_minuteArray addObject:str];
    }
}

-(void)createDatePiker
{
    //大的背景view
    UIView *dateBackView = [[UIView alloc] init];
    if (MainR.size.width < 768)
    {
        dateBackView.frame = CGRectMake(0, 0, MainR.size.width-20, 306);
    }else
    {
        dateBackView.frame = CGRectMake(0, 0, 400, 306);
    }
    dateBackView.layer.cornerRadius = 10;
    dateBackView.clipsToBounds = YES;
    dateBackView.backgroundColor = [UIColor whiteColor];
    dateBackView.center = CGPointMake(MainR.size.width/2, MainR.size.height/2);
    _dateBackView = dateBackView;
    [self addSubview:dateBackView];
    
    UIPickerView *datePicker = [UIPickerView new];
    if (MainR.size.width < 768)
    {
        datePicker.frame = CGRectMake(10, 20, dateBackView.frame.size.width-20, 216);
    }else
    {
        datePicker.frame = CGRectMake(50, 20, dateBackView.frame.size.width-100, 216);
    }
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.delegate = self;
    datePicker.dataSource = self;
    _datePicker = datePicker;
    [dateBackView addSubview:datePicker];
    
    //设置pickerview初始默认(当前日期)
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    //NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm"];
    NSString *str111 = [dateFormatter stringFromDate:[NSDate date]];
    // NSDateFormatter *formatter3 = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh"];
    NSString *str222 = [dateFormatter stringFromDate:[NSDate date]];
    NSInteger a = [str111 integerValue];
    NSInteger b = [str222 integerValue];
    [self.datePicker selectRow:a inComponent:1 animated:NO];
    [self.datePicker selectRow:b inComponent:0 animated:NO];
    //初始值
    _hour = b;
    _minute = a;
    
    UIView *viewH = [[UIView alloc] initWithFrame:CGRectMake(0, dateBackView.frame.size.height- 51, dateBackView.frame.size.width, 1)];
    viewH.backgroundColor = BLUECOLOR;
    _viewH = viewH;
    [dateBackView addSubview:viewH];
    
    UIView *viewV = [[UIView alloc] initWithFrame:CGRectMake(dateBackView.frame.size.width/2, dateBackView.frame.size.height- 51, 1, 51)];
    viewV.backgroundColor = BLUECOLOR;
    _viewV = viewV;
    [dateBackView addSubview:viewV];
    
    CGFloat btn_w = dateBackView.frame.size.width/2;
    //取消
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0,dateBackView.frame.size.height-50,btn_w,50);
    [cancelBtn setTitleColor:BLUECOLOR forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelSelect) forControlEvents:UIControlEventTouchUpInside];
    _cancelBtn = cancelBtn;
    [dateBackView addSubview:cancelBtn];
    //确定
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(btn_w,dateBackView.frame.size.height-50,btn_w,50);;
    [sureBtn setTitleColor:BLUECOLOR forState:UIControlStateNormal];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(selectedDate) forControlEvents:UIControlEventTouchUpInside];
    _sureBtn = sureBtn;
    [dateBackView addSubview:sureBtn];
}

#pragma mark -- pickerDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return _hourArray.count;
    }else {
        return _minuteArray.count;
    }
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return  [NSString stringWithFormat:@"%@时", _hourArray[row]];//时
    }else {
        return  [NSString stringWithFormat:@"%@分", _minuteArray[row]];;//分
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        _hour = [_hourArray[row] integerValue];
    }else{
        _minute = [_minuteArray[row] integerValue];
    }
    
    
    //    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    //    [formatter2 setDateFormat:@"MM"];
    //    NSString *str111 = [formatter2 stringFromDate:[NSDate date]];
    //    NSDateFormatter *formatter3 = [[NSDateFormatter alloc] init];
    //    [formatter3 setDateFormat:@"yyyy"];
    //    NSString *str222 = [formatter3 stringFromDate:[NSDate date]];
    //    int a = [str111 intValue];//月
    //    int b = [str222 intValue];//年
    //    int c = [self.str10 intValue];//月
    //    int d = [self.str11 intValue];//年
    
    //时间晚于当前年月自动回到当前年月
    //    if (d>b||(d==b&&c>a)) {
    //        [self.datePicker selectRow:a-1 inComponent:1 animated:YES];
    //        [self.datePicker selectRow:b-1900 inComponent:0 animated:YES];
    //    }
    
    //    self.timeSelectedString = [NSString stringWithFormat:@"%@%@",self.str11,self.str10];
    
}

//确定选择事件
-(void)selectedDate
{
    
    if (_dateSelectBlock) {
        _dateSelectBlock(_hour,_minute);
    }
    
    [self fadeOut];
}

-(void)cancelSelect
{
    [self fadeOut];
}

-(void)showInView:(UIView *)superView animated:(BOOL)animated
{
    [superView addSubview:self];
    if (animated)
    {
        [self fadeIn];
    }
}

-(void)fadeIn
{
    /**
     *  弹出动画
     */
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}
-(void)fadeOut
{
    /**
     *  消失动画
     */
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished)
        {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark -- touch

//-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self fadeOut];
//}

@end
