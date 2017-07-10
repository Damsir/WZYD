//
//  PopSignUtil.m
//  popSign
//
//  Created by 吴定如 on 16/7/25.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "PopSignUtil.h"


static PopSignUtil *popSignUtil = nil;

@implementation PopSignUtil{
    
    UIButton *okBtn;
    UIButton *cancelBtn;
    //遮罩层(蒙版)
    UIView *zhezhaoView;
    DrawSignView *drawSignView;
}


//取得单例实例(线程安全写法)
+(id)shareRestance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        popSignUtil = [[PopSignUtil alloc]init];
    });
    return popSignUtil;
}


/** 构造函数 */
-(id)init{
    self = [super init];
    if (self) {
        //遮罩层(蒙版)
        zhezhaoView = [[UIView alloc]init];
        zhezhaoView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7];
    }
    return self;
}

//定制弹出框。模态对话框。
+(void)getSignWithVC:(UIViewController *)VC withOk:(SignCallBackBlock)signCallBackBlock
          withCancel:(CallBackBlock)callBackBlock{
    
    PopSignUtil *p = [PopSignUtil shareRestance];
    [p setPopWithVC:VC withOk:signCallBackBlock withCancel:callBackBlock];
}


/** 设定 **/
-(void)setPopWithVC:(UIViewController *)VC withOk:(SignCallBackBlock)signCallBackBlock
         withCancel:(CallBackBlock)cancelBlock{
    
    if (!zhezhaoView) {
        zhezhaoView = [[UIView alloc]init];
        zhezhaoView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7];
    }
    id<UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.window.rootViewController.view addSubview:zhezhaoView];
    CGSize screenSize = [appDelegate.window.rootViewController.view bounds].size;
    zhezhaoView.frame = CGRectMake(screenSize.width, 0, screenSize.width, screenSize.height);
    
    if (!drawSignView) {
        DrawSignView *conformView = [[DrawSignView alloc]init];
        //    [conformView setConformMsg:@"XXX" okTitle:@"确定" cancelTitle:@"取消"];
        //    conformView.yesB = yesB;
        //    conformView.noB = noB;
        conformView.cancelBlock = cancelBlock;
        conformView.signCallBackBlock  = signCallBackBlock;
        
        
        CGFloat v_x = (screenSize.width-conformView.frame.size.width)/2.0;
        CGFloat v_y = (screenSize.height-conformView.frame.size.height)/2.0;
        conformView.frame = CGRectMake( v_x, v_y, conformView.frame.size.width,conformView.frame.size.height);
        drawSignView = conformView;
        [zhezhaoView addSubview:conformView];
    }
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    zhezhaoView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
    [UIView commitAnimations];
}


/** 关闭弹出框 */
+(void)closePop{
    
    PopSignUtil *p = [PopSignUtil shareRestance];
    [p closePop];
}


/** 关闭弹出框 */
-(void)closePop{
    
    id<UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
    CGSize screenSize = [appDelegate.window.rootViewController.view bounds].size;
    [CATransaction begin];
    [UIView animateWithDuration:0.25f animations:^{
        zhezhaoView.frame = CGRectMake(screenSize.width, 0, screenSize.width, screenSize.height);
    } completion:^(BOOL finished) {
        //都关闭啊都关闭
        [zhezhaoView removeFromSuperview];
        [drawSignView removeFromSuperview];
        drawSignView = nil;
            }];
    [CATransaction commit];
}

+(void)screenRotationChangeFrame
{
    PopSignUtil *p = [PopSignUtil shareRestance];
    [p changeFrame];
}
-(void)changeFrame
{
    id<UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
    CGSize screenSize = [appDelegate.window.rootViewController.view bounds].size;
    zhezhaoView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
   // zhezhaoView.backgroundColor = [UIColor redColor];
    
    drawSignView.center = CGPointMake(zhezhaoView.frame.size.width/2, zhezhaoView.frame.size.height/2);
    CGFloat backView_w = MainR.size.width - 20;
    CGFloat backView_h = 0.33 * backView_w + 140;
    drawSignView.bounds = CGRectMake(0, 0, backView_w, backView_h);
    [drawSignView screenRotationChangeFrame];
   
}

@end
