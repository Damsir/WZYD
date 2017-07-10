//
//  DatePickerView.m
//  KSYD
//
//  Created by 吴定如 on 16/8/4.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "DatePickerView.h"

@interface DatePickerView()

@property(nonatomic,strong) UIDatePicker *datePicker;
@property(nonatomic,strong) UIView *dateBackView;
@property(nonatomic,strong) UIButton *sureBtn;
@property(nonatomic,strong) UIButton *cancelBtn;
@property(nonatomic,strong) UIView *viewH;
@property(nonatomic,strong) UIView *viewV;

@end


@implementation DatePickerView

-(instancetype)initWithFrame:(CGRect)frame AndDatePickerMode:(UIDatePickerMode)datePickerMode
{
    if (self = [super initWithFrame:frame])
    {
        //蒙版(自己)
        _datePickerMode = datePickerMode;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self createDatePicker];
    }
    return self;
}

-(void)screenRotation
{
    self.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height);
    _dateBackView.center = CGPointMake(MainR.size.width/2, MainR.size.height/2);
}

-(void)createDatePicker
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
    dateBackView.center = CGPointMake(MainR.size.width/2, MainR.size.height/2);
    dateBackView.layer.cornerRadius = 10;
    dateBackView.clipsToBounds = YES;
    dateBackView.backgroundColor = [UIColor whiteColor];
    _dateBackView = dateBackView;
    [self addSubview:dateBackView];
    
    //UIDatePicker高度默认216
    UIDatePicker *datePicker = [UIDatePicker new];
    if (MainR.size.width < 768)
    {
        datePicker.frame = CGRectMake(10, 20, dateBackView.frame.size.width-20, 216);
    }else
    {
        datePicker.frame = CGRectMake(50, 20, dateBackView.frame.size.width-100, 216);
    }
    datePicker.backgroundColor = [UIColor whiteColor];
    // 设置区域为中国简体中文
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    // 设置picker的显示模式：只显示日期
    datePicker.datePickerMode = _datePickerMode;
    
    //默认为当天
    [datePicker setCalendar:[NSCalendar currentCalendar]];
    
    _datePicker = datePicker;
    [dateBackView addSubview:datePicker];
    
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
    //cancelBtn.layer.borderWidth = 1;
   //cancelBtn.layer.borderColor = BLUECOLOR.CGColor ;
    [cancelBtn setTitleColor:BLUECOLOR forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelSelect) forControlEvents:UIControlEventTouchUpInside];
    _cancelBtn = cancelBtn;
    [dateBackView addSubview:cancelBtn];
    //确定
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(btn_w,dateBackView.frame.size.height-50,btn_w,50);;
   // sureBtn.layer.borderWidth = 1;
    //sureBtn.layer.borderColor = BLUECOLOR.CGColor ;
    [sureBtn setTitleColor:BLUECOLOR forState:UIControlStateNormal];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(selectedDate:) forControlEvents:UIControlEventTouchUpInside];
    _sureBtn = sureBtn;
    [dateBackView addSubview:sureBtn];
}

//日期选择
-(void)selectedDate:(UIButton *)btn
{
    if (_dateSelectBlock) {
        _dateSelectBlock([_datePicker date]);
        
    }
    [self fadeOut];

}
-(void)cancelSelect
{
    if (_cancelSelectBlock) {
        _cancelSelectBlock([_datePicker date]);
    }
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
//    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
//    self.alpha = 0;
//    [UIView animateWithDuration:.35 animations:^{
//        self.alpha = 1;
//        self.transform = CGAffineTransformMakeScale(1, 1);
//    }];
    // 放大-缩小 动画
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    NSMutableArray *values = [NSMutableArray array];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [_dateBackView.layer addAnimation:animation forKey:nil];
}
-(void)fadeOut
{
    /**
     *  消失动画
     */
//    [UIView animateWithDuration:.35 animations:^{
//        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
//        self.alpha = 0.0;
//    } completion:^(BOOL finished) {
//        if (finished)
//        {
//            [self removeFromSuperview];
//        }
//    }];
    //缩小消失
    [UIView animateWithDuration:0.5 animations:^{
        _dateBackView.transform = CGAffineTransformMakeScale(0.005, 0.005);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished)
        {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark -- touch

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_cancelSelectBlock) {
        _cancelSelectBlock([_datePicker date]);
    }
    [self fadeOut];
}

@end
