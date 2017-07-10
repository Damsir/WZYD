//
//  CyHistory.h
//  XAYD
//
//  Created by songdan Ye on 16/5/24.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SPDetailModel;
@class CYQYModel;
@class CYQYAllModel;
@interface CyHistory : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong) NSArray *datasource;

@property (nonatomic,strong)SPDetailModel *model;
@property (nonatomic,strong)CYQYModel *cqModel;
@property (nonatomic,strong)CYQYAllModel *cqAllmodel;
//区分在办/已办/传阅/签阅
@property(nonatomic,strong)NSString *dataType;
//区分是传阅记录/签阅记录
@property(nonatomic,strong)NSString *forwardType;


@property (nonatomic,strong) UINavigationController *nav;



@end
