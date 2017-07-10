//
//  MeetingViewController.h
//  XAYD
//
//  Created by dingru Wu on 15/8/3.
//  Copyright (c) 2015年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "baseViewController.h"
@class SHSummaryController;

@interface MeetingViewController : baseViewController

@property (nonatomic, strong) NSMutableArray *subContentL;
@property (nonatomic, strong) NSMutableArray *subContentI;
@property (nonatomic, strong) NSMutableArray *subContentW;

@property (nonatomic,strong) SHSummaryController *summary;


-(void)loadMyDataAndInitCalendarView;

@end
