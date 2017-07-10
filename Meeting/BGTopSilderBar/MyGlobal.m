//
//  global.m
//  topSilderBar
//
//  Created by dingru Wu on 16/7/7.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "MyGlobal.h"

@implementation MyGlobal

/**
 适配各个屏幕尺寸宽函数
 */
+(CGFloat)adaptScreenWidth:(CGFloat)width{
    if(SCREEN_W == 320){//iphone4/5
        width = (320.0/375.0)*width;
    }else if(SCREEN_W == 375){//iphone6
        
    }else if (SCREEN_W == 414){//iphone6sp
        width = (414.0/375.0)*width;
    }else;
    return width;
}
/**
 适配各个屏幕尺寸高函数
 */
+(CGFloat)adaptScreenHeight:(CGFloat)height{
    if (SCREEN_H == 568) {//iphone5
        height = (568.0/667.0)*height;
    }else if (SCREEN_H == 667){//iphone6
        
    }else if (SCREEN_H == 736) {//iphone6sp
        height = (736.0/667.0)*height;
    }else if(SCREEN_H == 480){//iphone4s
        height = (480.0/667.0)*height;
    }else;
    return height;
}

/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end
