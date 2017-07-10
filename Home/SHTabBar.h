//
//  SHTabBar.h
//  XAYD
//
//  Created by songdan Ye on 16/2/23.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SHTabBar;
@protocol SHTabBarDelegate <NSObject>

@optional
- (void)tabBar:(SHTabBar *)tabBar didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to;

@end

@interface SHTabBar : UIView
- (void)addTabBarButtonWithItem:(UITabBarItem *)item;

@property (nonatomic, weak) id<SHTabBarDelegate> delegate;

@end
