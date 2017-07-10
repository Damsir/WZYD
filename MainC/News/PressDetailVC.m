//
//  PressDetailVC.m
//  XAYD
//
//  Created by songdan Ye on 16/5/23.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "PressDetailVC.h"

@interface PressDetailVC ()

@end

@implementation PressDetailVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.nav.navigationBar.hidden = NO;
    self.tab.tabBar.hidden = YES;
    
}
//
//- (void) getUrlDetail
//{
//    
//    _webViewNews.delegate = self;
//    _webViewNews.scrollView.bounces = NO;
//    
//    NSString *urlstr = self.urlStr;
//    NSURL *url =[NSURL URLWithString:urlstr];
//    NSURLRequest *requst =[NSURLRequest requestWithURL:url];
//    _webViewNews.scalesPageToFit = YES;
//    [_webViewNews loadRequest:requst];
//}



- (void)viewDidLoad {
    [super viewDidLoad];
//     UIView *topNavView= [[UIView alloc] initWithFrame:CGRectMake(0, -64, MainR.size.width, 64)];
//    topNavView.backgroundColor =[UIColor whiteColor];
//    [self.view addSubview:topNavView];
//    [self getUrlDetail];
        UIView *topNavView =[[UIView alloc] initWithFrame:CGRectMake(0, -64, MainR.size.width, 64)];
        topNavView.backgroundColor =[UIColor whiteColor];
        [self.view addSubview:topNavView];
        
      
        //
        NSString *path = [[NSBundle mainBundle] pathForResource:@"webA" ofType:@"htm"];
        NSURL *url = [NSURL fileURLWithPath:path];
        NSURLRequest *request =[NSURLRequest requestWithURL:url];
        
        
        _webViewNews.scalesPageToFit = YES;
        _webViewNews.delegate = self;
        _webViewNews.scrollView.bounces = NO;
        [_webViewNews loadRequest:request];
        
        NSString *content =_pmodel.content;
        
        
        NSString *baseStr = [NSString stringWithFormat:@"<html>%@</html>",content];
        
        
        [_webViewNews loadHTMLString:baseStr baseURL:url];
        
        
}
    
   
    

- (void)transNav:(UINavigationController *)nav andTab:(UITabBarController *)tab
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
