//
//  HourDatePicker.h
//  WZYD
//
//  Created by 吴定如 on 16/10/27.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HourDatePicker : UIView

// 日期选择后的回调
@property(nonatomic,strong) void(^dateSelectBlock)(NSInteger year,NSInteger month);

// 初始化视图
- (void)showInView:(UIView *)superView animated:(BOOL)animated;
// 退出/退出动画
- (void)fadeIn;
- (void)fadeOut;

-(void)screenRotation;

@end
