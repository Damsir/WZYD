//
//  SHHomeViewController.m
//  XAYD
//
//  Created by songdan Ye on 16/1/6.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "SHHomeViewController.h"
#import "MainCViewController.h"
#import "MeetingViewController.h"
#import "SPViewController.h"
#import "MoreViewController.h"
#import "SHTabBar.h"
#import "OfficialDocumentVC.h"
//#import "ApproViewController.h"
#import "HomeViewController.h"
#import "QueryViewController.h"
#import "DocumentViewController.h"
#import "MailViewController.h"
#import "ApproveViewController.h"
#import "LoginViewController.h"


@interface SHHomeViewController ()<SHTabBarDelegate>

/**
 *  自定义的tabbar
 */
@property (nonatomic, weak) SHTabBar *customTabBar;

@property (nonatomic,strong)MainCViewController *mainCVC;
//@property (nonatomic,strong)SPViewController *spVC;
//@property (nonatomic,strong)ApproViewController *spVC;
@property (nonatomic,strong)ApproveViewController *spVC;
@property (nonatomic,strong)OfficialDocumentVC *OfficDVC;
@property (nonatomic,strong)HomeViewController *homeVC;
@property (nonatomic,strong)MoreViewController *moreVC;
@property (nonatomic,strong)DocumentViewController *documentVC;
@property (nonatomic,strong)MailViewController *mailVC;
@property (nonatomic,assign)BOOL open;

//
@property(nonatomic,assign) NSInteger indexFlag;


@end

@implementation SHHomeViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle =UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.hidden = YES;
    
    //    [self.tabBarController.tabBar setFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
    ////     删除系统自动生成的UITabBarButton
    //    for (UIView *child in self.tabBar.subviews) {
    //        if ([child isKindOfClass:[UIControl class]]) {
    //            [child removeFromSuperview];
    //        }
    //    }
    
    //设置tabbar在正常状态和选中状态的字体颜色
    //[[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    //UIColor *titleHighlightedColor = RGB(34, 152, 230);
    //[[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:titleHighlightedColor, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
-(void)changeRootView:(NSNotification *)noty
{
    BOOL autoBtn = [[defaults objectForKey:@"auto"] boolValue];
    if (autoBtn)
    {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [tempArray insertObject:loginVC atIndex:0];
        //[tempArray removeObject:self]; //此时 的self 就是指 当前控制器 ,因为在 自己 里面操作
        [self.navigationController setViewControllers:tempArray animated:YES];
    }
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.70;
    transition.type = @"rippleEffect";
    transition.type = @"cube";
    transition.subtype = kCATransitionFromLeft;
    transition.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:YES];
    //LoginViewController *loginVC = [[LoginViewController alloc] init];
    //[self.navigationController pushViewController:loginVC animated:YES];
    //[UIApplication sharedApplication].keyWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRootView:) name:@"changeRootView" object:nil];
    
    self.delegate = self;
    self.tabBar.tintColor = [UIColor colorWithRed:37/255.0 green:145/255.0 blue:136/255.0 alpha:1.000];
    
    //首页
    HomeViewController *homeVC=[[HomeViewController alloc] init];
    [self setChildViewControllerWithVC:homeVC tabBarTitle:@"主页" tabBarItemImage:@"home_n" tabSlectedImageName:@"home_s"];
    _homeVC = homeVC;
    // 审批
    //    SPViewController *spVC=[[SPViewController alloc] init];
    //ApproViewController *spVC =[[ApproViewController alloc] init];
    ApproveViewController *spVC = [[ApproveViewController alloc] init];
    [self setChildViewControllerWithVC:spVC tabBarTitle:@"审批" tabBarItemImage:@"approve_n" tabSlectedImageName:@"approve_s"];
    _spVC = spVC;
    
    // 公文
//    OfficialDocumentVC *officDVC=[[OfficialDocumentVC alloc] init];
//    _OfficDVC = officDVC;
    DocumentViewController *documentVC=[[DocumentViewController alloc] init];
    [self setChildViewControllerWithVC:documentVC tabBarTitle:@"公文" tabBarItemImage:@"document_n" tabSlectedImageName:@"document_s"];
    _documentVC = documentVC;
    
    // 电子邮件
    MailViewController *mailVC = [[MailViewController alloc] init];
    [self setChildViewControllerWithVC:mailVC tabBarTitle:@"电子邮件" tabBarItemImage:@"mail_n" tabSlectedImageName:@"mail_s"];
    _mailVC = mailVC;
    
    // 更多
    MoreViewController *moreVC = [[MoreViewController alloc] init];
    [self setChildViewControllerWithVC:moreVC tabBarTitle:@"更多" tabBarItemImage:@"more_n" tabSlectedImageName:@"more_s"];
    _moreVC = moreVC;
    
    // 每隔一段时间请求
    [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(requestUnread) userInfo:nil repeats:YES];
    
    
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [self selectedIndexw];
    
}



- (void)requestUnread
{
    long rod =random()%5;
    NSString *r =[NSString stringWithFormat:@"%ld",rod];
//    _mainCVC.tabBarItem.badgeValue =[NSString stringWithFormat:@"%ld",rod+1];
    //    _spVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",rod+12];
    //    _meetVC.tabBarItem.badgeValue=[NSString stringWithFormat:@"%ld",rod+7];
    //    _email.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",rod+1];
    
    //    _moreVC.tabBarItem.badgeValue = r;
    
}

- (void)selectedIndexw
{
    NSInteger index =self.selectedIndex;
    if (index==0) {
        
        
        if(_homeVC.tabBarItem.badgeValue !=nil)
        {
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateMattering" object:nil];
            
        }
        _homeVC.tabBarItem.badgeValue =nil;
        
    }
    else if (index == 1)
    {
        
        _spVC.tabBarItem.badgeValue =nil;
        
        
    }
    else if (index==2)
    {
        
        //            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateMeeting" object:nil];
    }
    else if(index == 3)
    {
        //打开跳转
//        NSString *url = @"ydbg://";
//        if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:url]])
//        {
//            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"是否打开公文跳转" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//            alertView.tag = 100;
//            [alertView show];
//        }
//        else
//            
//        {
//            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"未安装公文是否下载" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//            alertView.tag =101;
//            [alertView show];
//            
//            
//        }
    }
    else
    {
        _moreVC.tabBarItem.badgeValue = nil;
        
    }
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==100){
        if (buttonIndex==1) {
            NSLog(@"打开跳转应用");
            
            NSString *name = @"abc";
            NSString *pwd = @"123";
            
            NSString *url=[NSString stringWithFormat:@"ydbg://%@&%@",name,pwd];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    }
    else
    {
        
        if (buttonIndex==1) {
            NSLog(@"下载应用");
            //下载应用
            NSString *url = @"https://www.dist.com.cn/app/product/ha/";
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            }
            
        }
    }
}

- (void)setChildViewControllerWithVC:(UIViewController *)vc tabBarTitle:(NSString *)title tabBarItemImage:(NSString *)imageName tabSlectedImageName:(NSString *)selectedImage
{
    [vc.tabBarItem setSelectedImage:[[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    vc.title = title;
    
    vc.tabBarItem.image =[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *nav =[[UINavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];

    //    // 3.添加tabbar内部的按钮
    //    [self.customTabBar addTabBarButtonWithItem:vc.tabBarItem];
    
    
    //    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"child_head_bg"] forBarMetrics:UIBarMetricsDefault];
    //nav.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, [UIFont systemFontOfSize:18.0f], NSFontAttributeName, nil];
    
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSInteger index = [self.tabBar.items indexOfObject:item];
    
    if (self.indexFlag != index) {
        [self animationWithIndex:index];
    }
    
}
// 动画
- (void)animationWithIndex:(NSInteger)index
{
    NSMutableArray *tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scale.duration = 0.3;
    scale.repeatCount = 1;
    scale.autoreverses = YES;
    scale.fromValue = [NSNumber numberWithFloat:1.0];
    //scale.byValue = [NSNumber numberWithFloat:1.2];
    scale.toValue = [NSNumber numberWithFloat:1.3];
    
//    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
//    animation.values = @[@(1.0), @(1.2), @(1.3), @(1.2), @(1.0)];
//    animation.duration = 0.5;
//    animation.calculationMode = kCAAnimationCubic;
    
    [[tabbarbuttonArray[index] layer] addAnimation:scale forKey:nil];
    
    self.indexFlag = index;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
