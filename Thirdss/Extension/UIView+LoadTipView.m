

//
//  UIView+LoadTipView.m
//  WZYD
//
//  Created by 吴定如 on 16/11/11.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "UIView+LoadTipView.h"

#define SCREEN_WIDTH   [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height
#define LoadTip_Tag 6666
#define MaskView_Tag 1111
#define Navigation_H 64.0
#define HearderSegment_H 50.0

@implementation UIView (LoadTipView)

- (void)showJiaZaiWithBool:(BOOL)isShow WithTitle:(NSString *)title WithAnimation:(BOOL)isHave WithSuperViewStyle:(NSInteger)style
{
    // 监听屏幕旋转的通知
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    if (isShow)
    {
        // 第一层级 用来做透明度
        UIView *maskView = [self viewWithTag:MaskView_Tag] ;
        if (maskView)
        {
            return ;
        }
        maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)] ;
        maskView.tag = MaskView_Tag;
       // maskView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.2];
        maskView.backgroundColor = [UIColor clearColor];
        [self addSubview:maskView] ;
        
        // 第二层级 菊花背景
        UIView *backView = [self viewWithTag:LoadTip_Tag] ;
        if (backView)
        {
            return ;
        }
        backView = [[UIView alloc] init];
        backView.tag = LoadTip_Tag;
        if (SCREEN_WIDTH >= 768)
        {
            backView.frame = CGRectMake(0, 0, 120, 100);
        }
        else
        {
            backView.frame = CGRectMake(0, 0, 100, 80);
        }
        backView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-Navigation_H);
        
        // 各种父视图情况不同,中心也不一样
//        if (style == 0)
//        {
//            backView.center = self.center;
//        }
//        else if (style == 1)
//        {
//            backView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-Navigation_H);
//        }
//        else if (style == 2)
//        {
//            backView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-Navigation_H-HearderSegment_H);
//        }
        
        backView.layer.cornerRadius = 10 ;
        backView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:1.0] ;
        [self addSubview:backView];
        
        
//        
//        NSDictionary *dic = @{@"style":[NSString stringWithFormat:@"%ld",(long)style]};
//        [[NSNotificationCenter defaultCenter] postNotificationName:UIDeviceOrientationDidChangeNotification object:nil userInfo:dic];
        
        // 第二层级 菊花
        //        UIView * blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 100)] ;
        //        blackView.layer.cornerRadius = 10 ;
        //        blackView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:1.0] ;
        //        blackView.center = self.center;
        //        [self addSubview:blackView] ;
        
        
        
        // 第三层级 菊花
        if (!isHave)
        {
            UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] ;
            // 菊花颜色
            //activity.color = BLUECOLOR;
            activity.center = CGPointMake(backView.frame.size.width/2, backView.frame.size.height/2-15) ;
            if (SCREEN_WIDTH < 768)
            {
                activity.center = CGPointMake(backView.frame.size.width/2, backView.frame.size.height/2-12) ;
            }
            //
            activity.tag = style;
            
            [activity startAnimating] ;
            [backView addSubview:activity] ;
        }
        
        else
        {
            NSMutableArray *imagesArray = [NSMutableArray array];
            for (int i=0; i<6; i++)
            {
                NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"loading_%d.png",i] ofType:nil];
                UIImage *image = [UIImage imageWithContentsOfFile:path];
                [imagesArray addObject:image];
            }
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
            imageView.center = CGPointMake(backView.frame.size.width/2, backView.frame.size.height/2-10) ;
            [backView addSubview:imageView];
            
            imageView.animationImages = imagesArray;
            imageView.animationDuration = 1;
            [imageView startAnimating];
            
        }
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, backView.frame.size.width,20)];
        lab.text = title;
        lab.textColor = [UIColor whiteColor];
        lab.font = [UIFont boldSystemFontOfSize:16.0];
        lab.center = CGPointMake(backView.frame.size.width/2, backView.frame.size.height/2+25);
        if (SCREEN_WIDTH < 768)
        {
            lab.font = [UIFont boldSystemFontOfSize:14.0];
            lab.center = CGPointMake(backView.frame.size.width/2, backView.frame.size.height/2+22);
        }
        
        lab.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:lab];
        
        //加到最上层
        [self bringSubviewToFront:backView];
        
    }
    else
    {
        UIView *maskView = [self viewWithTag:MaskView_Tag];
        [maskView removeFromSuperview];
        
        UIView *backView = [self viewWithTag:LoadTip_Tag] ;
        [backView removeFromSuperview] ;
        
    }
    
}

// 屏幕旋转改变视图通知
-(void)screenRotation:(NSNotification *)noti
{
//    NSDictionary *dic = noti.userInfo;
//    if (dic)
//    {
//        NSInteger style = [[dic objectForKey:@"style"] integerValue];
//        // 菊花背景
//        UIView * backView = [self viewWithTag:LoadTip_Tag] ;
//       
//        // 各种父视图情况不同,中心也不一样
//        if (style == 0)
//        {
//            backView.center = self.center;
//        }
//        else if (style == 1)
//        {
//            backView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-Navigation_H);
//        }
//        else if (style == 2)
//        {
//            backView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-Navigation_H-HearderSegment_H);
//        }
//    }
    
    // 蒙版
    UIView *maskView = [self viewWithTag:MaskView_Tag];
    maskView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    // 菊花背景
    UIView * backView = [self viewWithTag:LoadTip_Tag];
    if (SCREEN_WIDTH >= 768)
    {
        backView.frame = CGRectMake(0, 0, 120, 100);
    }
    else
    {
        backView.frame = CGRectMake(0, 0, 100, 80);
    }
    backView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-Navigation_H);
    
}

@end

