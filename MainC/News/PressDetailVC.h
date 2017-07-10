//
//  PressDetailVC.h
//  XAYD
//
//  Created by songdan Ye on 16/5/23.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "pressModel.h"
@interface PressDetailVC : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webViewNews;
@property (nonatomic,strong)UINavigationController *nav;
@property (nonatomic,strong)UITabBarController *tab;
@property (nonatomic,strong)pressModel *pmodel;

- (void)transNav:(UINavigationController *)nav andTab:(UITabBarController *)tab;
@end
