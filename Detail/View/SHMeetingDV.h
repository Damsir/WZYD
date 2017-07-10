//
//  SHMeetingDV.h
//  XAYD
//
//  Created by songdan Ye on 16/5/12.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHrizontal.h"
#import "ScrollPageView.h"
#import "SHMeetingModel.h"
@interface SHMeetingDV : UIView<MHrizontalDelegate,ScrollPageViewDelegate>

@property (nonatomic,strong)MHrizontal *mMenuHriZontal;
@property (nonatomic,strong)ScrollPageView *mScrollPageView;
@property (nonatomic,strong)UINavigationController *nav;
@property (nonatomic,strong)UITabBarController *tab;
//会议模型
@property (nonatomic,strong)SHMeetingModel *mDatas;
- (void) transNav:(UINavigationController *)nav;
- (void) transTab:(UITabBarController  *)tab;

- (void)getMDatas:(SHMeetingModel *)model;



@end
