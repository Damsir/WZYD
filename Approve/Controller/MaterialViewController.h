//
//  MaterialViewController.h
//  XAYD
//
//  Created by songdan Ye on 15/12/28.
//  Copyright © 2015年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SPDetailModel;
#import "ComprehensiveModel.h"
@interface MaterialViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong) NSArray *datasource;

@property (nonatomic,strong)SPDetailModel *model;

//综合查询模型
@property (nonatomic,strong)searchResultModel *compModel;

@property (nonatomic,assign)BOOL isComp;

@property (nonatomic,strong) UINavigationController *nav;


@end
