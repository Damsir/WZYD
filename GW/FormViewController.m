//
//  FormViewController.m
//  iBusiness
//
//  Created by zhangliang on 15/5/4.
//  Copyright (c) 2015年 sh. All rights reserved.
//

#import "FormViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "DejalActivityView.h"
#import "Global.h"
#import "ZQButton.h"

@interface FormViewController (){
    NSDictionary *_project;
    NSArray *_formList;
    NSDictionary *_formDefines;
    int _formIndex;
    BOOL _webViewLoaded;
    BOOL _formListLoaded;
    int _formPickerSelectedIndex;
    UIView *_bottomView;

}

@end

@implementation FormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _formIndex = -1;
//    NSString *url1=@"http://192.168.2.246/wsyd/ServiceProvider.ashx";

    NSString *urlStr=[NSString stringWithFormat:@"%@?type=formpage&r=%f",[Global serviceUrl],roundf(3.1415)];
//        NSString *urlStr=[NSString stringWithFormat:@"%@?type=formpage",[Global serverAddress]];

    NSURL *url =[NSURL URLWithString:urlStr];
    NSURLRequest *request= [NSURLRequest requestWithURL:url];
    
    [self.formView loadRequest:request];
    self.formView.scalesPageToFit = YES;
    //[self loadFormList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onFormPickCancel:(id)sender {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        self.formPickView.frame = CGRectMake(0, self.view.frame.size.height, self.formPickView.frame.size.width, self.formPickView.frame.size.height);
    } completion:^(BOOL finished){
        self.formPickView.hidden = YES;
    }];
}

- (IBAction)onFormPickOk:(id)sender {
    [self onFormPickCancel:nil];
    [self loadForm:_formPickerSelectedIndex];
}

-(void)projectInfo:(NSDictionary *)data{
    _project = data;
}


/*

-(void)loadFormList{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    NSDictionary *parameters = @{@"user":@"526",@"type":@"smartplan",@"action":@"formlist",@"project":@"955"};
    NSDictionary *parameters = @{@"user":[Global myuserId],@"type":@"smartplan",@"action":@"formlist",@"project":[_project objectForKey:@"identity"]};

//    [Global myuserId]
//    [_project objectForKey:@"identity"];
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"加载数据6"];
    [manager POST:[Global serverAddress] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rs = (NSDictionary *)responseObject;
        if ([[rs objectForKey:@"success"] isEqualToString:@"true"]) {
            _formList = [rs objectForKey:@"result"];
            [DejalBezelActivityView removeViewAnimated:YES];
            _formListLoaded = YES;
            [self formListLoaded];
            
        }else{
            [self showError];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showError];
    }];
}

 */
-(void)formListLoaded{
    if (_formList.count>1) {
        /*ZQButton *navBtn=[ZQButton buttonWithType:UIButtonTypeCustom];
        navBtn.clickFadeColor=[UIColor colorWithRed:70.0/255 green:126.0/255 blue:243.0/255 alpha:0];
        navBtn.frame=CGRectMake(0, 0, 32, 32);
        [navBtn setImage:[UIImage imageNamed:@"more_top.png"] forState:UIControlStateNormal];
        [navBtn addTarget:self action:@selector(onMoreBtnTap) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:navBtn];
        self.formPicker.dataSource = self;*/
        [self loadForm:1];
    }else if(_formList.count==1){
        [self loadForm:0];
    }
}

-(void)loadForm:(int)index{
    /*if (!_webViewLoaded || index==_formIndex) {
        return;
    }*/
    if (index == 0) {
        _formIndex = index;
        NSDictionary *formInfo = [_formList objectAtIndex:index];
        self.title = [formInfo objectForKey:@"name"];
        if(_meetingForm)
        {
        [self.formView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.loadForm('%@','%@','%@')",[_project objectForKey:@"busiFormId"],[_project objectForKey:@"project"],[_project objectForKey:@"identity"]]];
        }else
        {
        
        [self.formView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.loadForm('%@','%@','%@')",[Global myuserId],[_project objectForKey:@"identity"],[formInfo objectForKey:@"identity"]]];
        }
        
        
    }
    else
    {
        for (int i =0; i<_formList.count; i++) {
            NSDictionary *formInfo = [_formList objectAtIndex:i];
            NSString *name = [formInfo objectForKey:@"name"];
            if ([name  isEqual: @"会议通报单word"]) {
                self.title = name;
                [self.formView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.loadForm('%@','%@','%@')",[Global myuserId],[_project objectForKey:@"identity"],[formInfo objectForKey:@"identity"]]];

            }
        }
    }
}

-(void)showError{
    [DejalBezelActivityView removeViewAnimated:YES];
    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"表单加载失败" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil] show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    _webViewLoaded = YES;
//    self.title = [_project objectForKey:@"name"];
    NSString *str=@"";
    if(_meetingForm)
    {
   str =[NSString stringWithFormat:@"window.loadForm('%@','%@','%@')",[_project objectForKey:@"busiFormId"],[_project objectForKey:@"project"],[_project objectForKey:@"identity"]];
       
    }
    else
    {
    
     str =[NSString stringWithFormat:@"window.loadForm('%@','%@','%@')",[Global myuserId],[_project objectForKey:@"project"],[_project objectForKey:@"identity"]];
    }
    
   
    [self.formView stringByEvaluatingJavaScriptFromString:str];
    
//    if(_formListLoaded && _formList.count>0)
//        //[self loadForm:0];
//        [self formListLoaded];
}

-(void)onMoreBtnTap{
    self.formPickView.frame = CGRectMake(0, self.view.frame.size.height, self.formPickView.frame.size.width, self.formPickView.frame.size.height);
    self.formPickView.hidden = NO;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        self.formPickView.frame = CGRectMake(0, self.view.frame.size.height-self.formPickView.frame.size.height, self.formPickView.frame.size.width, self.formPickView.frame.size.height);
    } completion:nil];

}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _formList.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSDictionary *formInfo = [_formList objectAtIndex:row];
    return [formInfo objectForKey:@"name"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _formPickerSelectedIndex = row;
    
}
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//       _bottomView=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-49, SCREEN_WIDTH, 49)];
//    _bottomView.backgroundColor=[UIColor grayColor];
//    [self.view addSubview:_bottomView];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
