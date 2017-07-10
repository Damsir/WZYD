//
//  PDetailViewController.m
//  XAYD
//
//  Created by songdan Ye on 15/12/28.
//  Copyright © 2015年 dist. All rights reserved.
//
#import "NSString+StringSize.h"
#import "PDetailViewController.h"

//#import "HomeView.h"
#import "SHCover.h"
#import "PLogViewController.h"
#import "PTreeViewController.h"
#import "PrintFromViewController.h"



@interface PDetailViewController () <SHCoverDelegate>
{
    UIButton *_selectedBtn;//保存选中的按钮
    /**
     *  保存分类的ID号
     */
    NSArray *_arrayIds;
}
@property (nonatomic,strong)UINavigationController *nav;
@property (nonatomic,strong)UITabBarController *tab;
@property (nonatomic,strong)UIView *popView;
//蒙板
@property (nonatomic,strong) UIView *cover;


@property (nonatomic,strong)UIView *bgView;


@property (nonatomic,strong) UIScrollView *sv;
@end

@implementation PDetailViewController

- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    self = [super initWithNibName:aNibName bundle:aBuddle];
    if (self != nil) {
        [self initTopNavBar];
    }
    return self;
}
//重载导航条
-(void)initTopNavBar{

//    self.navigationItem.title = @"移动办公";
    self.navigationItem.leftBarButtonItem = Nil;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden =YES;
    self.nav.navigationBar.hidden =NO;
    
   }

- (void) viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    UIView *bgView=[[UIView alloc] initWithFrame:CGRectMake(0, -64, MainR.size.width, 64)];
    bgView.backgroundColor =[UIColor whiteColor];
    _bgView = bgView;
    [self.view addSubview:_bgView];

    self.tabBarController.tabBar.hidden =YES;
    
    if ([_spOrgw isEqualToString:@"sp"])
    {
        [self initNavigationBarTitle:@"项目详情"];
        
    }else if ([_spOrgw isEqualToString:@"gw"])
    {
        [self initNavigationBarTitle:@"公文详情"];
    }
    
    //保存导航控制器
    self.nav = self.navigationController;
    
    self.tab =self.tabBarController;
    //初始化视图
    [self initView];
    self.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
    
    
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom ];
    btn.frame = CGRectMake(0, 0, 20, 20) ;
    [btn setImage:[UIImage imageNamed:@"iconfont-gengduom"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(popSelection) forControlEvents:UIControlEventTouchUpInside];
    
    //UIBarButtonItem *b =[[UIBarButtonItem alloc] initWithCustomView:btn];
    
    
   
//    if ([_spOrgw isEqualToString:@"sp"])
//    {
        //self.navigationItem.rightBarButtonItem = b;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-gengduom"] style:UIBarButtonItemStylePlain target:self action:@selector(popSelection)];
//    }else if ([_spOrgw isEqualToString:@"gw"])
//    {
//    }
    
    //监听屏幕旋转结束
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changesepDetial) name:UIDeviceOrientationDidChangeNotification object:nil];
    
   
    
}
//屏幕旋转结束执行的方法
- (void)changesepDetial
{
    self.spBaseView.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height-64);
    _cover.frame = [UIScreen mainScreen].bounds;

    if ([_spOrgw isEqualToString:@"sp"]){
        _popView.frame = CGRectMake(MainR.size.width-155, 64, 140, 132);
    }else if ([_spOrgw isEqualToString:@"gw"]){
        _popView.frame = CGRectMake(MainR.size.width-155, 64, 140, 44);
    }
}


//弹出选择框
- (void)popSelection
{
    SHCover *cover =[SHCover show];
    _cover = cover;
    cover.userInteractionEnabled =YES;
    cover.delegate =self;
    UIView *popView =[[UIView alloc] initWithFrame:CGRectMake(MainR.size.width-155, 64, 140, 132)];
    if ([_spOrgw isEqualToString:@"sp"]){
        popView.frame = CGRectMake(MainR.size.width-155, 64, 140, 132);
    }else if ([_spOrgw isEqualToString:@"gw"]){
        popView.frame = CGRectMake(MainR.size.width-155, 64, 140, 44);
    }
    popView.backgroundColor =[UIColor whiteColor];
//    popView.layer.cornerRadius = 6;
//    popView.layer.masksToBounds = YES;
    _popView = popView;
    [SHKeyWindow addSubview:popView];

    UIButton *xmrz = [self createBtnWithImageName:@"项目日志" sysTemFont:[UIFont systemFontOfSize:17 ] titleColor:[UIColor blackColor] ];
    [xmrz addTarget:self action:@selector(openPLogView) forControlEvents:UIControlEventTouchUpInside];
    xmrz.frame =CGRectMake(0, 0, popView.frame.size.width,popView.frame.size.height/3.0);
    
    UIButton *xmTree = [self createBtnWithImageName:@"项目树" sysTemFont:[UIFont systemFontOfSize:17 ] titleColor:[UIColor blackColor]];
    xmTree.frame =CGRectMake(0, popView.frame.size.height/3.0, popView.frame.size.width, popView.frame.size.height/3.0);
    [xmTree addTarget:self action:@selector(openPTreeView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *xmForms = [self createBtnWithImageName:@"项目表单" sysTemFont:[UIFont systemFontOfSize:17 ] titleColor:[UIColor blackColor]];
    xmForms.frame =CGRectMake(0, popView.frame.size.height*2/3.0, popView.frame.size.width, popView.frame.size.height/3.0);
    [xmForms addTarget:self action:@selector(openFormsView) forControlEvents:UIControlEventTouchUpInside];
    
    if ([_spOrgw isEqualToString:@"sp"]){
        [_popView addSubview:xmrz];
        [_popView addSubview:xmTree];
        [_popView addSubview:xmForms];
    }else if ([_spOrgw isEqualToString:@"gw"]){
        UIButton *gwrz = [self createBtnWithImageName:@"公文日志" sysTemFont:[UIFont systemFontOfSize:17 ] titleColor:[UIColor blackColor] ];
        [gwrz addTarget:self action:@selector(openPLogView) forControlEvents:UIControlEventTouchUpInside];
        gwrz.frame =CGRectMake(0, 0, popView.frame.size.width,popView.frame.size.height);
        [_popView addSubview:gwrz];
    }

}

- (UIButton *)createBtnWithImageName:(NSString *)ImageName sysTemFont:(UIFont * )font titleColor:(UIColor *)col
{

    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:ImageName forState:UIControlStateNormal];
    [btn setFont:font];
    
    [btn setTitleColor:col forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"iconfont-yd"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 13, 0, 0);

    
    return btn;

}



// 点击蒙板的时候调用
- (void)coverDidClickCover:(SHCover *)cover
{
    // 隐藏pop菜单
    [_popView removeFromSuperview];
    
}


- (void)openPLogView
{
    [_popView removeFromSuperview];
    [_cover removeFromSuperview];
    PLogViewController *pLog =[[PLogViewController alloc]  init];
    if ([_spOrgw isEqualToString:@"sp"]){
        pLog.spOrgw = @"sp";
    }else if ([_spOrgw isEqualToString:@"gw"]){
        pLog.spOrgw = @"gw";
    }
    if (_isComp) {
        [pLog setCompreModel:self.compreModel];
    }
    else{
        [pLog setModel:self.model];
    }
    [pLog setIsCompre:self.isComp];
    [self.navigationController pushViewController:pLog animated:YES];


}
- (void)openPTreeView
{
    [_popView removeFromSuperview];
    [_cover removeFromSuperview];
    PTreeViewController *pTree =[[PTreeViewController alloc]init];
    
    if (_isComp) {
            [pTree setCompreModel:self.compreModel];
    }
    else{
            [pTree setModel:self.model];
    }
    pTree.isCompre =self.isComp;
    [self.navigationController pushViewController:pTree animated:YES];
    
    
}
- (void)openFormsView
{
    [_popView removeFromSuperview];
    [_cover removeFromSuperview];
    PrintFromViewController *pFrom =[[PrintFromViewController alloc]init];
    pFrom.nav =self.nav;
    
    if (_isComp) {
        [pFrom setCompreModel:self.compreModel];

    }
    else{
            [pFrom setModel:self.model];
    }
    pFrom.isCompre =self.isComp;

    [self.navigationController pushViewController:pFrom animated:YES];
    
}

// 初始View
- (void) initView {
    
    _spBaseView = [[spBaseView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, MainR.size.height-64)];

    //根据是否是综合查询 传递不同的参数模型
    if (self.isComp) {
        
        [_spBaseView.homeView transFormCompreModel:self.compreModel];

        _mHomeView.isCompre = YES;
        _spBaseView.homeView.isCompre = YES;
        
    }
    else
    {
        [_spBaseView.homeView transFormModel:self.model];
        _spBaseView.homeView.isCompre=NO;
        
//        [_mHomeView transFormModel:self.model];
//        _mHomeView.isCompre = NO;
        
    }
    //把初始化的baseMessage传给HomeView
    _spBaseView.homeView.baseMessage =self.baseMessage;
    [_spBaseView.homeView  transNav:self.nav];
    [_spBaseView.homeView transTab:self.tab];
    //注释了
    [_spBaseView.homeView commInit];

    [self.view addSubview:_spBaseView];
    
    }

- (void)setModel:(SPDetailModel *)model
{
    _model =model;
    _isComp = NO;

}

- (void)setCompreModel:(searchResultModel *)compreModel
{

    _compreModel = compreModel;
    _isComp = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
