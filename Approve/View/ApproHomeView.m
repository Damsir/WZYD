//
//  ApproHomeView.m
//  XAYD
//
//  Created by songdan Ye on 16/4/8.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "ApproHomeView.h"
#define MENUHEIHT 50

@implementation ApproHomeView

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
                                   TITLEKEY:@"在办箱",
                                   TITLEWIDTH:[NSNumber numberWithFloat:60]
                                   },
                                 
                                 @{NOMALKEY: @"normal 2",
                                   HEIGHTKEY:@"price-bg",
                                   TITLEKEY:@"已办箱",
                                   TITLEWIDTH:[NSNumber numberWithFloat:60]
                                   },
//                                 @{NOMALKEY: @"normal 2",
//                                   HEIGHTKEY:@"price-bg",
//                                   TITLEKEY:@"督办箱",
//                                   TITLEWIDTH:[NSNumber numberWithFloat:60]
//                                   }
                                 ];
    
    if (_approMenuHriZontal == nil) {
        _approMenuHriZontal = [[MHrizontal alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MENUHEIHT) ButtonItems:buttonItemArray];
        //添加下划线
        UIView *lineView =[[UIView alloc] initWithFrame:CGRectMake(0, MENUHEIHT-1, SCREEN_WIDTH, 1)];
        lineView.backgroundColor =[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    
        [self addSubview:lineView];
        
        _approMenuHriZontal.delegate = self;
        
    }
    //初始化滑动列表
    if (_approScrollPageView == nil) {
        _approScrollPageView = [[ScrollPageView alloc] initWithFrame:CGRectMake(0, MENUHEIHT, self.frame.size.width, self.frame.size.height - MENUHEIHT)];
        _approScrollPageView.nav = self.nav;
        _approScrollPageView.delegate = self;
    }
    
    //设置ScrollViewview的子视图
    [_approScrollPageView setContentOfTables:buttonItemArray];
    
    //默认选中第一个button
    [_approMenuHriZontal clickButtonAtIndex:0];
    
    [self addSubview:_approScrollPageView];
    
    [self addSubview:_approMenuHriZontal];
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
    [_approScrollPageView moveScrollowViewAthIndex:aIndex];
    
    
}

#pragma mark   ScrollPageViewDelegate
-(void)didScrollPageViewChangedPage:(NSInteger)aPage{
    NSDictionary *dict =[NSDictionary dictionary];
    dict= @{@"tag":[NSString stringWithFormat:@"%d",aPage]};
    //创建通知,发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedButtonIndex" object:nil userInfo:dict];
    //让对应按钮被选中按钮
    [_approMenuHriZontal changeButtonStateAtIndex:aPage];
    //刷新当页数据
    [_approScrollPageView freshContentTableAtIndex:aPage];
    
}


-(void)layoutSubviews{
[super layoutSubviews];
    if (self.approScrollPageView.openSB) {
        _approScrollPageView.frame =CGRectMake(0, MENUHEIHT+44, self.frame.size.width, self.frame.size.height - MENUHEIHT);
        _approMenuHriZontal.frame =CGRectMake(0, 0, SCREEN_WIDTH, MENUHEIHT);
        _approScrollPageView.openSB = YES;

    }
    else
    {
    
    _approScrollPageView.frame =CGRectMake(0, MENUHEIHT, self.frame.size.width, self.frame.size.height - MENUHEIHT);
    _approMenuHriZontal.frame =CGRectMake(0, 0, SCREEN_WIDTH, MENUHEIHT);
        _approScrollPageView.openSB = NO;
    }
}





@end
