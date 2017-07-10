//
//  SHMeetingDetailVC.m
//  XAYD
//
//  Created by songdan Ye on 16/5/12.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "SHMeetingDetailVC.h"
#import "SHMeetingDV.h"
@interface SHMeetingDetailVC ()
@property (nonatomic,strong)SHMeetingDV *meetingDV;
@end

@implementation SHMeetingDetailVC
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle =UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.tintColor =[UIColor whiteColor];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    UIImage *img =[self imageWithColor:RGB(34, 152, 239)];
    
        [self.navigationController.navigationBar setBackgroundImage:img
                           forBarPosition:UIBarPositionAny
                               barMetrics:UIBarMetricsDefault];


}

- (void)viewWillDisappear:(BOOL)animated
{

    [super viewWillDisappear: animated];
    [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleDefault;

    self.navigationController.navigationBar.tintColor =[UIColor blackColor];

    UIImage *img =[self imageWithColor:RGB(238, 238, 238)];
    UIImage *whiteImage =[self imageWithColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setShadowImage:img];
    [self.navigationController.navigationBar setBackgroundImage:whiteImage
                                                 forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];
}


- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self initView];
    
    
    
}

// 初始View
- (void) initView {
    
    UIView *vContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MainR.size.height-49-20)];

    if (_meetingDV == nil) {
        _meetingDV = [[SHMeetingDV alloc] initWithFrame:vContentView.frame];
         }
    //传递模型数据
    [_meetingDV getMDatas:self.mDatas];
    [_meetingDV transTab:self.tabBarController];
    [_meetingDV transNav:self.navigationController];
        [vContentView addSubview:_meetingDV];
    [self.view addSubview:vContentView];
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
