//
//  SendMailViewController.m
//  WZYD
//
//  Created by 吴定如 on 16/11/2.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "SendMailViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "Global.h"
#import "MailContactModel.h"
#import "DamMemberList.h"

@interface SendMailViewController () <UITextFieldDelegate,UITextViewDelegate>

@property(nonatomic,strong) UILabel *startLabel;
@property(nonatomic,strong) UILabel *finishLabel;
@property(nonatomic,strong) UILabel *contextLabel;
@property(nonatomic,strong) UITextField *startText;
@property(nonatomic,strong) UITextField *finishText;
@property(nonatomic,strong) UITextView *contentText;
@property(nonatomic,strong) UIButton *searchBtn;
@property(nonatomic,strong) UIButton *clearBtn;
@property(nonatomic,strong) DamMemberList *memberView;
@property(nonatomic,strong) NSMutableArray *contacts;
@property(nonatomic,strong) NSString *mailID;

@end

@implementation SendMailViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    //self.navigationItem.title = @"发邮件";
    [self initNavigationBarTitle:@"发邮件"];
    
    _mailID = @"";
    [self createUI];
    //[self loadContactsData];
    
    //键盘唤起和隐藏的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //监听屏幕旋转的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}
//屏幕旋转改变视图的Frame
-(void)screenRotation:(NSNotification *)noti
{
    _startLabel.frame = CGRectMake(20, 20, 90, 40);
    _startText.frame = CGRectMake(CGRectGetMaxX(_startLabel.frame), 20, MainR.size.width-130, 40);
    _finishLabel.frame = CGRectMake(20, CGRectGetMaxY(_startLabel.frame)+20, 90, 40);
    _finishText.frame = CGRectMake(CGRectGetMaxX(_finishLabel.frame), CGRectGetMaxY(_startLabel.frame)+20, MainR.size.width-130, 40);
    _contextLabel.frame = CGRectMake(20, CGRectGetMaxY(_finishLabel.frame)+20, 90, 40);
    _contentText.frame = CGRectMake(CGRectGetMaxX(_contextLabel.frame), CGRectGetMaxY(_finishLabel.frame)+20, MainR.size.width-130, 200);
    
    CGFloat btn_W = (MainR.size.width-60)/2;
    _clearBtn.frame = CGRectMake(20, CGRectGetMaxY(_contentText.frame) + 30, btn_W, 40);
    _searchBtn.frame = CGRectMake(CGRectGetMaxX(_clearBtn.frame)+20, _clearBtn.frame.origin.y, btn_W, 40);
    
    _memberView.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height);
    [_memberView screenRotation];
    
}

-(void)createUI
{
    UILabel *startLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 90, 40)];
    startLabel.text = @"收  件  人";
    startLabel.font = [UIFont boldSystemFontOfSize:17.5];
    startLabel.textColor = BLUECOLOR;
    _startLabel = startLabel;
    [self.view addSubview:startLabel];
    
    UITextField *startText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(startLabel.frame), 20, MainR.size.width-130, 40)];
    startText.delegate = self;
    startText.placeholder = @"选择收件人";
    startText.borderStyle = UITextBorderStyleRoundedRect;
    startText.clearButtonMode = UITextFieldViewModeAlways;
    startText.returnKeyType = UIReturnKeyDone;
    _startText = startText;
    [self.view addSubview:startText];
    
    UILabel *finishLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(startLabel.frame)+20, 90, 40)];
    finishLabel.text = @"邮件主题";
    finishLabel.font = [UIFont boldSystemFontOfSize:17.5];
    finishLabel.textColor = BLUECOLOR;
    _finishLabel = finishLabel;
    [self.view addSubview:finishLabel];
    
    UITextField *finishText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(finishLabel.frame), CGRectGetMaxY(startLabel.frame)+20, MainR.size.width-130, 40)];
    finishText.delegate = self;
    finishText.placeholder = @"输入邮件主题";
    finishText.clearButtonMode = UITextFieldViewModeAlways;
    finishText.borderStyle = UITextBorderStyleRoundedRect;
    finishText.returnKeyType = UIReturnKeyDone;
    _finishText = finishText;
    [self.view addSubview:finishText];
    
    
    UILabel *contextLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(finishLabel.frame)+20, 90, 40)];
    contextLabel.text = @"邮件内容";
    contextLabel.font = [UIFont boldSystemFontOfSize:17.5];
    contextLabel.textColor = BLUECOLOR;
    _contextLabel = contextLabel;
    [self.view addSubview:contextLabel];
    
    UITextView *contentText = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(contextLabel.frame), CGRectGetMaxY(finishText.frame)+20, MainR.size.width-130, 200)];
    contentText.text = @"输入邮件内容";
    contentText.font = [UIFont systemFontOfSize:17.0];
    if ([contentText.text isEqualToString:@"输入邮件内容"])
    {
        contentText.textColor = [UIColor lightGrayColor];
    }
    contentText.layer.borderWidth = 0.5;
    contentText.layer.borderColor = GRAYCOLOR_MIDDLE.CGColor;
    contentText.layer.cornerRadius = 5;
    contentText.clipsToBounds = YES;
    contentText.returnKeyType = UIReturnKeyDone;
    contentText.delegate = self;
    _contentText = contentText;
    [self.view addSubview:contentText];
    
    
    // 判断是否是回复 or 发送
    if (_model && [_fsOrhf isEqualToString:@"hf"])
    {
        _startText.text = _model.SenderName;
        
        NSRange range = [_model.EmailTile rangeOfString:@"回复:"];
        if (range.location != NSNotFound) {
            _finishText.text = _model.EmailTile;
        }else{
            _finishText.text = [NSString stringWithFormat:@"回复:%@", _model.EmailTile];
        }
        _mailID = _model.MailID;
        [self initNavigationBarTitle:@"回复邮件"];
        // 回复
        [self loadSenderUserDetailData];
    }
    else if (_model && [_fsOrhf isEqualToString:@"fs"])
    {
        // fs->发送(草稿里的邮件)
        _startText.text = _model.TargetName;
        _finishText.text = _model.EmailTile;
        _mailID = _model.MailID;
        _contentText.text = _model.body;
    }
    
    
    CGFloat btn_W = (MainR.size.width-60)/2;
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    clearBtn.frame = CGRectMake(20, CGRectGetMaxY(contentText.frame) + 30, btn_W, 40);
    [clearBtn setTitle:@"保存草稿" forState:UIControlStateNormal];
    clearBtn.backgroundColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:239/255.0 alpha:1.0];
    [clearBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(saveToDraft) forControlEvents:UIControlEventTouchUpInside];
    clearBtn.layer.cornerRadius = 3;
    clearBtn.clipsToBounds = YES;
    _clearBtn = clearBtn;
    [self.view addSubview:clearBtn];
    
    // 发送 (隐藏草稿)
    if ([_fsOrhf isEqualToString:@"fs"])
    {
//        _clearBtn.backgroundColor = GRAYCOLOR;
//        [_clearBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        _clearBtn.enabled = NO;
    }
    
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    searchBtn.frame = CGRectMake(CGRectGetMaxX(clearBtn.frame)+20, clearBtn.frame.origin.y, btn_W, 40);
    searchBtn.backgroundColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:239/255.0 alpha:1.0];
    [searchBtn setTitle:@"发送" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(sendMail) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.layer.cornerRadius = 3;
    searchBtn.clipsToBounds = YES;
    _searchBtn = searchBtn;
    [self.view addSubview:searchBtn];
    
    
//    UIButton *selectContacts = [self createButtonWithTitle:@"选择收件人" andFrame:CGRectMake(0, 0, 80, 30)];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:selectContacts];
    
   // self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"收件人" style:UIBarButtonItemStylePlain target:self action:@selector(selectedContacts)];
    
}

#pragma mark -- 回复时的发送人详情
-(void)loadSenderUserDetailData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/UserDetail.ashx"];
    NSDictionary *paremeters = @{@"userID":_model.SenderID,@"deviceNumber":[Global deviceUUID],@"username":[Global userName]};
    
    [manager POST:url parameters:paremeters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *JsonDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
         
         NSArray *result = [JsonDic objectForKey:@"result"];
         if (result.count)
         {
             // 回复
             _startText.text = [[result firstObject] objectForKey:@"LoginName"];
         }
         else
         {
            
         }
         
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"error:%@",error);
    }];
    
}

#pragma mark -- 发送邮件
-(void)sendMail
{
    [self.view endEditing:YES];
    
    if ([_startText.text isEqualToString:@""]||[_finishText.text isEqualToString:@""]||[_contentText.text isEqualToString:@""]||[_contentText.text isEqualToString:@"输入邮件内容"])
    {
        [MBProgressHUD showError:@"请先将内容填写完全"];
    }
    else
    {
        //加载提示框
        [MBProgressHUD showMessage:@"正在发送" toView:self.view];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];

        NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/mail/SendEmail.ashx"];
        NSDictionary *paremeters = @{@"senderID":[Global userId],@"targetNames":_startText.text,@"title":_finishText.text,@"remove":_mailID,@"content":_contentText.text,@"deviceNumber":[Global deviceUUID],@"username":[Global userName]};
        
        [manager POST:url parameters:paremeters success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             [MBProgressHUD hideHUDForView:self.view animated:NO];
             
             NSDictionary *JsonDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
             
             if ([[JsonDic objectForKey:@"result"] isEqual:@1])
             {
                 if ([_fsOrhf isEqualToString:@"fs"]) {
                     [MBProgressHUD showSuccess:@"发送成功"];
                 }else if ([_fsOrhf isEqualToString:@"hf"]){
                     [MBProgressHUD showSuccess:@"回复成功"];
                 }
                 
                [self.navigationController popToRootViewControllerAnimated:YES];
                     // 发送成功通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"sendMailSuccess" object:self userInfo:nil];
                     
            
//                 [UIView animateWithDuration:1.5 animations:^{
//                     
//                     [MBProgressHUD showSuccess:@"发送成功"];
//                     
//                 } completion:^(BOOL finished) {
//                     
//                     [self.navigationController popViewControllerAnimated:YES];
//                 } ];
             }
             else
             {
                 if ([_fsOrhf isEqualToString:@"fs"]) {
                     [MBProgressHUD showError:@"发送失败"];
                 }else if ([_fsOrhf isEqualToString:@"hf"]){
                     [MBProgressHUD showError:@"回复失败"];
                 }
             }
             
         }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //加载提示框
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            [MBProgressHUD showError:@"发送失败"];

        }];
    }
    
}

// 保存草稿
-(void)saveToDraft
{
    [self.view endEditing:YES];
    if ([_startText.text isEqualToString:@""]||[_finishText.text isEqualToString:@""]||[_contentText.text isEqualToString:@""]||[_contentText.text isEqualToString:@"输入邮件内容"])
    {
        [MBProgressHUD showError:@"请先将内容填写完全"];
    }
    else
    {
        //加载提示框
        [MBProgressHUD showMessage:@"正在保存" toView:self.view];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/mail/SaveDraft.ashx"];
        NSDictionary *paremeters = @{@"mailID":@"",@"sender":[Global userId],@"body":_contentText.text,@"title":_finishText.text,@"rec":_startText.text,@"deviceNumber":[Global deviceUUID],@"username":[Global userName]};
        
        [manager POST:url parameters:paremeters success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             //加载提示框
             [MBProgressHUD hideHUDForView:self.view animated:NO];
             
             NSDictionary *JsonDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
             
             if ([[JsonDic objectForKey:@"result"] isEqual:@1])
             {
                 [MBProgressHUD showSuccess:@"保存成功"];
                 //_mailID = [responseObject objectForKey:@"result"];
                 // 发送保存草稿成功通知
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"saveDraftSuccess" object:self userInfo:nil];

             }
             else
             {
                 [MBProgressHUD showError:@"保存失败"];
             }
             

         }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             //加载提示框
             [MBProgressHUD hideHUDForView:self.view animated:NO];
             [MBProgressHUD showError:@"保存失败"];
             
        }];
    }
    
}

#pragma mark -- textField代理

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _startText)
    {
        // 选择收件人
        [self selectedContacts];
        return NO;
    }
    else if (textField == _finishText)
    {
        
    }
    return YES;
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"输入邮件内容"])
    {
        textView.text = @"";
    }
    textView.textColor =[UIColor blackColor];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0)
    {
        textView.textColor =[UIColor lightGrayColor];
        textView.text = @"输入邮件内容";
    }
}


//点击键盘右下角的键收起键盘
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        if (textView.text.length == 0)
        {
            textView.textColor =[UIColor lightGrayColor];
            textView.text = @"输入邮件内容";
        }
        else
        {
            textView.textColor =[UIColor blackColor];
        }
        [textView resignFirstResponder];
    }
    return YES;
}

// 键盘升起/隐藏
-(void)keyboardWillShow:(NSNotification *)noti
{
    // 获取键盘弹出的动画时间
    CGFloat durtion = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGSize keyboardSize = [noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].size ;
    CGFloat keyboard_h = keyboardSize.height;
    //NSLog(@"1=====%f",keyboard_h);
    if (!self.startText.isEditing && !self.finishText.isEditing && MainR.size.height < 768) {
        
        [UIView animateWithDuration:durtion animations:^{
            
            CGRect textFrame = self.view.frame;
            
            textFrame.origin.y = 64-130;
            
            self.view.frame = textFrame;
        }];
    }
}
-(void)keyboardWillHide:(NSNotification *)noti
{
    // 获取键盘弹出的动画时间
    CGFloat durtion = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGSize keyboardSize = [noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].size ;
    CGFloat keyboard_h = keyboardSize.height;
    NSLog(@"2=====%f",keyboard_h);
    if (!self.startText.isEditing && !self.finishText.isEditing && MainR.size.height <= 768){
      
        [UIView animateWithDuration:durtion animations:^{
            
            CGRect textFrame = self.view.frame;
            
            textFrame.origin.y = 64;
            
            self.view.frame = textFrame;
            
        }];
    }
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

// customButton
-(UIButton *)createButtonWithTitle:(NSString *)title andFrame:(CGRect)frame
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = BLUECOLOR;
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    button.layer.cornerRadius = 2;
    button.clipsToBounds = YES;
    // 按钮对齐方式设置
    button.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    button.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    button.titleLabel.font = [UIFont systemFontOfSize:14.5];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [button addTarget:self action:@selector(selectedContacts) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

// 选择联系人
-(void)selectedContacts
{
    //退出所有键盘
    [self.view endEditing:YES];
    
//    _contacts = [NSMutableArray array];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    
//    
//    NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/mail/SendList.ashx"];
//    
//    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//         // 人员列表数组
//         NSArray *result = [responseObject objectForKey:@"result"];
//         if (result.count)
//         {
//             
//         }else{
//             [MBProgressHUD showError:@"人员列表加载失败"];
//         }
//         
//     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//         [MBProgressHUD showError:@"人员列表加载失败"];
//         NSLog(@"error:%@",error);
//     }];

    
    
    DamMemberList *memberView = [[DamMemberList alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, MainR.size.height) withTitle:@"收件人"];
    memberView.selectedContactBlock = ^(NSString *contacts)
    {
        _startText.text = contacts;
    };
    _memberView = memberView;
    [memberView showInView:self.view.window.rootViewController.view animated:YES];
    
}

// 
-(void)loadContactsData
{
    _contacts = [NSMutableArray array];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/mail/SendList.ashx"];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSArray *array = [responseObject objectForKey:@"result"];
         
         for (NSDictionary *dic in array)
         {
             MailContactModel *model = [[MailContactModel alloc] initWithDictionary:dic];
             [_contacts addObject:model];
         }
         
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"error:%@",error);
     }];
}

@end
