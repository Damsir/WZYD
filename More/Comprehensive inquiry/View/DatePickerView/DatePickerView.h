//
//  DatePickerView.h
//  KSYD
//
//  Created by 吴定如 on 16/8/4.
//  Copyright © 2016年 dist. All rights reserved.
//
/**
 *  使用方法:
 DatePickerView *datePicker  = [[DatePickerView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, MainR.size.height) AndDatePickerMode:UIDatePickerModeDate];
 _datePicker = datePicker;
 [_datePicker showInView:self.view.window.rootViewController.view animated:YES];
 
 DefineWeakSelf(weakSelf);
 //选择回调
 _datePicker.dateSelectBlock = ^(NSDate *selectDate){
 
 }; 
 */


#import <UIKit/UIKit.h>

@interface DatePickerView : UIView

@property(nonatomic,assign) UIDatePickerMode datePickerMode;

@property(nonatomic,strong) void(^dateSelectBlock)(NSDate *selectDate);
@property(nonatomic,strong) void(^cancelSelectBlock)(NSDate *selectDate);

-(instancetype)initWithFrame:(CGRect)frame AndDatePickerMode:(UIDatePickerMode)datePickerMode;
// 初始化视图
- (void)showInView:(UIView *)superView animated:(BOOL)animated;
// 退出/退出动画
- (void)fadeIn;
- (void)fadeOut;

//屏幕旋转
-(void)screenRotation;

@end
