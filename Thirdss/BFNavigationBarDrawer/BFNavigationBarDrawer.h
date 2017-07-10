//
//  BFNavigationBarDrawer.h
//  XAYD
//
//  Created by 孙王威 on 15/9/1.
//  Copyright (c) 2015年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFNavigationBarDrawer : UIToolbar

@property (nonatomic, readonly, getter=isVisible) BOOL visible;
@property (nonatomic) UIScrollView *scrollView;

- (void)showFromNavigationBar:(UINavigationBar *)bar animated:(BOOL)animated;
- (void)hideAnimated:(BOOL)animated;

@end
