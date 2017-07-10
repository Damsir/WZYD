//
//  StatisticsVController.h
//  XAYD
//
//  Created by songdan Ye on 16/1/4.
//  Copyright © 2016年 dist. All rights reserved.
//收发统计

#import <UIKit/UIKit.h>

@interface StatisticsVController : UIViewController<UISearchBarDelegate>
{
    
    int mode; // 0:普通 1:搜索
}
@property (strong,nonatomic)UINavigationController *nav;
@property (strong, nonatomic) UIView *TView;
@property (strong, nonatomic)UITableView *tableView;


@end
