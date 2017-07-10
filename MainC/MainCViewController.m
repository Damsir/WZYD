//
//  MainCViewController.m
//  XAYD
//
//  Created by songdan Ye on 16/1/4.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "MainCViewController.h"
#import "PopSelectView.h"
#import "MatterIngVC.h"
#import "announcementVC.h"
#import "StatisticsVController.h"

#import "SHHomeVV.h"

#import "ContentView.h"
#define cellH 40

@interface MainCViewController ()<UISearchBarDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate>
{
    int mode; // 0:普通 1:搜索
    BOOL _isDropRefersh;
    BOOL _isTodo;
    
}
@property (nonatomic,strong)SHHomeVV *homeView;
@property (nonatomic,strong)UIButton *selectedBtn;//保存选中的按钮
@property (nonatomic,strong)PopSelectView *popBox;
@property (nonatomic,copy) NSString *selectedS;
@property (nonatomic,strong) NSArray *StateArray;
@property (nonatomic,strong) UILabel *titleLabel;

@property(nonatomic,assign)BOOL isOpen;
@property(nonatomic,strong)UITableView *listTable;
@property(nonatomic,strong)NSArray *titlesList;
@property(nonatomic,assign)int defaultIndex;
@property(nonatomic,assign)float tableHeight;
@property(nonatomic,strong)UIImageView *arrow;


@property (nonatomic,strong) MatterIngVC *matterVC;
@property (nonatomic,strong)announcementVC *annoVC;
@property (nonatomic,strong)StatisticsVController *staticVC;




@property (nonatomic,strong) UIScrollView *sv;
@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)UIView *backV;

@property (strong, nonatomic)UIButton *searchBtn;
@property (nonatomic,strong)NSArray *createBtns;
@property (nonatomic,strong)UINavigationController *nav;
@property (nonatomic,strong)UITabBarController *tab;


@property (nonatomic,strong) UIView *statusView;



@property (nonatomic,strong)ContentView *vContentView;


@end
@implementation MainCViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.tabBarController.tabBar setFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];

    self.navigationController.navigationBar.hidden=YES;
    [UIApplication sharedApplication].statusBarStyle =UIStatusBarStyleLightContent;
    self.tabBarController.tabBar.hidden= NO;


}




- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    self.navigationController.navigationBar.hidden = NO;

//    self.tabBarController.tabBar.hidden= YES;
}

- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    self = [super initWithNibName:aNibName bundle:aBuddle];
    if (self != nil) {
        [self initTopNavBar];
    }
    return self;
}

//重载导航条
-(void)initTopNavBar{
    self.navigationItem.title = @"首页";
    self.navigationItem.leftBarButtonItem = Nil;
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = NO;
}

-(void)viewDidLoad{
    [super viewDidLoad];
   
    //设置状态栏
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];

    //保存导航控制器
    self.nav = self.navigationController;
    self.tab = self.tabBarController;
    _selectedBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    _selectedBtn.tag = 0;
    [self initView];
    UIView *statusView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, 20)];
    _statusView =statusView;
    statusView.backgroundColor =RGB(34, 152, 239);
    [self.view addSubview:_statusView];
    self.view.backgroundColor =[UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSelectedButton:) name:@"selectedButtonIndex"  object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)change
{

    self.vContentView.frame = CGRectMake(0, 10, MainR.size.width, MainR.size.height -49-20);
    _statusView.frame =CGRectMake(0, 0, MainR.size.width, 20);
    

}




- (void)changeSelectedButton:(NSNotification *)text
{
    _selectedBtn.tag =[text.userInfo[@"tag"] intValue];
    NSLog(@"sBar:%d",_selectedBtn.tag);
    
}

// 初始View
- (void)initView{
    

    _vContentView = [[ContentView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, MainR.size.height-49-20)];
    [_vContentView.homeView transTab:self.tab];

    [_vContentView.homeView  transNav:self.nav];
//    [vContentView addSubview:_homeView];
    [self.view addSubview:_vContentView];
}

@end
