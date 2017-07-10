//
//  MapViewController.m
//  WZYD
//
//  Created by 吴定如 on 16/11/14.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "MapViewController.h"
#import <WebKit/WKWebView.h>
#import <WebKit/WebKit.h>
#import "MBProgressHUD.h"

static void *XFWkwebBrowserContext = &XFWkwebBrowserContext;

@interface MapViewController () <WKNavigationDelegate,WKUIDelegate,UINavigationControllerDelegate,UINavigationBarDelegate>

@property (nonatomic,strong) WKWebView *web;
//设置加载进度条
@property (nonatomic,strong) UIProgressView *progressView;

@end

@implementation MapViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
   // self.navigationItem.title = @"地图";
    [self initNavigationBarTitle:@"地图"];
    
    [self createWebView];
    [self createProgressView];
    //监听屏幕旋转的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}

// 屏幕旋转改变视图通知
-(void)screenRotation:(NSNotification *)noti
{
    _web.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
}

-(void)createWebView
{
    if (!_web)
    {
        WKWebView *web = [[WKWebView alloc] init];
        web.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        web.backgroundColor = [UIColor whiteColor];
        // 设置代理
        web.navigationDelegate = self;
        web.UIDelegate = self;
        //kvo 添加进度监控
        [web addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:XFWkwebBrowserContext];
        _web = web;
        
        //    http://61.153.29.236:8891/mobileService/gis/default.htm
        // 读取本地文件 (html)
        // NSString *path = [[NSBundle mainBundle] pathForResource:@"default" ofType:@"htm"];
        
        //[web loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
        //[web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[Global Url],@"gis/default.htm"]]]];
        [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://61.153.29.236:8891/mobileService/gis/default.htm"]]];
        
        //[web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@gis/default.html",Url]]]];
        [self.view addSubview:web];
        [MBProgressHUD showMessage:@"" toView:self.view];
    }
    
    //添加右边刷新按钮
    UIBarButtonItem *roadLoad = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(roadLoadClicked)];
    self.navigationItem.rightBarButtonItem = roadLoad;
}

- (void)roadLoadClicked{
    
    [self.web reload];
}

// KVO监听进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.web) {
        [self.progressView setAlpha:1.0f];
        BOOL animated = self.web.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.web.estimatedProgress animated:animated];
        
        // Once complete, fade out UIProgressView
        if(self.web.estimatedProgress >= 1.0f) {
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


-(void)createProgressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.frame = CGRectMake(0, 42, self.view.bounds.size.width, 2);
        // 设置进度条的色彩
        //[_progressView setTrackTintColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0]];
        [_progressView setTrackTintColor:[UIColor colorWithRed:37/255.0 green:145/255.0 blue:136/255.0 alpha:1.000]];
        //_progressView.progressTintColor = BLUECOLOR;
        //_progressView.progressTintColor = [UIColor colorWithRed:37/255.0 green:145/255.0 blue:136/255.0 alpha:1.000];
        _progressView.progressTintColor = [UIColor whiteColor];
        
        [self.navigationController.navigationBar addSubview:_progressView];
    }
}

//注意，观察的移除
- (void)dealloc{
    [self.web removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
