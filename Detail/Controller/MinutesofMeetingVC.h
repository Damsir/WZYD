//
//  MinutesofMeetingVC.h
//  XAYD
//
//  Created by songdan Ye on 16/5/16.
//  Copyright © 2016年 dist. All rights reserved.
//会议纪要

#import <UIKit/UIKit.h>
@class SHMeetingModel;
@interface MinutesofMeetingVC : UIViewController

@property (nonatomic,strong) UITableView *formTabelV;


@property (nonatomic,strong) UINavigationController *nav;
@property (nonatomic,strong) UITabBarController *tab;
//会议模型
@property (nonatomic,strong)SHMeetingModel *mDatas;
@end
