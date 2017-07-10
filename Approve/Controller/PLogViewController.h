//
//  PLogViewController.h
//  XAYD
//
//  Created by songdan Ye on 15/12/28.
//  Copyright © 2015年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComprehensiveModel.h"
@class SPDetailModel;
@class CYQYModel;
@class MeetingMaterialModel;

@interface PLogViewController : UIViewController

@property (strong, nonatomic)  UITableView *btableView;
@property (nonatomic, assign, getter = isOpened) BOOL opened;

@property (nonatomic,strong)SPDetailModel *model;
@property (nonatomic,strong)searchResultModel *compreModel;

@property (nonatomic,strong)CYQYModel *cyModel;
@property (nonatomic,assign) BOOL isCompre;

@property (nonatomic,strong)NSArray *datasource;
//用来区分在办已办/传阅签阅
@property (nonatomic,strong)NSString *dataType;
// 区分审批 or 公文
@property(nonatomic,strong) NSString *spOrgw;

@end
