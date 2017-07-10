//
//  PrintFromViewController.h
//  XAYD
//
//  Created by songdan Ye on 15/12/28.
//  Copyright © 2015年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComprehensiveModel.h"
@class SPDetailModel;
@interface PrintFromViewController : UIViewController
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic, retain) NSArray *arrayOriginal;
@property (nonatomic, retain) NSMutableArray *arForTable;
@property (nonatomic, strong) NSArray *datasource;

@property (strong,nonatomic)UINavigationController *nav;
@property (strong,nonatomic)UITabBarController *tab;


@property (nonatomic,strong) SPDetailModel *model;
@property (nonatomic,strong) searchResultModel *compreModel;
@property (nonatomic,assign) BOOL isCompre;
@end
