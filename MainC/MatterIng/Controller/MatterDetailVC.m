//
//  MatterDetailVC.m
//  XAYD
//
//  Created by songdan Ye on 16/3/1.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "MatterDetailVC.h"
#import "matterModel.h"

@interface MatterDetailVC ()

@end

@implementation MatterDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=_matModel.maintitle;
    NSString *path=[[NSBundle mainBundle] pathForResource:@"dailyJobForm" ofType:@"htm"];
    NSURL *url=[NSURL fileURLWithPath:path];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    _webView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-44);
    _webView.opaque=NO;
    _webView.backgroundColor=[UIColor clearColor];
    [_webView loadRequest:request];
    _webView.delegate=self;
    _webView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-44);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.tabBarController.tabBar setFrame:CGRectMake(-SCREEN_WIDTH, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
    _webView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-44);
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _webView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-44);
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [_webView stringByEvaluatingJavaScriptFromString:
     [NSString stringWithFormat:@"window.setBody('%@')",_matModel.content]];
    
}


@end
