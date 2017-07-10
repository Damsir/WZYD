//
//  SearchResultVC.h
//  XAYD
//
//  Created by songdan Ye on 16/4/19.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultVC : UIViewController
//所有数据
@property (nonatomic,strong) NSMutableArray *dataSourceArray;
//搜索结果显示的tableView
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSString *quryStr;

@end
