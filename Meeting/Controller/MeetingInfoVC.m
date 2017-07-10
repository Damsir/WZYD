//
//  MeetingInfoVC.m
//  HAYD
//
//  Created by 吴定如 on 16/8/31.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "MeetingInfoVC.h"
#import "MeetingBaseVC.h"
#import "MeetingMaterialVC.h"

#define HeaderHeight 50.0

@interface MeetingInfoVC ()<UIScrollViewDelegate>

@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,assign) NSInteger selectedIndex;//记录当前选择的按钮
@property(nonatomic,strong) MeetingBaseVC *baseVC;
@property(nonatomic,strong) MeetingMaterialVC *materialVC;
@property(nonatomic,strong) UIView *headerView;//头部
@property(nonatomic,strong)  NSMutableArray *selectBtnArray;
@property(nonatomic,strong) UIView *leftLineView;
@property(nonatomic,strong) UIView *rightLineView;

@end

@implementation MeetingInfoVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];


//    _baseVC.view.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height-64-HeaderHeight);
//    _materialVC.view.frame = CGRectMake(MainR.size.width, 0, MainR.size.width, MainR.size.height-64-HeaderHeight);
//    _scrollView.frame = CGRectMake(0, HeaderHeight, MainR.size.width, MainR.size.height-HeaderHeight-64);
//    //横竖屏后contentSize变化了
//    _scrollView.contentSize = CGSizeMake(MainR.size.width * 2, MainR.size.height-HeaderHeight-64);
//    _scrollView.contentOffset = CGPointMake(_selectedIndex * MainR.size.width, 0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    _selectedIndex = 0;//默认当前点击为第一个按钮
    [self createScrollViewAndHeaderSlide];
    
    //屏幕旋转通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIDeviceOrientationDidChangeNotification object:nil];
}
//屏幕旋转改变视图的Frame
-(void)screenRotation:(NSNotification *)noti
{
    _headerView.frame = CGRectMake(0, 0, MainR.size.width, HeaderHeight);
    for (int i=0; i<_selectBtnArray.count; i++)
    {
        UIButton *selectBtn = _selectBtnArray[i];
        selectBtn.frame = selectBtn.frame = CGRectMake(i * MainR.size.width/2.0, 0, MainR.size.width/2.0, 48);
    }
    _leftLineView.frame = CGRectMake(0, 48, MainR.size.width/2.0, 2);
    _rightLineView.frame = CGRectMake(MainR.size.width/2.0, 48, MainR.size.width/2.0, 2);
    
    _scrollView.frame = CGRectMake(0, HeaderHeight, MainR.size.width, MainR.size.height-HeaderHeight-64);
    //横竖屏后contentSize变化了
    _scrollView.contentSize = CGSizeMake(MainR.size.width * 2, MainR.size.height-HeaderHeight-64);
    _scrollView.contentOffset = CGPointMake(_selectedIndex * MainR.size.width, 0);
    
    _baseVC.view.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height-64-HeaderHeight);
    _materialVC.view.frame = CGRectMake(MainR.size.width, 0, MainR.size.width, MainR.size.height-64-HeaderHeight);
    [_baseVC screenRotation];
    [_materialVC screenRotation];
}

-(void)createScrollViewAndHeaderSlide
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, HeaderHeight)];
    _headerView = headerView;
    [self.view addSubview:headerView];
    
    _selectBtnArray = [NSMutableArray array];
    for (int i=0; i<2; i++)
    {
        //按钮
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.frame = CGRectMake(i * MainR.size.width/2.0, 0, MainR.size.width/2.0, 48);
        if (i==0) {
            [selectBtn setTitle:@"基本信息" forState:UIControlStateNormal];
        }else
        {
            [selectBtn setTitle:@"会议资料" forState:UIControlStateNormal];
        }
        
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
    UIView *leftLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 48, MainR.size.width/2.0, 2)];
    leftLineView.backgroundColor = BLUECOLOR;
    _leftLineView = leftLineView;
    [headerView addSubview:leftLineView];
    
    UIView *rightLineView = [[UIView alloc] initWithFrame:CGRectMake(MainR.size.width/2.0, 48, MainR.size.width/2.0, 2)];
    rightLineView.backgroundColor = [UIColor whiteColor];
    _rightLineView = rightLineView;
    [headerView addSubview:rightLineView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, HeaderHeight, MainR.size.width, MainR.size.height-HeaderHeight-64)];
    scrollView.contentSize = CGSizeMake(MainR.size.width*2, MainR.size.height-HeaderHeight-64);
    scrollView.contentOffset = CGPointMake(0, 0);
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    _scrollView = scrollView;
    [self.view addSubview:scrollView];
    //加载基本信息和会议材料
    [self initMeetingBaseControllerAndMeetingMaterialController];
}

#pragma mark -- 更改按钮状态
-(void)selectedIndexBtn:(UIButton *)btn
{
    //上一次点击的还原状态
    UIButton *oldButton = (UIButton *)[self.view viewWithTag:_selectedIndex+100];
    [oldButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //当前点击的按钮的颜色变化
    [btn setTitleColor:BLUECOLOR forState:UIControlStateNormal];

    //记住上一次点击的按钮的tag值
    _selectedIndex = btn.tag-100;
    
    if (_selectedIndex == 0)
    {
        _leftLineView.backgroundColor = BLUECOLOR;
        _rightLineView.backgroundColor = [UIColor whiteColor];
    }else
    {
        _leftLineView.backgroundColor = [UIColor whiteColor];
        _rightLineView.backgroundColor = BLUECOLOR;
    }
    
    //scrollView
    _scrollView.contentOffset = CGPointMake(MainR.size.width * _selectedIndex, 0);
}

#pragma mark -- scrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //
    NSInteger index = scrollView.contentOffset.x/MainR.size.width;
    UIButton *oldButton = (UIButton *)[self.view viewWithTag:_selectedIndex+100];
    [oldButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIButton *newButton = (UIButton *)[self.view viewWithTag:index+100];
    [newButton setTitleColor:BLUECOLOR forState:UIControlStateNormal];
    
    _selectedIndex = index;
    
    if (_selectedIndex == 0)
    {
        _leftLineView.backgroundColor = BLUECOLOR;
        _rightLineView.backgroundColor = [UIColor whiteColor];
    }else
    {
        _leftLineView.backgroundColor = [UIColor whiteColor];
        _rightLineView.backgroundColor = BLUECOLOR;
    }
    
    //防止加在scrollView上的视图偏移,作此处理
    CGPoint offset = _scrollView.contentOffset;
    if (offset.x == _scrollView.frame.size.width) { //防止滑动一点点并不切换scrollview的视图
        return;
    }
    else
    {
        _scrollView.contentOffset = CGPointMake(offset.x/MainR.size.width,0);
    }
    
}

//加载基本信息和会议材料
-(void)initMeetingBaseControllerAndMeetingMaterialController
{
    _baseVC = [[MeetingBaseVC alloc] init];
    [_baseVC transFromMeetingId:_meetingId];
    _baseVC.view.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height);
//    _baseVC.meetingId = _meetingId;
    _baseVC.nav = self.navigationController;
    [_scrollView addSubview:_baseVC.view];
    
    _materialVC = [[MeetingMaterialVC alloc] init];
    [_materialVC transFromMeetingId:_meetingId];
    _materialVC.view.frame = CGRectMake(MainR.size.width, 0, MainR.size.width, MainR.size.height);
//    _materialVC.meetingId = _meetingId;
    _materialVC.nav = self.navigationController;
    [_scrollView addSubview:_materialVC.view];
    
}

-(void)layoutSubViews
{
//    _baseVC.view.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height-64-HeaderHeight);
//    _materialVC.view.frame = CGRectMake(MainR.size.width, 0, MainR.size.width, MainR.size.height-64-HeaderHeight);
//    _scrollView.frame = CGRectMake(0, HeaderHeight, MainR.size.width, MainR.size.height-HeaderHeight-64);
//    //横竖屏后contentSize变化了
//    _scrollView.contentSize = CGSizeMake(MainR.size.width * 2, MainR.size.height-HeaderHeight-64);
//    _scrollView.contentOffset = CGPointMake(_selectedIndex * MainR.size.width, 0);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
