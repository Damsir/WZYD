//
//  HomeView.m
//  ShowProduct
//
//Created by songdan Ye on 15/12/28.
//  Copyright © 2015年 dist. All rights reserved.
//

#import "HomeView.h"
#import "SPDetailModel.h"


//#define MENUHEIHT 37

@implementation HomeView

- (NSDictionary *)data
{
    
    if (_data ==nil) {
        _data= [NSDictionary dictionary];
    }
    return _data;

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"(%f,%f)(%f,%f)",self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height);

//        [self commInit];
            }
    return self;
}

- (void)transNav:(UINavigationController *)nav
{
    self.nav=nav;
    [self commInit];
}

- (void)transTab:(UITabBarController *)tab
{
    
    self.tab =  tab;
    
    
}

#pragma mark UI初始化
-(void)commInit{
    
    NSArray *buttonItemArray = @[@{NOMALKEY: @"normal 2",
                                    HEIGHTKEY:@"price-bg",
                                    TITLEKEY:@"项目信息",
                                    TITLEWIDTH:[NSNumber numberWithFloat:60]
                                    },
                                 @{NOMALKEY: @"normal 2",
                                   HEIGHTKEY:@"price-bg",
                                   TITLEKEY:@"材料清单",
                                   TITLEWIDTH:[NSNumber numberWithFloat:60]
                                   },

                                  ];
    CGFloat menuHeight = 0;
    if (MainR.size.width>414) {
        menuHeight= 10;
    }
    
    if (_mMenuHriZontal == nil) {
        _mMenuHriZontal = [[MenuHrizontal alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 37+menuHeight) ButtonItems:buttonItemArray];
//        _mMenuHriZontal.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navbar_background"]];
//        _mMenuHriZontal.backgroundColor =RGB(34, 152, 239);
        _mMenuHriZontal.backgroundColor =[UIColor whiteColor];
        _mMenuHriZontal.delegate = self;
        
    }
    //初始化滑动列表
    if (_mScrollPageView == nil) {
        
        _mScrollPageView = [[ScrollPageView alloc] initWithFrame:CGRectMake(0, 37+menuHeight, self.frame.size.width, self.frame.size.height- 37-menuHeight)];
        //把messageBaseView继续下传到scrollView
        _mScrollPageView.basemVC = self.baseMessage;
        
        _mScrollPageView.model = self.model;
        _mScrollPageView.compreModel = self.compreModel;
        _mScrollPageView.isCompre = self.isCompre;
        
        
        _mScrollPageView.delegate =self;
        _mScrollPageView.nav = self.nav;
        _mScrollPageView.tab =self.tab;
    
        [_mScrollPageView commInit];

    }
    //设置ScrollViewview的子视图
    [_mScrollPageView setContentOfTables:buttonItemArray];
    
    //默认选中第一个button
    [_mMenuHriZontal clickButtonAtIndex:0];
    [self addSubview:_mScrollPageView];
    [self addSubview:_mMenuHriZontal];
}

- (void)transFormModel:(SPDetailModel *)spDtailModel
{
    _model = spDtailModel;
    _isCompre = NO;

}

- (void)transFormCompreModel:(ComprehensiveModel *)compreModel
{
    _compreModel = compreModel;
    _isCompre = YES;

}

//重新布局
-(void)layoutSubviews{
    [super layoutSubviews];
    
    _mScrollPageView.frame = CGRectMake(0, MENUHEIHT, self.frame.size.width, self.frame.size.height - MENUHEIHT);
    _mMenuHriZontal.frame =CGRectMake(0, 0, SCREEN_WIDTH, MENUHEIHT);
}



#pragma mark - 其他辅助功能
#pragma mark MenuHrizontalDelegate
-(void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)aIndex{
    NSLog(@"审批第%d个Button点击了",aIndex);
    [_mScrollPageView moveScrollowViewAthIndex:aIndex];
}

#pragma mark ScrollPageViewDelegate
-(void)didScrollPageViewChangedPage:(NSInteger)aPage{
    NSLog(@"审批CurrentPage:%d",aPage);

    [_mMenuHriZontal changeButtonStateAtIndex:aPage];
        //刷新当页数据
        [_mScrollPageView freshContentTableAtIndex:aPage];
}







@end
