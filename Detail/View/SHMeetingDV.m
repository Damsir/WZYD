//
//  SHMeetingDV.m
//  XAYD
//
//  Created by songdan Ye on 16/5/12.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "SHMeetingDV.h"

@implementation SHMeetingDV

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

#pragma mark UI初始化
-(void)commInit{
    
    NSArray *buttonItemArray = @[
                                 @{NOMALKEY: @"normal 2",
                                   HEIGHTKEY:@"price-bg",
                                   TITLEKEY:@"会议详情",
                                   TITLEWIDTH:[NSNumber numberWithFloat:60]
                                   },
                                 
                                 @{NOMALKEY: @"normal 2",
                                   HEIGHTKEY:@"price-bg",
                                   TITLEKEY:@"会议纪要",
                                   TITLEWIDTH:[NSNumber numberWithFloat:60]
                                   },
                                 @{NOMALKEY: @"normal 2",
                                   HEIGHTKEY:@"price-bg",
                                   TITLEKEY:@"会议资料",
                                   TITLEWIDTH:[NSNumber numberWithFloat:60]
                                   }
                                 ];
    
    if (_mMenuHriZontal == nil) {
        _mMenuHriZontal = [[MHrizontal alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MENUHEIHT) ButtonItems:buttonItemArray];
        //添加下划线
        UIView *lineView =[[UIView alloc] initWithFrame:CGRectMake(0, MENUHEIHT-0.5, SCREEN_WIDTH, 0.5)];
        lineView.backgroundColor =[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
        [self addSubview:lineView];
        
        _mMenuHriZontal.delegate = self;
        
    }
    //初始化滑动列表
    if (_mScrollPageView == nil) {
        _mScrollPageView = [[ScrollPageView alloc] initWithFrame:CGRectMake(0, MENUHEIHT, self.frame.size.width, self.frame.size.height - MENUHEIHT)];
       
    }
    _mScrollPageView.mDatas =self.mDatas;
    _mScrollPageView.tab =self.tab;
    _mScrollPageView.nav = self.nav;
    _mScrollPageView.delegate = self;
    
    //设置ScrollViewview的子视图
    [_mScrollPageView setContentOfTables:buttonItemArray];
    
    //默认选中第一个button
    [_mMenuHriZontal clickButtonAtIndex:0];
    
    [self addSubview:_mScrollPageView];
    
    [self addSubview:_mMenuHriZontal];
}

- (void)transNav:(UINavigationController *)nav
{
    self.nav=nav;
    [self commInit];
}
- (void)transTab:(UITabBarController *)tab
{
    self.tab=tab;
    
    
    
}


- (void)getMDatas:(SHMeetingModel *)model
{
    self.mDatas = model;

}



#pragma mark - 其他辅助功能
#pragma mark MenuHrizontalDelegate
-(void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)aIndex{
    //让scrollPageView移到指定页
    [_mScrollPageView moveScrollowViewAthIndex:aIndex];
    
    
}

#pragma mark   ScrollPageViewDelegate
-(void)didScrollPageViewChangedPage:(NSInteger)aPage{
       //让对应按钮被选中按钮
    [_mMenuHriZontal changeButtonStateAtIndex:aPage];
    //刷新当页数据
    [_mScrollPageView freshContentTableAtIndex:aPage];
    
}
@end
