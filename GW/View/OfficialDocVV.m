//
//  OfficialDocVV.m
//  XAYD
//
//  Created by songdan Ye on 16/4/1.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "OfficialDocVV.h"
//#define MENUHEIHT 37

@implementation OfficialDocVV
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
                                   TITLEKEY:@"收文",
                                   TITLEWIDTH:[NSNumber numberWithFloat:60]
                                   },
                                 
                                 @{NOMALKEY: @"normal 2",
                                   HEIGHTKEY:@"price-bg",
                                   TITLEKEY:@"发文",
                                   TITLEWIDTH:[NSNumber numberWithFloat:60]
                                   }
                                
                                 ];
    
    
   
//        UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, 1)];
//        line.backgroundColor =RGB(238.0, 238.0, 238.0);
//        [self addSubview:line];
  
    
    if (_mMenuHriZontal == nil) {
        _mMenuHriZontal = [[MHrizontal alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 37) ButtonItems:buttonItemArray];
        
        
        _mMenuHriZontal.delegate = self;
        
    }
    //初始化滑动列表
    if (_mScrollPageView == nil) {
        _mScrollPageView = [[ScrollPageView alloc] initWithFrame:CGRectMake(0, 37, self.frame.size.width, self.frame.size.height - 37)];
        _mScrollPageView.nav = self.nav;
        _mScrollPageView.delegate = self;
    }
    
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
#pragma mark - 其他辅助功能
#pragma mark MenuHrizontalDelegate
-(void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)aIndex{
    //让scrollPageView移到指定页
    [_mScrollPageView moveScrollowViewAthIndex:aIndex];
    
    
}

#pragma mark   ScrollPageViewDelegate
-(void)didScrollPageViewChangedPage:(NSInteger)aPage{
    NSDictionary *dict =[NSDictionary dictionary];
    dict= @{@"tag":[NSString stringWithFormat:@"%ld",aPage]};
    //创建通知,发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"seleBtnIndex" object:nil userInfo:dict];
    //让对应按钮被选中按钮
    [_mMenuHriZontal changeButtonStateAtIndex:aPage];
    //刷新当页数据
    [_mScrollPageView freshContentTableAtIndex:aPage];
    
}

//重新布局
-(void)layoutSubviews{
    [super layoutSubviews];
    
//    _mScrollPageView.frame = CGRectMake(0, 37, self.frame.size.width, self.frame.size.height - 37);
//    _mMenuHriZontal.frame =CGRectMake(0, 0, SCREEN_WIDTH, 37);
    
    
    if (self.mScrollPageView.openSB) {
        _mScrollPageView.frame =CGRectMake(0, 37+44, self.frame.size.width, self.frame.size.height - 37);
        _mMenuHriZontal.frame =CGRectMake(0, 0, SCREEN_WIDTH, 37);
        _mScrollPageView.openSB = YES;
        
    }
    else
    {
        
        _mScrollPageView.frame =CGRectMake(0, 37, self.frame.size.width, self.frame.size.height - 37);
        _mMenuHriZontal.frame =CGRectMake(0, 0, SCREEN_WIDTH, 37);
        _mScrollPageView.openSB = NO;
    }
    
}




@end
