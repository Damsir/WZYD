//
//  ProgressView.m
//  WZYD
//
//  Created by 吴定如 on 16/11/11.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "ProgressView.h"

#define BACKVIEW_TAG 6666

@implementation ProgressView


- (void)showJiaZaiWithBool:(BOOL)isShow WithTitle:(NSString *)title WithAnimation:(BOOL)isHave
{
    //监听屏幕旋转的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    if (isShow)
    {
        self.frame = CGRectMake(0, 0, 120, 100);
        self.center = KeyWindow.center;
        self.layer.cornerRadius = 10 ;
        self.backgroundColor = [UIColor colorWithWhite:0.4 alpha:1.0] ;
        [KeyWindow addSubview:self];
        
        //第三层级 菊花
//        UIView * blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 100)] ;
//        blackView.layer.cornerRadius = 10 ;
//        blackView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:1.0] ;
//        blackView.center = self.center;
//        [self addSubview:blackView] ;
        
        
        if (!isHave)
        {
            UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] ;
            // 菊花颜色
            //activity.color = BLUECOLOR;
            activity.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2-15) ;
            [activity startAnimating] ;
            [self addSubview:activity] ;
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
            imageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2-10) ;
            [self addSubview:imageView];
            
            imageView.animationImages = imagesArray;
            imageView.animationDuration = 1;
            [imageView startAnimating];
            
        }
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,20)];
        lab.text = title;
        lab.textColor = [UIColor whiteColor];
        lab.font = [UIFont boldSystemFontOfSize:16];
        lab.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2+25);
        lab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lab];
        
        //加到最上层
       // [self bringSubviewToFront:self];
        
    }
    else
    {
        [self removeFromSuperview] ;
    }
}
// 屏幕旋转改变视图通知
-(void)screenRotation:(NSNotification *)noti
{
    self.center = KeyWindow.center;
}


@end
