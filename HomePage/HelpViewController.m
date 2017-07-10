//
//  HelpViewController.m
//  WZYD
//
//  Created by 吴定如 on 16/11/9.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@property(nonatomic,strong) UIWebView *web;

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    //self.navigationItem.title = @"帮助";
    [self initNavigationBarTitle:@"帮助"];
    
    [self createHelpUI];
    //监听屏幕旋转的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}

// 屏幕旋转改变视图通知
-(void)screenRotation:(NSNotification *)noti
{
    _web.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
}

-(void)createHelpUI
{
    UIWebView *web = [[UIWebView alloc] init];
    web.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    web.backgroundColor = [UIColor whiteColor];
//    [web.scrollView setZoomScale:1.5 animated:YES];
    // 缩放设置
    [web setScalesPageToFit:YES];
    _web = web;
    //http://61.153.29.234:8888/mobileService/help.html

    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@help.html",[Global Url]]]]];
    [self.view addSubview:web];
}

//导航栏标题
-(void)initNavigationBarTitle:(NSString *)title
{
    UILabel *lab      = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    lab.textColor     = [UIColor whiteColor];
    lab.font          = [UIFont boldSystemFontOfSize:17.0];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text          = title;
    
    self.navigationItem.titleView = lab;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
