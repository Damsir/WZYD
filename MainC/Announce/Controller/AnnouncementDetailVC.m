//
//  AnnouncementDetailVC.m
//  XAYD
//
//  Created by dist on 16/4/18.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "AnnouncementDetailVC.h"

@interface AnnouncementDetailVC ()

@end

@implementation AnnouncementDetailVC

 -(void)viewWillAppear:(BOOL)animated
{

   [ super viewWillAppear:animated];
    self.tab.tabBar.hidden = YES;
    self.nav.navigationBar.hidden =NO;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *topNavView =[[UIView alloc] initWithFrame:CGRectMake(0, -64, MainR.size.width, 64)];
    topNavView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:topNavView];
    
//    NSString *urlstr = self.anModel.showurl;
//    _webViewAnnou.scalesPageToFit = YES;
//    NSURL *url =[NSURL URLWithString:urlstr];
//    NSURLRequest *requst =[NSURLRequest requestWithURL:url];
//    [_webViewAnnou loadRequest:requst];
//
//    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"webA" ofType:@"htm"];
    NSURL *url = [NSURL fileURLWithPath:path];
        NSURLRequest *request =[NSURLRequest requestWithURL:url];
    
    
    
    _webViewAnnou.delegate = self;
    _webViewAnnou.scrollView.bounces = NO;
    _webViewAnnou.scalesPageToFit = YES;
        [_webViewAnnou loadRequest:request];
    
    NSString *content =_anModel.content;
    
    
    NSString *baseStr = [NSString stringWithFormat:@"<html>%@</html>",content];
    
    
    [_webViewAnnou loadHTMLString:baseStr baseURL:url];
    
    
}

- (void)tranNav:(UINavigationController *)nav andTabBar:(UITabBarController *)tab
{

    self.nav = nav;
    self.tab =tab;

}

-(void)webViewDidFinishLoad:(UIWebView *)webView{

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
