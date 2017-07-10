//
//  PickerView.h
//  WZYD
//
//  Created by 吴定如 on 16/11/10.
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
 //取消回调
 _datePicker.cancelSelectBlock = ^(NSDate *date)
 {
 
 };
 
 */

#import <UIKit/UIKit.h>

@interface PickerView : UIView

// 日期选择后的回调
@property(nonatomic,strong) void(^sendMicroblogBlock)(NSString *content);
// 区分不同控制器调用
@property(nonatomic,strong) NSString *pickerType;

// 初始化视图
- (void)showInView:(UIView *)superView animated:(BOOL)animated;
// 退出/退出动画
- (void)fadeIn;
- (void)fadeOut;

- (instancetype)initWithFrame:(CGRect)frame pickerType:(NSString *)pickerType;
//-(void)screenRotation;

@end
