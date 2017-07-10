//
//  ScrollPageView.h
//  ShowProduct
//Created by songdan Ye on 15/12/28.
//  Copyright © 2015年 dist. All rights reserved.
//
//

#import <UIKit/UIKit.h>
#import "baseMessageVC.h"
#import "PLogViewController.h"
#import "PTreeViewController.h"
#import "MaterialViewController.h"
#import "PrintFromViewController.h"
#import "NewsVC.h"
#import "MatterIngVC.h"
#import "announcementVC.h"
#import "StatisticsVController.h"
#import "OffiDocDetaiVController.h"
#import "SendOffDocDetailVC.h"
//#import "SendViewController.h"
#import "ApproZBViewController.h"
#import "ApproYBViewController.h"
#import "ApproDBViewController.h"
#import "ComprehensiveModel.h"
#import "SHAgencyVController.h"
#import "MeetingDetailVC.h"
#import "MinutesofMeetingVC.h"
#import "MeetingMaterialVC.h"

#import "SHMeetingModel.h"

//#import "mee"
//#import

@protocol ScrollPageViewDelegate <NSObject>
-(void)didScrollPageViewChangedPage:(NSInteger)aPage;
@end

@interface ScrollPageView : UIView<UIScrollViewDelegate>
{
    BOOL mNeedUseDelegate;
}
//用来标记搜索按钮收回和弹出搜索框
@property (nonatomic,assign,getter=isOpenSB) BOOL openSB;



@property(nonatomic,assign) NSInteger mCurrentPage;
//@property (nonatomic,strong)messageVC *messageVC;
@property (nonatomic,strong)BaseMessageVC *basemVC;

//审批主页
@property (nonatomic,strong)ApproZBViewController *approZB;
@property (nonatomic,strong)ApproYBViewController *approYB;
@property (nonatomic,strong)ApproDBViewController *approDB;

//审批详情
@property (nonatomic,strong)PLogViewController *pLogVC;
@property (nonatomic,strong)PTreeViewController *pTreeVC;
@property (nonatomic,strong)MaterialViewController *materialVC;
@property (nonatomic,strong)PrintFromViewController *printVC;


//主页
@property (nonatomic,strong)NewsVC *press;
@property (nonatomic,strong)MatterIngVC *matterVC;
@property (nonatomic,strong)announcementVC *annVC;
@property (nonatomic,strong)StatisticsVController *staticVC;
@property (nonatomic,retain) UIScrollView *scrollView;


//会议
//会议详情
@property (nonatomic,strong)MeetingDetailVC *meetingDetail;
//会议纪要
@property (nonatomic,strong)MinutesofMeetingVC *minutesofM;
//会议资料
@property (nonatomic,strong)MeetingMaterialVC *meetMater;

//会议模型
@property (nonatomic,strong)SHMeetingModel *mDatas;





@property (nonatomic,retain) NSMutableArray *contentItems;
@property (nonatomic,strong) UINavigationController *nav;
@property (nonatomic,strong) UITabBarController *tab;

@property (nonatomic,retain) NSDictionary *data;


@property (nonatomic,strong)SPDetailModel *model;
//综合查询模型
@property (nonatomic,strong)ComprehensiveModel *compreModel;
//是否是综合查询
@property (nonatomic,assign)BOOL isCompre;


//公文
@property (nonatomic,strong) OffiDocDetaiVController *officialDetailVC;
@property (nonatomic,strong) SendOffDocDetailVC *sengOffDocVC;



@property (nonatomic,assign) id<ScrollPageViewDelegate> delegate;

#pragma mark 添加ScrollowViewd的ContentView
-(void)setContentOfTables:(NSInteger)aNumerOfTables;
#pragma mark 滑动到某个页面
-(void)moveScrollowViewAthIndex:(NSInteger)aIndex;
#pragma mark 刷新某个页面
-(void)freshContentTableAtIndex:(NSInteger)aIndex;
-(void)commInit;
@end
