//
//  HomeView.h
//  ShowProduct
//
//Created by songdan Ye on 15/12/28.
//  Copyright © 2015年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuHrizontal.h"
#import "ScrollPageView.h"
#import "baseMessageVC.h"
#import "ComprehensiveModel.h"
@class SPDetailModel;

@interface HomeView : UIView<MenuHrizontalDelegate,ScrollPageViewDelegate>


@property (nonatomic,strong)ScrollPageView *mScrollPageView;
@property (nonatomic,strong)MenuHrizontal *mMenuHriZontal;
@property (nonatomic,strong) NSDictionary *data;
@property(nonatomic,strong)SPDetailModel *model;

@property (nonatomic,strong)ComprehensiveModel *compreModel;
@property (nonatomic,assign)BOOL isCompre;
@property (nonatomic,strong)UINavigationController *nav;
@property (nonatomic,strong)UITabBarController *tab;

@property (nonatomic,strong)BaseMessageVC *baseMessage;



- (void) transFormData:(NSDictionary *)data;
- (void)transFormModel:(SPDetailModel *)spDtailModel;
- (void)transFormCompreModel:(ComprehensiveModel *)compreModel;

- (void) commInit;
- (void)transNav:(UINavigationController *)nav;
- (void)transTab:(UITabBarController *)tab;


@end
