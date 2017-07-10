//
//  global.h
//  topSilderBar
//
//  Created by dingru Wu on 16/7/7.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif

#define color(r,g,b,al) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:al]
#define appTintColor [UIColor colorWithRed:0.0/255.0 green:162.0/255.0 blue:154.0/255.0 alpha:1]
#define appBackgroundColor [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]
#define SCREEN_H [UIScreen mainScreen].bounds.size.height
#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define BGFont(size) [UIFont systemFontOfSize:size]
#define BigSize 20.0
#define NormalSize 17.0

@interface MyGlobal : NSObject

/**
 适配各个屏幕尺寸宽 函数
 */
+(CGFloat)adaptScreenWidth:(CGFloat)width;
/**
 适配各个屏幕尺寸高 函数
 */
+(CGFloat)adaptScreenHeight:(CGFloat)height;
/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;

@end
