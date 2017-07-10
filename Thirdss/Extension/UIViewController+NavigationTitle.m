//
//  UIViewController+NavigationTitle.m
//  WZYD
//
//  Created by 吴定如 on 16/11/23.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "UIViewController+NavigationTitle.h"

@implementation UIViewController (NavigationTitle)

//导航栏标题
-(void)initNavigationBarTitle:(NSString *)title
{
    UILabel *lab      = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    lab.textColor     = [UIColor whiteColor];
    lab.font          = [UIFont boldSystemFontOfSize:18.0];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text          = title;
    
    self.navigationItem.titleView = lab;
}


@end
