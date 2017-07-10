//
//  ApproveViewController.m
//  WZYD
//
//  Created by 吴定如 on 16/12/4.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "ApproveViewController.h"
#import "ApproZBViewController.h"
#import "ApproYBViewController.h"

#define Titles @[@"在办箱",@"已办箱"]
#define itemNum Titles.count

@interface ApproveViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong) ApproZBViewController *zbVC;
@property(nonatomic,strong) ApproYBViewController *ybVC;
@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,assign) NSInteger selectedIndex;//记录当前选择的按钮
@property(nonatomic,strong) UIView *headerView;//头部
@property(nonatomic,strong) NSMutableArray *selectBtnArray;
@property(nonatomic,strong) UIView *underLineView;//底部滑动颜色条
@property(nonatomic,strong) UIView *underLine;//底部分割线

@end

@implementation ApproveViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    //self.navigationItem.title = @"项目审批";
    [self initNavigationBarTitle:@"项目审批"];
    
    _selectedIndex = 0;//默认当前点击为第一个按钮
    
    [self initSliderSegment];
    [self createNaviSearchBar];
    
    //监听屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}

- (void)screenRotation:(NSNotification *)noti
{
    _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, HeaderHeight);
    for (int i=0; i<_selectBtnArray.count; i++)
    {
        UIButton *selectBtn = _selectBtnArray[i];
        selectBtn.frame = CGRectMake(i * SCREEN_WIDTH/itemNum, 0, SCREEN_WIDTH/itemNum, HeaderHeight);
    }
    _underLine.frame = CGRectMake(0, HeaderHeight-0.5, SCREEN_WIDTH, 0.5);
    _underLineView.frame = CGRectMake(_selectedIndex * SCREEN_WIDTH/itemNum, HeaderHeight-2, SCREEN_WIDTH/itemNum, 2);
    
    _scrollView.frame = CGRectMake(0, HeaderHeight, SCREEN_WIDTH, SCREEN_HEIGHT-HeaderHeight-64-49);
    //横竖屏后contentSize变化了
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * itemNum, SCREEN_HEIGHT-HeaderHeight-64-49);
    _scrollView.contentOffset = CGPointMake(_selectedIndex * SCREEN_WIDTH, 0);
    
    _zbVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _ybVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [_zbVC screenRotation];
    [_ybVC screenRotation];
}

#pragma mark -- SearchBar
-(void)createNaviSearchBar
{
    //    UIButton *searchBtn = [self createButtonWithImage:@"searchIcon" andTitle:@"搜索" andFrame:CGRectMake(0, 0, 80, 30) andTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(searchOnClick)];
}

-(void)initSliderSegment
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HeaderHeight)];
    _headerView = headerView;
    [self.view addSubview:headerView];
    
    UIView *underLine = [[UIView alloc] init];
    underLine.frame = CGRectMake(0, HeaderHeight-0.5, SCREEN_WIDTH, 0.5);
    underLine.backgroundColor = GRAYCOLOR_MIDDLE;
    _underLine = underLine;
    [headerView addSubview:underLine];
    
    _selectBtnArray = [NSMutableArray array];
    for (int i=0; i<itemNum; i++)
    {
        //按钮
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.frame = CGRectMake(i * SCREEN_WIDTH/itemNum, 0, MainR.size.width/itemNum, HeaderHeight);
        
        [selectBtn setTitle:Titles[i] forState:UIControlStateNormal];
        [selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [selectBtn addTarget:self action:@selector(selectedIndexBtn:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0)
        {
            [selectBtn setTitleColor:BLUECOLOR forState:UIControlStateNormal];
        }
        selectBtn.tag = i+100;
        [headerView addSubview:selectBtn];
        [_selectBtnArray addObject:selectBtn];
    }
    //底部条
    UIView *underLineView = [[UIView alloc] initWithFrame:CGRectMake(0, HeaderHeight-2, SCREEN_WIDTH/itemNum, 2)];
    underLineView.backgroundColor = BLUECOLOR;
    _underLineView = underLineView;
    [headerView addSubview:underLineView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, HeaderHeight, SCREEN_WIDTH, MainR.size.height-HeaderHeight-64-49)];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*itemNum, SCREEN_HEIGHT-HeaderHeight-64-49);
    scrollView.contentOffset = CGPointMake(0, 0);
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    _scrollView = scrollView;
    [self.view addSubview:scrollView];
    //加载各个控制器
    [self initDifferentControllers];
    
    
}

#pragma mark -- 更改按钮状态
-(void)selectedIndexBtn:(UIButton *)btn
{
    //上一次点击的还原状态
    UIButton *oldButton = (UIButton *)[self.view viewWithTag:_selectedIndex+100];
    
    //记住上一次点击的按钮的tag值
    _selectedIndex = btn.tag-100;
    
    [UIView animateWithDuration:0.4 animations:^{
        
        // 上一个
        [oldButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        // 当前点击的按钮的颜色变化
        [btn setTitleColor:BLUECOLOR forState:UIControlStateNormal];
        
        CGRect frame = _underLineView.frame;
        frame.origin.x = _selectedIndex *  SCREEN_WIDTH/itemNum;
        _underLineView.frame = frame;
        
        // scrollView 偏移
        _scrollView.contentOffset = CGPointMake(MainR.size.width * _selectedIndex, 0);
        
    }];
    
}

#pragma mark -- scrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x/SCREEN_WIDTH;
    UIButton *oldButton = (UIButton *)[self.view viewWithTag:_selectedIndex+100];
    [oldButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIButton *newButton = (UIButton *)[self.view viewWithTag:index+100];
    [newButton setTitleColor:BLUECOLOR forState:UIControlStateNormal];
    [UIView animateWithDuration:0.4 animations:^{
        
        // 上一个
        [oldButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        // 当前点击的按钮的颜色变化
        [newButton setTitleColor:BLUECOLOR forState:UIControlStateNormal];
        
        CGRect frame = _underLineView.frame;
        frame.origin.x = index * SCREEN_WIDTH/itemNum;
        _underLineView.frame = frame;
        
    }];
    
    _selectedIndex = index;
    
}

// 加载各个控制器
-(void)initDifferentControllers
{
    ApproZBViewController *zbVC = [[ApproZBViewController alloc] init];
    zbVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    zbVC.nav = self.navigationController;
    _zbVC = zbVC;
    [_scrollView addSubview:zbVC.view];
    
    ApproYBViewController *ybVC = [[ApproYBViewController alloc] init];
    ybVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    ybVC.nav = self.navigationController;
    _ybVC = ybVC;
    [_scrollView addSubview:ybVC.view];
}

// customButton
-(UIButton *)createButtonWithImage:(NSString *)imageName andTitle:(NSString *)title andFrame:(CGRect)frame andTitleEdgeInsets:(UIEdgeInsets)titleEdgeInsets
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = BLUECOLOR;
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setTitleEdgeInsets:titleEdgeInsets];
    [button setImageEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 50)];
    button.layer.cornerRadius = 2;
    button.clipsToBounds = YES;
    // 按钮对齐方式设置
    button.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    button.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.highlighted = NO;
    button.adjustsImageWhenHighlighted = NO;
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [button addTarget:self action:@selector(searchOnClick) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

// 查询
-(void)searchOnClick
{
//    SearchDocViewController *searchVC = [[SearchDocViewController alloc] init];
//    
//    searchVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:searchVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
