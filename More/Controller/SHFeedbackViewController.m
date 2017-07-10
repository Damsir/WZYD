//
//  SHFeedbackViewController.m
//  distmeeting
//
//  Created by songdan Ye on 15/12/2.
//  Copyright (c) 2015年 dist. All rights reserved.
//

#import "SHFeedbackViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
@interface SHFeedbackViewController ()<UITextViewDelegate>

@property (nonatomic,strong)UIButton *rightBtn;
@property (nonatomic,strong) UITextView *textView;


@end

@implementation SHFeedbackViewController


- (void)uploadFeedBack
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 创建一个参数字典
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"content"] =_textView.text;
    
    params[@"userId"] =[defaults objectForKey:@"userId"] ;
    params[@"appidentify"]=@"6e4087ca-5585-3de1-b113-a1fc327ea1";
    // 发送get请求
    NSString *url = [NSString stringWithFormat:@"%@/DistMobile/mobile/app-feedBack.action",DistMUrl];

    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) { // 请求成功的时候调用
        
            [MBProgressHUD showSuccess:@"提交成功"];

    }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         [MBProgressHUD showError:@"网络繁忙,请稍后再试!!!"];
         
         
     }];
    
}

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden =  NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden= YES;
    self.navigationController.navigationBar.tintColor= [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    NSMutableDictionary *titleAttr =[NSMutableDictionary dictionary];
    titleAttr[NSForegroundColorAttributeName] =[UIColor blackColor];
    self.navigationController.navigationBar.titleTextAttributes = titleAttr;
    
//    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(uploadFB)];
//    
//    _rightBtn = self.navigationItem.rightBarButtonItem;
    self.view.backgroundColor =[UIColor colorWithRed:253.0/255 green:253.0/255 blue:253.0/255 alpha:1];
//    _rightBtn.enabled = NO;

    UITextView *textView =[[UITextView alloc] initWithFrame:CGRectMake(10, 44, MainR.size.width-20, 200)];
    textView.font =[UIFont systemFontOfSize:15];
    textView.backgroundColor =[UIColor whiteColor];
    textView.layer.borderColor = UIColor.lightGrayColor.CGColor;
    textView.layer.borderWidth = 1;
    textView.layer.cornerRadius = 6;
    textView.layer.masksToBounds = YES;
    textView.textAlignment =NSTextAlignmentLeft;
    textView.returnKeyType =UIReturnKeyDone;
    //未设置textView的起点不是最开始
    self.automaticallyAdjustsScrollViewInsets =NO;

    
    textView.delegate =self;
    [textView setText:@"留下你的宝贵意见,我们会努力完善"];
    [textView setTextColor:[UIColor lightGrayColor]];

    _textView =textView;
    [self.view addSubview:_textView];

    
    
    
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, MainR.size.height-64-64, MainR.size.width-20, 44);
    btn.backgroundColor =[UIColor lightGrayColor];


    [btn setTitle:@"发送" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(uploadFB) forControlEvents:UIControlEventTouchUpInside];
       _rightBtn = btn;
    [self.view addSubview:_rightBtn];
    _rightBtn.enabled = NO;

    

}

#pragma mark-textView 的代理方法

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"留下你的宝贵意见,我们会努力完善"]) {
        textView.text = @"";
        [textView setTextColor:[UIColor blackColor]];
        _rightBtn.enabled =NO;
    }
    
    
}
-(void)textViewDidChange:(UITextView *)textView
{

    if (_textView.text.length >0) {
        _rightBtn.enabled =YES;
        
        
        _rightBtn.backgroundColor =RGB(34, 152, 239);

    }
    else
    {
        _rightBtn.enabled =NO;
        
        _rightBtn.backgroundColor =[UIColor lightGrayColor];

    }

}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    _rightBtn.enabled =NO;
    
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)uploadFB
{

    
    [self uploadFeedBack];
      _textView.text = @"留下你的宝贵意见,我们会努力完善";
    [_textView setTextColor:[UIColor lightGrayColor]];

    
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
