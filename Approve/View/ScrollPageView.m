//
//  ScrollPageView.m
//  ShowProduct
//
//Created by songdan Ye on 15/12/28.
//  Copyright © 2015年 dist. All rights reserved.
//

#import "ScrollPageView.h"

#import "MJRefresh.h"
@interface ScrollPageView ()
//保存界面
@property (nonatomic,strong)NSArray *tables;

@property (nonatomic,strong)UIView *backV;
@property (nonatomic,assign)CGRect vMoveRect;

@end
@implementation ScrollPageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        mNeedUseDelegate = YES;
        [self commInit];
    }
    return self;
}

-(void)initData{
    [self freshContentTableAtIndex:0];
}


-(void)commInit{
    
//    _mCurrentPage = 0;
    
    self.openSB = NO;
    //保存界面
    if(_tables ==nil)
    {
        _tables = [NSArray array];
    }
    if (_contentItems == nil) {
        _contentItems = [[NSMutableArray alloc] init];
    }
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height+50)];
        NSLog(@"ScrollViewFrame:(wwww%f,gggg%f)",self.frame.size.width,self.frame.size.height);
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor=[UIColor whiteColor];
        _scrollView.delegate = self;
    }
    [self addSubview:_scrollView];
}

#pragma mark - 其他辅助功能
#pragma mark 添加ScrollowViewd的ContentView
//-(void)setContentOfTables:(NSInteger)aNumerOfTables {

-(void)setContentOfTables:(NSArray *)tables {
    /**
     *  首页
     */
    
    _tables  = tables;
    
    if([[[tables objectAtIndex:0] objectForKey:TITLEKEY] isEqualToString:@"待办"])//
    {
        UIView *backV = [[UIView alloc] init];
        
        for (int i = 0; i < tables.count; i++) {
            if(i==0)
            {
                
                if (_approZB==nil) {
                    _approZB = [[ApproZBViewController alloc] init];
                    
                }
                _approZB.nav = self.nav;
                
                _approZB.view.frame =CGRectMake(0, 0, MainR.size.width, self.frame.size.height);
                backV.tag = 100+i;
                
                
                backV = _approZB.view;
                
            }
            if (i==1) {
                
                if (!_press ) {
                    _press =[[NewsVC alloc] init];
                }
                _press.view.frame =CGRectMake(0, 0, MainR.size.width, self.frame.size.height);
                
                
                _press.nav = self.nav;
                _press.tab=self.tab;
                
                backV.tag =  100+i;
                backV = _press.view;
                
                
                
                
                //                if (!_matterVC) {
                //                    _matterVC = [[MatterIngVC alloc] init];
                //
                //                }
                //                _matterVC.nav = self.nav;
                //
                //                backV.tag = 100+i;
                //
                //                backV = _matterVC.view;
                //
                
                //                if (!_systemMessage) {
                //                                        _systemMessage =[[SystemMessage alloc] init];
                //                                    }
                //                                    _systemMessage.nav=self.nav;
                //
                //                                    backV.tag = 100+i;
                //                                    backV = _systemMessage.view;
            }
            
            if (i==2) {
                if (!_staticVC) {
                    _staticVC =[[StatisticsVController alloc]init];
                }
                _staticVC.nav = self.nav;
                _staticVC.view.frame =CGRectMake(0, 0, MainR.size.width, self.frame.size.height);
//                _staticVC.tableView.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height-74-49);
                backV.tag = 100+i;
                
                backV= _staticVC.view;
                
                
            }
            if (i==3) {
                if (!_annVC)
                {
                    _annVC = [[announcementVC alloc] init];
                    
                }
                _annVC.nav = self.nav;
                _annVC.tab =self.tab;
                _annVC.view.frame =CGRectMake(0, 0, MainR.size.width, self.frame.size.height);
                
                backV.tag = 100+i;
                
                backV=_annVC.view;
                
            }
            
            backV.frame =CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, self.frame.size.height+50);
            
            
            [_contentItems addObject:backV];
            [_scrollView addSubview:backV];
            
        }
        
        [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * tables.count, self.frame.size.height)];
        
    }
    /**
     *  公文
     *
     */
    else if ([[[tables objectAtIndex:0] objectForKey:TITLEKEY] isEqualToString:@"收文"])
    {
        for (int i = 0; i < tables.count; i++) {
            UIView *backV=[[UIView alloc] init];
            if (i==0) {
                if (_officialDetailVC==nil) {
                    _officialDetailVC = [[OffiDocDetaiVController alloc] init];
                    
                }
                _officialDetailVC.nav = self.nav;
                _officialDetailVC.view.frame =CGRectMake(0, 0, MainR.size.width, self.frame.size.height);
                backV.tag = 100+i;
                
                
                backV = _officialDetailVC.view;
                
                
            }
            if (i==1) {
                if (_sengOffDocVC==nil) {
                    _sengOffDocVC = [[SendOffDocDetailVC alloc] init];
                    
                }
                _sengOffDocVC.nav =self.nav;
                _sengOffDocVC.view.frame =CGRectMake(0, 0, MainR.size.width, self.frame.size.height);
                backV.tag = 100+i;
                
                backV = _sengOffDocVC.view;
                
            }
            backV.frame =CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, self.frame.size.height);
            [_contentItems addObject:backV];
            [_scrollView addSubview:backV];
            
            
        }
        [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * tables.count, self.frame.size.height)];
    }
    /**
     *  审批主页
     */
    else if ([[[tables objectAtIndex:0] objectForKey:TITLEKEY] isEqualToString:@"在办箱"])
    {
        
        for (int i = 0; i < tables.count; i++) {
            UIView *backV=[[UIView alloc] init];
            if (i==0) {

                if (_approZB==nil) {
                    _approZB = [[ApproZBViewController alloc] init];
                    
                }
                _approZB.nav = self.nav;
                _approZB.view.frame =CGRectMake(0, 0, MainR.size.width, self.frame.size.height);
                
                backV.tag = 100+i;
                
                
                backV = _approZB.view;
                
                
            }
            if (i==1) {
                if (_approYB==nil) {
                    _approYB = [[ApproYBViewController alloc] init];
                    
                }
                _approYB.nav = self.nav;
                _approYB.view.frame =CGRectMake(0, 0, MainR.size.width, self.frame.size.height);
                backV.tag = 100+i;
                backV = _approYB.view;
                
                
            }
            if (i==2) {
                if (_approDB==nil) {
                    _approDB = [[ApproDBViewController alloc] init];
                    
                }
                _approDB.nav = self.nav;
                _approDB.view.frame =CGRectMake(0, 0, MainR.size.width, self.frame.size.height);
                backV.tag = 100+i;
                backV = _approDB.view;
            }
            
            backV.frame =CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, self.frame.size.height+50);
            [_contentItems addObject:backV];
            [_scrollView addSubview:backV];
            
            
        }
        [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * tables.count, self.frame.size.height)];
        
    }
    
    /**
     *  审批详情
     */
    else if ([[[tables objectAtIndex:0] objectForKey:TITLEKEY] isEqualToString:@"项目信息"])
    {
        for (int i = 0; i < tables.count; i++) {
            UIView *backV=[[UIView alloc] init];
            if (i==0) {
                if (!_basemVC) {
                    _basemVC = [[BaseMessageVC alloc] init];
                    //                    [_messageVC setData:self.data];
                    
                }
                //                [_messageVC setData:self.data];
                if (self.isCompre) {
                    [_basemVC setCompModel:self.compreModel];
                    _basemVC.isComp = YES;
                    
                }else
                {
                    
                    [_basemVC setModel:self.model];
                    _basemVC.isComp = NO;
                }
                _basemVC.nav = self.nav;
                
                _basemVC.view.frame =CGRectMake(0, 0, MainR.size.width, self.frame.size.height);
                
                backV = _basemVC.view;
                
                
            }
            if (i==1) {
                if (!_materialVC) {
                    _materialVC=[[MaterialViewController alloc]init];
                }
                if (self.isCompre) {
                    [_materialVC setCompModel:self.compreModel];
                    _materialVC.isComp = YES;
                    
                }else
                {
                    
                    [_materialVC setModel:self.model];
                    _materialVC.isComp = NO;
                }
                               _materialVC.nav = self.nav;
                _materialVC.view.frame =CGRectMake(0, 0, MainR.size.width, self.frame.size.height);
                backV= _materialVC.view;
                
            }
           
            backV.frame =CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, self.frame.size.height);
            [_contentItems addObject:backV];
            [_scrollView addSubview:backV];
        }
        
        
        
        [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * tables.count, self.frame.size.height)];
        
    }
    else//会议详情
    {
        
        UIView *backV=[[UIView alloc] init];
        
        for (int i = 0; i < tables.count; i++) {
            if(i==0)
            {
                
                if (_meetingDetail==nil) {
                    _meetingDetail = [[MeetingDetailVC alloc] init];
                    
                }
                [_meetingDetail setMDatas:self.mDatas];
                
                _meetingDetail.view.frame =CGRectMake(0, 0, MainR.size.width, self.frame.size.height);
                backV.tag = 100+i;
                
                
                backV = _meetingDetail.view;
                
            }
            if (i==1) {
                
                if (!_minutesofM ) {
                    _minutesofM =[[MinutesofMeetingVC alloc] init];
                }
                _minutesofM.view.frame =CGRectMake(0, 0, MainR.size.width, self.frame.size.height);
                _minutesofM.mDatas =self.mDatas;
                //                 _minutesofM.nav = self.nav;
                //                 _minutesofM.tab=self.tab;
                
                backV.tag =  100+i;
                backV = _minutesofM.view;
                
                
                
                
            }
            if (i==2) {
                //                 if (!_materialVC) {
                //                     _materialVC =[[MaterialViewController alloc]init];
                //                 }
                //                 _materialVC.nav = self.nav;
                //                 _materialVC.view.frame =CGRectMake(0, 0, MainR.size.width, self.frame.size.height);
                //                 backV.tag = 100+i;
                //                 [_materialVC setModel:self.model];
                //
                //                 backV= _materialVC.view;
                if (!_meetMater) {
                    _meetMater =[[MeetingMaterialVC alloc]init];
                }
               // _meetMater.nav = self.nav;
                _meetMater.view.frame =CGRectMake(0, 0, MainR.size.width, self.frame.size.height);
                backV.tag = 100+i;
                //                 [_meetMater setModel:self.model];
                
                backV= _meetMater.view;
                
                
                
            }
            
            backV.frame =CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, self.frame.size.height+10);
            
            
            [_contentItems addObject:backV];
            [_scrollView addSubview:backV];
            
        }
        
        [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * tables.count, self.frame.size.height)];
        
        
        
    }
}



#pragma mark 移动ScrollView到某个页面
-(void)moveScrollowViewAthIndex:(NSInteger)aIndex{
    
    mNeedUseDelegate = NO;
    
    _vMoveRect = CGRectMake(MainR.size.width * aIndex, -46, MainR.size.width, self.frame.size.height);
    
    [_scrollView scrollRectToVisible:_vMoveRect animated:YES];
    _mCurrentPage= aIndex;
    
    
    //判断是否实现--按钮scrollview的代理方法
    if ([_delegate respondsToSelector:@selector(didScrollPageViewChangedPage:)]) {
        [_delegate didScrollPageViewChangedPage:_mCurrentPage];
    }
}

#pragma mark 刷新某个页面
-(void)freshContentTableAtIndex:(NSInteger)aIndex{
    if (_contentItems.count < aIndex) {
        return;
    }
    
    //    if (_contentItems.count==3) {
    //        if (aIndex==0) {
    //            [self.matterVC.matterTableView headerBeginRefreshing];
    //
    //        }
    //        if (aIndex==1) {
    //            [self.annVC.announceTableView headerBeginRefreshing];
    //        }
    //    }
    
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    mNeedUseDelegate = YES;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = (_scrollView.contentOffset.x+MainR.size.width/2.0) / MainR.size.width;
    
    
    if (_mCurrentPage == page) {
        return;
    }
    _mCurrentPage= page;
    
    if (page == 0) {
        //        _scrollView.f
    }
    if ([_delegate respondsToSelector:@selector(didScrollPageViewChangedPage:)] && mNeedUseDelegate)
    {
        [_delegate didScrollPageViewChangedPage:_mCurrentPage];
    }
    
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height+50);
    /**
     *  首页
     */
    
    if([[[_tables objectAtIndex:0] objectForKey:TITLEKEY] isEqualToString:@"待办"])//
    {
        
        for (int i = 0; i < _tables.count; i++) {
            UIView *backV=[[UIView alloc] init];

            if (i==0) {
                _approZB.view.frame =CGRectMake(0, 0, MainR.size.width, self.frame.size.height);
                _approZB.tableView.frame=CGRectMake(0, 0, MainR.size.width, MainR.size.height-64-MENUHEIHT);
                backV =_approZB.view;
            }else if (i==1)
            {
                
                
                _press.view.frame =CGRectMake(0, 0, MainR.size.width, self.frame.size.height);
                _press.tabView.frame =CGRectMake(0, 0, MainR.size.width, MainR.size.height-MENUHEIHT-49-20);
                backV = _press.view;
            }else if (i==2)
            {
                
                _staticVC.view.frame =CGRectMake(0, 0, MainR.size.width, self.frame.size.height);
                _staticVC.tableView.frame =CGRectMake(0, 0, MainR.size.width, MainR.size.height-74-49);
                backV = _staticVC.view;
            }
            else if (i== 3)
            {
                
                _annVC.view.frame =CGRectMake(0, 0, MainR.size.width, self.frame.size.height);
                
                _annVC.announceTableView.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height-49-20-MENUHEIHT);
                backV = _annVC.view;
            }
            
            backV.frame =CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, self.frame.size.height+50);
            [_contentItems addObject:backV];
            [_scrollView addSubview:backV];
            
        }
        
        [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * _tables.count, self.frame.size.height)];
        
    }
    /**
     *  公文
     *
     */
    else if ([[[_tables objectAtIndex:0] objectForKey:TITLEKEY] isEqualToString:@"收文"])
    {

        for (int i = 0; i < _tables.count; i++) {
            UIView *backV=[[UIView alloc] init];

            if (i==0) {
                
                _officialDetailVC.view.frame =CGRectMake(0, 0, MainR.size.width, self.frame.size.height);
                if(_officialDetailVC.mode == 0)
                {
                    _officialDetailVC.offDDetailtableView.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height);
                }
                else if (_officialDetailVC.mode == 1)
                {
                    _officialDetailVC.offDDetailtableView.frame =CGRectMake(0,40, MainR.size.width, MainR.size.height);
                    
                }
                backV = _officialDetailVC.view;
                
            }
            if (i==1) {
                _sengOffDocVC.view.frame =CGRectMake(0, 0, MainR.size.width, self.frame.size.height);
                if(_officialDetailVC.mode == 0)
                {
                    _sengOffDocVC.sendOffTableV.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height);
                }
                else if (_officialDetailVC.mode == 1)
                {
                    _sengOffDocVC.sendOffTableV.frame =CGRectMake(0, 0, MainR.size.width, MainR.size.height);
                    
                }
                backV= _sengOffDocVC.view;
                
            }
            backV.frame =CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, self.frame.size.height);
            [_contentItems addObject:backV];
            [_scrollView addSubview:backV];
            
        }
        [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * _tables.count, self.frame.size.height)];
        
    }
    /**
     *  审批主页
     */
    
    
    
    else if ([[[_tables objectAtIndex:0] objectForKey:TITLEKEY] isEqualToString:@"在办箱"])
    {

        for (int i = 0; i < _tables.count; i++) {
            UIView *backV=[[UIView alloc] init];

            
            
            
            if (i==0) {
                
                _approZB.view.frame =CGRectMake(0, 0, MainR.size.width, self.frame.size.height);
                _approZB.tableView.frame=CGRectMake(0, 0, MainR.size.width, MainR.size.height-64-MENUHEIHT);
                backV = _approZB.view;
            }
            if (i==1) {
                _approYB.view.frame =CGRectMake(0, 0, MainR.size.width, self.frame.size.height);
                _approYB.tableView.frame =CGRectMake(0, 0, MainR.size.width, MainR.size.height-64-MENUHEIHT);
                backV = _approYB.view;
            }
            if (i==2) {
                _approDB.view.frame =CGRectMake(0, 0, MainR.size.width, self.frame.size.height);
                _approDB.spDetailTableView.frame =CGRectMake(0, 0, MainR.size.width, MainR.size.height-64-MENUHEIHT);
                backV=_approDB.view;
            }
            
            backV.frame =CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, self.frame.size.height+50);
            [_contentItems addObject:backV];
            [_scrollView addSubview:backV];
            
        }
        [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * _tables.count, self.frame.size.height)];
        
    }
    
    /**
     *  审批详情
     */
    else if ([[[_tables objectAtIndex:0] objectForKey:TITLEKEY] isEqualToString:@"项目信息"])
    {
        UIView *backV=[[UIView alloc] init];
        for (int i = 0; i < _tables.count; i++) {
            if (i==0) {
                _basemVC.view.frame =CGRectMake(0, 0, MainR.size.width, self.frame.size.height);
                // _basemVC.btnWith.constant = (MainR.size.width-2*15-15)*0.5;
                // _basemVC.rollBackBtnWidth.constant =(MainR.size.width-2*15-15)*0.5;
                backV=_basemVC.view;
                
            }
            if (i==1) {
                
                _materialVC.view.frame =CGRectMake(0, 0, MainR.size.width, self.frame.size.height);
                _materialVC.tableView.frame=CGRectMake(0, 0, MainR.size.width, MainR.size.height-64-37);
                backV= _materialVC.view;
                
            }
            backV.frame =CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, self.frame.size.height);
            if (backV!=nil) {
                [_contentItems addObject:backV];
                [_scrollView addSubview:backV];
                
            }
        }
        
        
        
        [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * _tables.count, self.frame.size.height)];
        
    }
    
    else//会议详情
    {
       

        
        for (int i = 0; i < _tables.count; i++) {
            UIView *backV=[[UIView alloc] init];

            if(i==0)
            {
                
                _meetingDetail.view.frame =CGRectMake(0, 0, MainR.size.width, self.frame.size.height);
                backV = _meetingDetail.view;
            }
            if (i==1) {
                
                
                _minutesofM.view.frame =CGRectMake(0, 0, MainR.size.width, self.frame.size.height);
                _minutesofM.formTabelV.frame=CGRectMake(0, 40, MainR.size.width, self.frame.size.height-44);
                backV = _minutesofM.view;
                
            }
            if (i==2) {
                
                _meetMater.view.frame =CGRectMake(0, 0, MainR.size.width, self.frame.size.height);
               // _meetMater.tableView.frame =CGRectMake(0, 0, MainR.size.width, MainR.size.height-64-37);
                backV = _meetMater.view;
                
            }
            [_contentItems addObject:backV];
            [_scrollView addSubview:backV];
            backV.frame =CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, self.frame.size.height+10);
            
            
        }
        
        [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * _tables.count, self.frame.size.height)];
        
        
        
    }
    
    _vMoveRect = CGRectMake(MainR.size.width * _mCurrentPage, -46, MainR.size.width, self.frame.size.height);
    //移到指定位置
    [self moveScrollowViewAthIndex:_mCurrentPage];
    
    
}

#pragma mark - sendViewDelegate




@end
