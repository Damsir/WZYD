//
//  AnnouncementDetailVC.h
//  XAYD
//
//  Created by dist on 16/4/18.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnnoModel.h"

@interface AnnouncementDetailVC : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webViewAnnou;

@property(strong,nonatomic) AnnoModel *anModel;
@property (nonatomic,strong)UINavigationController *nav;
@property (nonatomic,strong)UITabBarController *tab;

- (void)tranNav:(UINavigationController *)nav andTabBar:(UITabBarController *)tab;
//@property (nonatomic,strong)NSString *content;

@end
