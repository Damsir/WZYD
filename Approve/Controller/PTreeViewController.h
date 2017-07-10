//
//  PTreeViewController.h
//  XAYD
//
//  Created by songdan Ye on 15/12/28.
//  Copyright © 2015年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComprehensiveModel.h"
@class SPDetailModel;
@interface PTreeViewController : UIViewController

@property (nonatomic,strong)UIScrollView *sv;

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic, strong) NSArray *arrayOriginal;
@property (nonatomic, strong) NSArray *datasource;

@property (nonatomic, strong) NSMutableArray *arForTable;
@property (nonatomic,strong)SPDetailModel * model;
@property (nonatomic,strong)searchResultModel *compreModel;
@property (nonatomic,assign) BOOL isCompre;


//-(void)miniMizeThisRows:(NSArray*)ar;


@end
