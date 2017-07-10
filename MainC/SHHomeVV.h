//
//  SHHomeVV.h
//  XAYD
//
//  Created by songdan Ye on 16/1/7.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHrizontal.h"
#import "ScrollPageView.h"


@interface SHHomeVV : UIView<MHrizontalDelegate,ScrollPageViewDelegate>

@property (nonatomic,strong)MHrizontal *mMenuHriZontal;
@property (nonatomic,strong)ScrollPageView *mScrollPageView;
@property (nonatomic,strong)UINavigationController *nav;
@property (nonatomic,strong)UITabBarController *tab;


- (void) transNav:(UINavigationController *)nav;
- (void) transTab:(UITabBarController  *)tab;

@end
