//
//  NewsVC.h
//  XAYD
//
//  Created by songdan Ye on 16/2/17.
//  Copyright © 2016年 dist. All rights reserved.
//新闻

#import <UIKit/UIKit.h>
//#import "baseTable.h"

@interface NewsVC : UIViewController<UISearchBarDelegate>

@property (nonatomic,strong)UINavigationController *nav;
@property (nonatomic,strong)UITabBarController *tab;

//新闻数组
@property (nonatomic,strong)NSArray *presses;


@property (nonatomic,strong)UITableView *tabView;

@end
