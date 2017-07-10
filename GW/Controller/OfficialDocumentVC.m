//
//  OfficialDocumentVC.m
//  XAYD
//
//  Created by songdan Ye on 16/4/1.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "OfficialDocumentVC.h"
//#import "OfficialDocVV.h"

#define MENUHEIHT1 37
@interface OfficialDocumentVC ()<UISearchBarDelegate>
    {
        UISearchBar *gwSearchBar;
        
    }
@property (nonatomic,strong)OfficialDocVV *officialDocVV;
@property (nonatomic,strong)UINavigationController *nav;
@property (nonatomic,strong)UITabBarController  *tab;


@property (nonatomic,strong)UIButton *selectedBtn;//保存选中的按钮

@property (nonatomic,strong) UISegmentedControl *segment;

//用来标记搜索按钮收回和弹出搜索框
@property (nonatomic,assign,getter=isOpenSB) BOOL openSB;

//保存在办箱\已办箱\督办箱的搜索关键字
@property (nonatomic,strong)NSString *searSWString;
@property (nonatomic,strong)NSString *searFWString;

@end

@implementation OfficialDocumentVC

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



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
    self.tabBarController.tabBar.hidden = NO;
    //去掉导航栏底下的黑色横线
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setShadowImage:[UIImage new]];

}

//在页面消失的时候就让navigationbar还原样式
-(void)viewWillDisappear:(BOOL)animated{
    
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //默认点击搜索按钮时状态为打开
    self.openSB = YES;
    //初始化搜索关键字
    self.searSWString =[NSString string];
    self.searFWString =[NSString string];

    
    self.view.backgroundColor =[UIColor whiteColor];

    self.nav =self.navigationController;
//    self.tab = self.tabBarController;
    CGFloat width =( MainR.size.width -30-45)/4.0;
    if (MainR.size.width>414) {
       width =( MainR.size.width -30-45-35)/4.0;

    }
    UISegmentedControl *segement = [[UISegmentedControl alloc]initWithItems:@[@"在办",@"已办"]];
    //[segement initWithItems:@[@"在办",@"已办",@"传阅",@"签阅"]];
    segement.frame = CGRectMake(0, 0, width *4, 35);
    [segement setWidth:width forSegmentAtIndex:0];
    [segement setWidth:width forSegmentAtIndex:1];
    [segement setWidth:width forSegmentAtIndex:2];
    [segement setWidth:width forSegmentAtIndex:3];

    segement.tintColor =RGB(34, 152, 239);
        [segement addTarget:self action:@selector(seggementValueChanged:) forControlEvents:UIControlEventValueChanged];
    segement.selectedSegmentIndex = 0;
    self.segment =segement;
    self.navigationItem.titleView = _segment;

    //创建导航栏的搜索按钮搜索
    [self setNavigationbar];
    [self createSearchBar];
    
    
    
    _selectedBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    _selectedBtn.tag = 0;
    
    [self initView];
    
    //监听到按钮变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSelectedBtn:) name:@"seleBtnIndex"  object:nil];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(officialDomChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}
//屏幕旋转结束执行的方法
- (void)officialDomChange
{
    self.officialBaseView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-44);

    gwSearchBar.frame= CGRectMake(0,MENUHEIHT1,SCREEN_WIDTH,44);
    CGFloat width =( MainR.size.width -30-45)/4.0;
    if (MainR.size.width>414) {
        width =( MainR.size.width -30-45-35)/4.0;
        
    }
    self.segment.frame =CGRectMake(0, 0, width *4, 30);
    [_segment setWidth:width forSegmentAtIndex:0];
    [_segment setWidth:width forSegmentAtIndex:1];
    [_segment setWidth:width forSegmentAtIndex:2];
    [_segment setWidth:width forSegmentAtIndex:3];

}
//监听到通知后执行的方法
- (void)changeSelectedBtn:(NSNotification *)text
{
    NSInteger index= [text.userInfo[@"tag"] intValue];
    _selectedBtn.tag = index;
    
    if (index == 0 ) {
        gwSearchBar.text = _searSWString;
    }
    else
    {
        gwSearchBar.text = _searFWString;
        
    }
    NSLog(@"sBar:%d",_selectedBtn.tag);
    
}

- (void)createSearchBar
{
    gwSearchBar =[[UISearchBar alloc]initWithFrame:CGRectMake(0,MENUHEIHT1,SCREEN_WIDTH,44)];
    
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



// 初始View
- (void) initView {
    
    _officialBaseView = [[OfficialBaseView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-44)];
    [_officialBaseView.officialDocVV transNav:self.nav];
    [_officialBaseView.cqBaseView transNav:self.nav];
    [self.view addSubview:_officialBaseView];
    _officialBaseView.officialDocVV.hidden=NO;
    _officialBaseView.cqBaseView.hidden=YES;
}


/**
 *  @brief Segement 变化
 */
-(void)seggementValueChanged:(UISegmentedControl *)segment
{
    
    gwSearchBar.text =nil;
    self.searSWString = nil;
    self.searFWString = nil;

    NSDictionary *dict =[NSDictionary dictionary];
    NSInteger index = segment.selectedSegmentIndex;
    dict= @{@"selectedIndex":[NSString stringWithFormat:@"%ld",(long)index]};
    if (index>=2) {
        _officialBaseView.officialDocVV.hidden=YES;
        _officialBaseView.cqBaseView.hidden=NO;
    }
    else
    {
        _officialBaseView.officialDocVV.hidden=NO;
        _officialBaseView.cqBaseView.hidden=YES;
    
    }
    //通知加载传阅箱或者是签约箱内容
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadCYXdataOrQYXdata" object:nil userInfo:dict];
    
}

- (void)setNavigationbar
{
        UIButton *searchBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        searchBtn.frame = CGRectMake(0, 0, 40, 30) ;
    //    [searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(15, 20, 15, 0)];
        [searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
        [searchBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [searchBtn addTarget:self action:@selector(searchActionss) forControlEvents:UIControlEventTouchUpInside];
    
        UIBarButtonItem *b =[[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    
        self.navigationItem.rightBarButtonItem = b;
    
}
- (void)searchActionss
{
    if (self.isOpenSB){//显示搜索按钮
        self.openSB=NO;//设置搜索按钮状态为no
        
        
        self.officialBaseView.officialDocVV.mScrollPageView.openSB = YES;
        self.officialBaseView.officialDocVV.mScrollPageView.frame=CGRectMake(0, MENUHEIHT1+44, MainR.size.width, MainR.size.height-MENUHEIHT1-64-44);
        self.officialBaseView.cqBaseView.mScrollPageView.openSB = YES;
        self.officialBaseView.cqBaseView.mScrollPageView.frame =CGRectMake(0, MENUHEIHT1+44, MainR.size.width, MainR.size.height-MENUHEIHT1-64-44);
//        self.officialDocVV.mScrollPageView.frame =CGRectMake(0, MENUHEIHT1+44, MainR.size.width, MainR.size.height-MENUHEIHT1-64-44);
        [gwSearchBar becomeFirstResponder];
        
        gwSearchBar.hidden =NO;
        [self.view addSubview:gwSearchBar];
        
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"sBtnClick" object:nil];
        
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
        _searSWString = nil;
    }
    else
    {
        _searFWString = nil;
        
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
    dict= @{@"open1":gwSearchBar.text};
    NSInteger i = _selectedBtn.tag;
    
    if (i==0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"gwSeacrchAction0" object:nil userInfo:dict];
        self.searSWString = searchBar.text;
    }
    else
    {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"gwSeacrchAction1" object:nil userInfo:dict];
        self.searFWString = searchBar.text;
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
    
    self.officialBaseView.officialDocVV.mScrollPageView.openSB= NO;
    self.officialBaseView.officialDocVV.mScrollPageView.frame=CGRectMake(0, MENUHEIHT1, MainR.size.width, MainR.size.height-MENUHEIHT1-64);
    self.officialBaseView.cqBaseView.mScrollPageView.openSB= NO;
    self.officialBaseView.cqBaseView.mScrollPageView.frame=CGRectMake(0, MENUHEIHT1, MainR.size.width, MainR.size.height-MENUHEIHT1-64);
    
//    self.officialDocVV.mScrollPageView.frame =CGRectMake(0, MENUHEIHT1, MainR.size.width, MainR.size.height-MENUHEIHT1-64);
    //    mode =0;
    //    _spDetailTableView.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height);
    //    gwSearchBar.text =nil;
    //    [self.spDetailTableView reloadData];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"gwSearchCancelClicked" object:nil];
    
    self.openSB = YES;
    self.searSWString = nil;
    self.searFWString =nil;
}



@end
