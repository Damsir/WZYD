//
//  MeetingmaterialVC.h
//  XAYD
//
//  Created by songdan Ye on 16/5/19.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SPDetailModel;
@interface MeetingmaterialVC : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong) NSArray *datasource;

@property (nonatomic,strong)SPDetailModel *model;
@property (nonatomic,strong) UINavigationController *nav;


@end
