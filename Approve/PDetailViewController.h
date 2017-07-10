//
//  PDetailViewController.h
//  XAYD
//
//  Created by songdan Ye on 15/12/28.
//  Copyright © 2015年 dist. All rights reserved.
//审批详情

#import <UIKit/UIKit.h>
#import "PLogViewController.h"
#import "PTreeViewController.h"
#import "MaterialViewController.h"
#import "PrintFromViewController.h"
#import "SPDetailModel.h"
#import "baseMessageVC.h"
//#import "HomeView.h"
#import "ComprehensiveModel.h"
#import "spBaseView.h"
@class messageVC,PLogViewController,PTreeViewController,MaterialViewController,PrintFromViewController,baseMessageVC;
@interface PDetailViewController : UIViewController
@property (nonatomic,strong) NSArray *sArray;

@property (nonatomic,strong)NSDictionary *project;

@property (nonatomic,strong)SPDetailModel *model;

@property (nonatomic,strong) searchResultModel *compreModel;


//@property (nonatomic,strong)messageVC *messageVC;
@property (nonatomic,strong)BaseMessageVC *baseMessage;

@property (nonatomic,strong)PLogViewController *pLogVC;
@property (nonatomic,strong)PTreeViewController *pTreeVC;
@property (nonatomic,strong)MaterialViewController *materialVC;
@property (nonatomic,strong)PrintFromViewController *printVC;
@property (nonatomic,strong)HomeView *mHomeView;

@property (nonatomic,strong)spBaseView *spBaseView;

// 是否是综合查询
@property (nonatomic,assign)BOOL isComp;

// 区分审批 or 公文
@property(nonatomic,strong) NSString *spOrgw;

- (void)initView;

@end
