//
//  BaseMessageVC.h
//  XAYD
//
//  Created by dingru Wu on 16/7/19.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendViewController.h"
#import "ComprehensiveModel.h"
@class SPDetailModel;

@interface BaseMessageVC : UIViewController<SendViewDelegate>

//区分是在办还是已办
@property(nonatomic,strong) NSString *Id;
//@property(nonatomic,strong) NSString *projectId;
//@property(nonatomic,strong) NSString *activityName;


//模型数据
@property (nonatomic,strong) SPDetailModel *model;

//综合查询模型
@property (nonatomic,strong) searchResultModel *compModel;

@property (nonatomic,assign) BOOL isComp;
@property (nonatomic,strong) UINavigationController *nav;
@property (nonatomic,strong) NSDictionary *data;

@property (strong,nonatomic) id<SendViewDelegate> sendDelegate;

// 区分 项目办理(审批),项目查询 or 公文
@property(nonatomic,strong) NSString *spOrgw;


@end
