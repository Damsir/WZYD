//
//  SHPushVCAnimation.h
//  XAYD
//
//  Created by songdan Ye on 16/3/4.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/**转场动画特效*/
typedef NS_ENUM(NSInteger,SHAnimationType)
{
SHAnimationTypeCameral = 0,//相机
    SHAnimationTypeCube ,//立方体
    SHAnimationTypeFade,//淡入
    SHAnimationTypeMoveIn,//移入
    SHAnimationTypeFlip,//翻转
    SHAnimationTypeCurl,//翻页
    SHAnimationTypeUncurl,//添页
    SHAnimationTypePush,//平移
    SHAnimationTypeReveal,//移走
    SHAnimationTypeRipple,//水波
    SHAnimationTypeSuck,//收起
    
};


/**动画方向*/

typedef NS_ENUM(NSInteger,SHAnimationDirection)
{
    SHAnimationDirectionLdft = 0,
    SHAnimationDirectionRight,
    SHAnimationDirectionTop,
    SHAnimationDirectionDown,

};
/**添加转场动画的类*/
@interface SHPushVCAnimation : NSObject


/**
 *  添加转场动画
 *
 *  @param destinationView 动画添加到这个视图上
 *  @param animationType   动画类型
 *  @param direction       方向
 *  @param duration        持续时间
 */

/**添加动画效果*/

+(void)addAnimationOnView:(UIView *)destinationView animation:(SHAnimationType)animationType direction:(SHAnimationDirection)direction duration:(CGFloat)duration;


@end
