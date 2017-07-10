//
//  MailViewController.m
//  WZYD
//
//  Created by 吴定如 on 16/11/1.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "MailViewController.h"
#import "MailInboxViewController.h"
#import "MailDraftViewController.h"
#import "MailOutBoxViewController.h"
#import "SendMailViewController.h"

#define Titles @[@"收件箱",@"草稿箱",@"已发邮件"]
#define itemNum Titles.count

@interface MailViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong) MailInboxViewController *inBoxVC;
@property(nonatomic,strong) MailDraftViewController *draftVC;
@property(nonatomic,strong) MailOutBoxViewController *outBoxVC;

@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,assign) NSInteger selectedIndex;//记录当前选择的按钮
@property(nonatomic,strong) UIView *headerView;//头部
@property(nonatomic,strong) NSMutableArray *selectBtnArray;
@property(nonatomic,strong) UIView *underLineView;//底部滑动颜色条
@property(nonatomic,strong) UIView *underLine;//底部分割线

@end

@implementation MailViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[UIApplication sharedApplication].statusBarStyle =UIStatusBarStyleLightContent;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    //self.navigationItem.title = @"邮件";
    [self initNavigationBarTitle:@"邮件"];
    
    _selectedIndex = 0;//默认当前点击为第一个按钮
    [self createScrollViewAndHeaderSlide];
    
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
    
    _inBoxVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _draftVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _outBoxVC.view.frame = CGRectMake(2*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

    [_inBoxVC screenRotation];
    [_draftVC screenRotation];
    [_outBoxVC screenRotation];
}

// 初始化sliderBar
-(void)createScrollViewAndHeaderSlide
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
    
//    UIButton *sendMailBtn = [self createButtonWithImage:@"sendMail" andTitle:@"发邮件" andFrame:CGRectMake(0, 0, 80, 30) andTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendMailBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发邮件" style:UIBarButtonItemStylePlain target:self action:@selector(sendMail)];
}

#pragma mark -- 更改按钮状态
-(void)selectedIndexBtn:(UIButton *)btn
{
    //上一次点击的还原状态
    UIButton *oldButton = (UIButton *)[self.view viewWithTag:_selectedIndex+100];
    
    //记住上一次点击的按钮的tag值
    _selectedIndex = btn.tag-100;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        // 上一个
        [oldButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        // 当前点击的按钮的颜色变化
        [btn setTitleColor:BLUECOLOR forState:UIControlStateNormal];
        
        CGRect frame = _underLineView.frame;
        frame.origin.x = _selectedIndex *  SCREEN_WIDTH/itemNum;
        _underLineView.frame = frame;
        
        // scrollView 偏移
        //_scrollView.contentOffset = CGPointMake(MainR.size.width * _selectedIndex, 0);
        [_scrollView setContentOffset:CGPointMake(MainR.size.width * _selectedIndex, 0) animated:NO];
        
    }];
    
    // scrollView 偏移
    //_scrollView.contentOffset = CGPointMake(MainR.size.width * _selectedIndex, 0);
    //[_scrollView setContentOffset:CGPointMake(MainR.size.width * _selectedIndex, 0) animated:YES];
}

#pragma mark -- scrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x/SCREEN_WIDTH;
    UIButton *oldButton = (UIButton *)[self.view viewWithTag:_selectedIndex+100];
    [oldButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIButton *newButton = (UIButton *)[self.view viewWithTag:index+100];
    [newButton setTitleColor:BLUECOLOR forState:UIControlStateNormal];
    [UIView animateWithDuration:0.5 animations:^{
        
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
    MailInboxViewController *inBoxVC = [[MailInboxViewController alloc] init];
    inBoxVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    inBoxVC.nav = self.navigationController;
    _inBoxVC = inBoxVC;
    [_scrollView addSubview:inBoxVC.view];
    
    MailDraftViewController *draftVC = [[MailDraftViewController alloc] init];
    draftVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    draftVC.nav = self.navigationController;
    _draftVC = draftVC;
    [_scrollView addSubview:draftVC.view];
    
    MailOutBoxViewController *outBoxVC = [[MailOutBoxViewController alloc] init];
    outBoxVC.view.frame = CGRectMake(2*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    outBoxVC.nav = self.navigationController;
    _outBoxVC = outBoxVC;
    [_scrollView addSubview:outBoxVC.view];
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
    [button setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 55)];
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
    [button addTarget:self action:@selector(sendMail) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

-(void)sendMail
{
    SendMailViewController *sendMailVC = [[SendMailViewController alloc] init];
    sendMailVC.hidesBottomBarWhenPushed = YES;
    sendMailVC.fsOrhf = @"fs";
    
    [self.navigationController pushViewController:sendMailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
