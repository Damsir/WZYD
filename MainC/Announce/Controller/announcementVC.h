//
//  announcementVC.h
//  XAYD
//
//  Created by songdan Ye on 16/1/4.
//  Copyright © 2016年 dist. All rights reserved.
//局内公告..

#import <UIKit/UIKit.h>
#import "AnnouncementDetailVC.h"

@interface announcementVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    int mode; // 0:普通 1:搜索
}
@property (strong, nonatomic) UITableView *announceTableView;
@property (strong,nonatomic)UINavigationController *nav;
@property (nonatomic,strong)UITabBarController *tab;

@end
