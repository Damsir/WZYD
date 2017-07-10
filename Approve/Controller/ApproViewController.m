//
//  ApproViewController.m
//  XAYD
//
//  Created by songdan Ye on 16/4/8.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "ApproViewController.h"
#import "ApproHomeView.h"

//#define MENUHEIHT 37
@interface ApproViewController ()<UISearchBarDelegate>
{
    UISearchBar *gwSearchBar;

}
@property (nonatomic,strong)ApproHomeView *approhomeView;
@property (nonatomic,strong)UIButton *selectedBtn;//保存选中的按钮
@property (nonatomic,strong)NSArray *createBtns;

@property (nonatomic,strong)UINavigationController *nav;

//用来标记搜索按钮收回和弹出搜索框
@property (nonatomic,assign,getter=isOpenSB) BOOL openSB;

//保存在办箱\已办箱\督办箱的搜索关键字
@property (nonatomic,strong)NSString *searZBString;
@property (nonatomic,strong)NSString *searYBString;
@property (nonatomic,strong)NSString *searDBString;


@property (nonatomic,strong)ApproveBaseView *vContentView;

@end

@implementation ApproViewController
//重载导航条
-(void)initTopNavBar{
    //self.navigationItem.title = @"审批";
    //self.navigationItem.leftBarButtonItem = Nil;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
   // self.navigationController.navigationBar.hidden = YES;

    [UIApplication sharedApplication].statusBarStyle =UIStatusBarStyleDefault;

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    self.navigationController.navigationBar.hidden =NO;
    [UIApplication sharedApplication].statusBarStyle =UIStatusBarStyleLightContent;

}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 35);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationBarTitle:@"项目审批"];
    
    //默认点击搜索按钮时状态为打开
    self.openSB = YES;
    //初始化搜索关键字
    self.searDBString =[NSString string];
    self.searYBString =[NSString string];
    self.searZBString =[NSString string];
    
    //保存导航控制器
    self.nav = self.navigationController;
    _selectedBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    //默认选中第一个按钮
    _selectedBtn.tag = 0;
    [self initView];
    //创建搜索按钮
    [self setNavigationbar];
    //创建搜索栏
    [self createSearchBar];
    self.view.backgroundColor =[UIColor whiteColor];
    //监听滚动选中按钮
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSButton:) name:@"selectedButtonIndex"  object:nil];
    //监听屏幕旋转
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(approchange) name:UIDeviceOrientationDidChangeNotification object:nil];
}


- (void)approchange
{
    self.vContentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.searchBtn.frame =CGRectMake(MainR.size.width-50, 30, 30, 30);
    gwSearchBar.frame= CGRectMake(0,MENUHEIHT+20,SCREEN_WIDTH,44);
    

}

//选中按钮变化执行的方法
- (void)changeSButton:(NSNotification *)text
{
    NSInteger index= [text.userInfo[@"tag"] intValue];
    _selectedBtn.tag = index;
    
    if (index == 0 ) {
        gwSearchBar.text = _searZBString;
    }
    else if (index == 1)
    {
        gwSearchBar.text = _searYBString;

    }
    else
    {
        gwSearchBar.text = _searDBString;

    }
    
    NSLog(@"sBar:%d",_selectedBtn.tag);
    
}



// 初始View
- (void) initView {
    
    
    _vContentView = [[ApproveBaseView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];

    [_vContentView.approHomeView transNav:self.nav];

    [_vContentView addSubview:_approhomeView];
    self.view = _vContentView;
}


- (void)createSearchBar
{
    gwSearchBar =[[UISearchBar alloc]initWithFrame:CGRectMake(0,MENUHEIHT+20,SCREEN_WIDTH,44)];

    gwSearchBar.hidden = YES;
    //设置输入颜色
    gwSearchBar.tintColor = [UIColor blackColor];
    UIImage *image =[self imageWithColor:[UIColor whiteColor]];
    //设置搜索框的背景图片
    [gwSearchBar setSearchFieldBackgroundImage:image forState:UIControlStateNormal];
    //设置背景颜色
    [gwSearchBar setBarTintColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1]];
    gwSearchBar.delegate =  self;

}

- (void)setNavigationbar
{
    UIButton *searchBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(MainR.size.width-50, 30, 30, 30) ;
    [searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(15, 20, 15, 0)];
    [searchBtn setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
    
    //搜索按钮点击方法
    [searchBtn addTarget:self action:@selector(searchActions) forControlEvents:UIControlEventTouchUpInside];
    
//    UIBarButtonItem *b =[[UIBarButtonItem alloc] initWithCustomView:searchBtn];
//    
//    self.navigationItem.rightBarButtonItem = b;
    _searchBtn =searchBtn;
   // [self.view addSubview:_searchBtn];
}
//点击搜索
- (void)searchActions
{
    
    if (self.isOpenSB){//显示搜索按钮
        self.openSB=NO;//设置搜索按钮状态为no
        self.vContentView.approHomeView.approScrollPageView.openSB = YES;
        self.vContentView.approHomeView.approScrollPageView.frame=CGRectMake(0, MENUHEIHT+44, MainR.size.width, MainR.size.height-MENUHEIHT-64-44);

    [gwSearchBar becomeFirstResponder];
    
    gwSearchBar.hidden =NO;
    [self.view addSubview:gwSearchBar];

        
    }else
    {
        self.openSB = YES;
        [self  cancekClicked];
        //回收键盘
        [gwSearchBar resignFirstResponder];
        //设置searchBar隐藏
        gwSearchBar.hidden = YES;
    
    }
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
// UISearchBar得到焦点并开始编辑时，执行该方法
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [gwSearchBar setShowsCancelButton:YES animated:YES];
    if (_selectedBtn.tag==0) {
        _searZBString = nil;
    }
    else if (_selectedBtn.tag ==1)
    {
        _searYBString = nil;
    
    }
    else{
    
        _searDBString = nil;
    }
    return YES;
}
// 取消按钮被按下时，执行的方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [gwSearchBar resignFirstResponder];
    [gwSearchBar setShowsCancelButton:NO animated:YES];
    gwSearchBar.hidden = YES;

    
}
// 键盘中，搜索按钮被按下，执行的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"---%@",searchBar.text);
    
    [gwSearchBar resignFirstResponder];// 放弃第一响应者
    NSDictionary *dict =[NSDictionary dictionary];
    dict= @{@"open0":gwSearchBar.text};
    NSInteger i = _selectedBtn.tag;

    if (i==0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"seacrchAction0" object:nil userInfo:dict];
        self.searZBString = searchBar.text;
    }
    else if (i ==1)
    {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"seacrchAction1" object:nil userInfo:dict];
        self.searYBString = searchBar.text;
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"seacrchAction2" object:nil userInfo:dict];
        self.searDBString = searchBar.text;

    
    }
    
    
    
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self changeCancel];//改cancel为取消
    
}
-(void) changeCancel{
    for(id subView in [gwSearchBar.subviews[0] subviews]){
        if([subView isKindOfClass:[UIButton class]]){
            UIButton *btn = (UIButton *)subView;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(cancekClicked) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)cancekClicked
{

    self.vContentView.approHomeView.approScrollPageView.openSB = NO;
    self.vContentView.approHomeView.approScrollPageView.frame=CGRectMake(0, MENUHEIHT, MainR.size.width, MainR.size.height-MENUHEIHT-64);
    self.vContentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49);


    [[NSNotificationCenter defaultCenter]postNotificationName:@"searchCancelClicked" object:nil];
    
    self.openSB = YES;
    self.searZBString = nil;
    self.searYBString =nil;
    self.searDBString =nil;
}





@end
