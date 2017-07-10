//
//  NoticeViewController.m
//  WZYD
//
//  Created by 吴定如 on 16/11/10.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "NoticeViewController.h"
#import "MyRequestManager.h"

@interface NoticeViewController ()

@property(nonatomic,strong) UIWebView *web;
@property(nonatomic,strong) UILabel *tip;

@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    //self.navigationItem.title = @"公告";
    
    [self initNavigationBarTitle:@"公告"];
    
    [self createHelpUI];
    //监听屏幕旋转的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}

// 屏幕旋转改变视图通知
-(void)screenRotation:(NSNotification *)noti
{
    _web.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    _tip.center = CGPointMake(SCREEN_WIDTH/2.0, (SCREEN_HEIGHT-64)/2.0);

}

-(void)createHelpUI
{
    UIWebView *web = [[UIWebView alloc] init];
    web.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    web.backgroundColor = [UIColor whiteColor];
    // 缩放设置
    [web setScalesPageToFit:YES];
    _web = web;
    //http://61.153.29.234:8888/mobileService/service/Notice.ashx
    //NSString *htmlStr = [NSString stringWithFormat:@"<html>%@</html>",content];
    //[web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@service/Notice.ashx",[Global Url]]]]];
    //[web loadHTMLString:@"" baseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@service/Notice.ashx",[Global Url]]]];
    [self.view addSubview:web];
    
    //NSString *url = [NSString stringWithFormat:@"http://61.153.29.234:8888/mobileService/service/Notice.ashx"];
    NSString *url = [NSString stringWithFormat:@"%@service/Notice.ashx",[Global Url]];
    
    [MyRequestManager requestWithUrl:url andSuccess:^(NSData *data) {
        
        NSString *htmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString *string = [HtmlCode deleteFlagOfHTML:htmlString];
        if ([string isEqualToString:@""] || string == nil)
        {
            _web.hidden = YES;
            [self showNoneNotice];
        }else
        {
            NSString *baseStr = [NSString stringWithFormat:@"<html>%@</html>",htmlString];
            [_web loadHTMLString:baseStr baseURL:nil];
        }
        
    } andFailBlock:^(NSError *error) {
        
    }];
    
}

-(void)showNoneNotice
{
    if (!_tip) {
        
//        UIButton *tip = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        tip.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
//        tip.center = CGPointMake(SCREEN_WIDTH/2.0, (SCREEN_HEIGHT-64)/2.0);
//        [tip setTitle:@"暂无公告内容!" forState:UIControlStateNormal];
//        [tip.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
//        [tip setTitleColor:BLUECOLOR forState:UIControlStateNormal];
//        tip.enabled = NO;
//        //[tip addTarget:self action:@selector(loadData) forControlEvents:UIControlEventTouchUpInside];
//        _tip = tip;
//        [self.view addSubview:tip];
        
        UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        tip.center = CGPointMake(SCREEN_WIDTH/2.0, (SCREEN_HEIGHT-64)/2.0);
        tip.text = @"暂无公告内容!";
        tip.textAlignment = NSTextAlignmentCenter;
        tip.textColor = BLUECOLOR;
        _tip = tip;
        [self.view addSubview:tip];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
