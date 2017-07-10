//
//  SHPushVCAnimation.m
//  XAYD
//
//  Created by songdan Ye on 16/3/4.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "SHPushVCAnimation.h"
#import <QuartzCore/QuartzCore.h>


@implementation SHPushVCAnimation
/**添加转场动画的类*/
+(void)addAnimationOnView:(UIView *)destinationView animation:(SHAnimationType)animationType direction:(SHAnimationDirection)direction duration:(CGFloat)duration
{
    NSArray *animations=@[
                          @"cameraIris",
                          @"cube",
                          @"fade",
                          @"moveIn",
                          @"oglFlip",
                          @"pageCurl",
                          @"pageUnCurl",
                          @"push",
                          @"reveal",
                          @"rippleEffect",
                          @"suckEffect"
                          ];
    NSArray *subTypes=@[
                        @"fromLeft",
                        @"fromRight",
                        @"fromTop",
                        @"fromBottom"
                        ];
    
    CATransition *transition=[CATransition animation];
    transition.duration=duration;
    transition.type=animations[animationType];
    transition.subtype=subTypes[direction];
    [destinationView.superview.layer addAnimation:transition forKey:nil];
    
    
}







@end
