//
//  SPDetailVC.h
//  XAYD
//
//  Created by songdan Ye on 16/3/7.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "BaseListViewController.h"
//#import "ListView.h"
#import "MJRefresh.h"
#import <UIKit/UIKit.h>
#import "SendViewController.h"


@interface SPDetailVC : BaseListViewController<UITableViewDataSource,UITableViewDelegate,SendViewDelegate,UISearchBarDelegate>
{
    UIButton *openMaterialBtn;
    int mode; // 0:普通 1:搜索
    
}
//在办,已办,督办
@property (nonatomic,copy)NSString *docProperty;
@property (strong, nonatomic) UITableView *spDetailTableView;


@end
