//
//  PopSignUtil.h
//  popSign
//
//  Created by 吴定如 on 16/7/25.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawSignView.h"



@interface PopSignUtil : UIView



@property(nonatomic,copy)CallBackBlock noB;

+(void)getSignWithVC:(UIViewController *)VC withOk:(SignCallBackBlock)signCallBackBlock
          withCancel:(CallBackBlock)callBackBlock;
+(void)closePop;
//横竖屏适配
+(void)screenRotationChangeFrame;

@end

