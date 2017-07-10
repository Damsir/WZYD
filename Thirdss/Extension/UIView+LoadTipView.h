//
//  UIView+LoadTipView.h
//  WZYD
//
//  Created by 吴定如 on 16/11/11.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LoadTipView)

/**
 *  说明 @param style
 *
 *   style = 0 或者 style = nil (只有SuperView)
 *   style = 1 (只有 Navigation)
 *   style = 2 (有 Navigation 和 HeaderSegment)
 *
 */

- (void)showJiaZaiWithBool:(BOOL)isShow WithTitle:(NSString *)title WithAnimation:(BOOL)isHave WithSuperViewStyle:(NSInteger)style ;


@end
