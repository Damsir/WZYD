//
//  ChangePasswordVC.m
//  XAYD
//
//  Created by songdan Ye on 16/5/6.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "ChangePasswordVC.h"
#import "MBProgressHUD+MJ.h"
#import "LoginViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "Global.h"
@interface ChangePasswordVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIView *backgroundView;
@property (nonatomic,strong)UITextField *olderPassworldTextfield;
@property (nonatomic,strong)UITextField *nPassworldTextfield;
@property (nonatomic,strong)UITextField *confirmNewPasswordTextfield;
@property (nonatomic,strong)UIButton *revertBtn;
@property (nonatomic,strong)UITableView *revertTableView;
@property (nonatomic,strong)NSArray *tipNmae;
@property (nonatomic,strong)NSArray *placeHoldeName;

@end

@implementation ChangePasswordVC

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
    
    //self.title=@"修改登录密码";
    [self initNavigationBarTitle:@"修改密码"];
    
    self.view.backgroundColor =RGB(240, 240, 240);
    
    [self createTabelview];
    [self  createRevertBtn];
    //    [self createChangePasswordV];
    _tipNmae = @[@"当前登录密码:",@"新密码:",@"确认:"];
    _placeHoldeName = @[@"请输入原始密码",@"请设置新密码",@"请再次填入"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    
}
#pragma -mark  UITableViewDataSource,UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *idemtity= @"cellidentity";
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idemtity];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    UILabel *label=  [self createLabelwithframe:CGRectMake(10, 0, 100, 50) font:15 title:_tipNmae[indexPath.row] titleColor:[UIColor blackColor]];
    
    UITextField *textField =[[UITextField alloc] initWithFrame:CGRectMake(120, 0, MainR.size.width-140, 50)];
    textField.font = [UIFont systemFontOfSize:15];
    textField.clearButtonMode=UITextFieldViewModeAlways;
    textField.delegate =self;
    textField.tag = indexPath.row;
    textField.borderStyle =UITextBorderStyleNone;
    textField.placeholder = _placeHoldeName[indexPath.row];
    textField.returnKeyType =UIReturnKeyDone;
    UIView *line =[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(textField.frame), MainR.size.width-10, 1)];
    line.backgroundColor =RGB(238.0, 238.0, 238.0);
    [cell.contentView addSubview:label];
    if (indexPath.row ==0) {
        _olderPassworldTextfield= textField;
        [cell.contentView addSubview:_olderPassworldTextfield];
        
    }else if (indexPath.row==1)
    {
        _nPassworldTextfield=textField;
        [cell.contentView addSubview:_nPassworldTextfield];
        
    }else
    {
        
        _confirmNewPasswordTextfield= textField;
        [cell.contentView addSubview:_confirmNewPasswordTextfield];
    }
    [cell.contentView addSubview:line];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



- (void)createTabelview
{
    
    UITableView *revertTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width,150) style:UITableViewStylePlain];
    revertTableView.delegate =self;
    revertTableView.dataSource = self;
    revertTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    revertTableView.scrollEnabled = NO;
    revertTableView.allowsSelection = NO;
    _revertTableView =revertTableView;
    //
    [self.view addSubview:_revertTableView];
    
    
    
}

- (void)change
{
    //    self.backgroundView.frame = CGRectMake(0, 10, MainR.size.width, 150);
    //    self.olderPassworldTextfield.frame =CGRectMake(0, 0, _backgroundView.frame.size.width, 50);
    //    self.nPassworldTextfield.frame = CGRectMake(0, CGRectGetMaxY(self.olderPassworldTextfield.frame), self.backgroundView.frame.size.width, 50);
    //    self.confirmNewPasswordTextfield.frame =CGRectMake(0, 100, self.backgroundView.frame.size.width, 50);
    //    _revertBtn.frame = CGRectMake(10, CGRectGetMaxY(self.backgroundView.frame)+30, MainR.size.width-20, 44);
    [self.revertTableView reloadData];
    self.revertTableView.frame = CGRectMake(0, 0, MainR.size.width,150);
    _revertBtn.frame = CGRectMake(10, CGRectGetMaxY(self.revertTableView.frame)+30, MainR.size.width-20, 44);
    
    
}
- (void)createRevertBtn
{
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, CGRectGetMaxY(self.revertTableView.frame)+30, MainR.size.width-20, 44);
    btn.backgroundColor =RGB(34, 152, 239);
    
    [btn setTitle:@"修改" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(revertPassword) forControlEvents:UIControlEventTouchUpInside];
    _revertBtn = btn;
    [self.view addSubview:_revertBtn];
    
    
}
//- (void) createChangePasswordV
//{
//    UIView *backgroundView=[[UIView alloc] initWithFrame:CGRectMake(0, 10, MainR.size.width, 150)];
//    backgroundView.backgroundColor =[UIColor whiteColor];
//    
//    _backgroundView = backgroundView;
//    
//    
//    UITextField *olderPassword =[self createViewWithFrame:CGRectMake(0, 0, _backgroundView.frame.size.width, 50) titleName:@"当前登录密码:"placeholdName:@"请输入原始密码" withTag:100];
//    self.olderPassworldTextfield =olderPassword;
//    UITextField *nPassword = [self createViewWithFrame:CGRectMake(0, CGRectGetMaxY(olderPassword.frame), self.backgroundView.frame.size.width, 50) titleName:@"新密码:"placeholdName:@"请设置新密码"withTag:101];
//    self.nPassworldTextfield =nPassword;
//    UITextField *confirmNewPassword =[self createViewWithFrame:CGRectMake(0, 100, self.backgroundView.frame.size.width, 50) titleName:@"确认:"placeholdName:@"请再次填入"withTag:102];
//    self.confirmNewPasswordTextfield =confirmNewPassword;
//    [self.view addSubview:_backgroundView];
//    
//    
//    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(10, CGRectGetMaxY(self.backgroundView.frame)+30, MainR.size.width-20, 44);
//    btn.backgroundColor =RGB(34, 152, 239);
//    
//    [btn setTitle:@"修改" forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(revertPassword) forControlEvents:UIControlEventTouchUpInside];
//    _revertBtn = btn;
//    [self.view addSubview:_revertBtn];
//    
//    
//}
- (void)revertPassword
{
    
    [self.olderPassworldTextfield resignFirstResponder];
    [self.nPassworldTextfield resignFirstResponder];
    [self.confirmNewPasswordTextfield resignFirstResponder];
    
    if([self.nPassworldTextfield.text isEqualToString:self.confirmNewPasswordTextfield.text])
    {
        if ([self.olderPassworldTextfield.text isEqualToString:self.confirmNewPasswordTextfield.text])
        {
            [MBProgressHUD showError:@"新密码不能和旧密码一样"];
        }
        else
        {
            [self loadData];
            
        }
    }
    else
    {
        [MBProgressHUD showError:@"两次输入的新密码不一致"];
        
    }
    
}


-(void)loadData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters;
    
    [MBProgressHUD showMessage:@"密码修改中" toView:self.view];

    NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/ModifyPwd.ashx"];
    parameters = @{@"uid":[Global myuserId],@"sourPwd":self.olderPassworldTextfield.text,@"newPwd":_nPassworldTextfield.text,@"DeviceId":[Global deviceUUID],@"username":[Global userName]};
    //
    NSMutableString *requestAddress = [NSMutableString stringWithString:[Global serverAddress]];
    [requestAddress appendString:@"?"];
    
    if (nil!=parameters) {
        for (NSString *key in parameters.keyEnumerator) {
            NSString *val = [parameters objectForKey:key];
            [requestAddress appendFormat:@"&%@=%@",key,val];
        }
    }
    
    NSLog(@"修改密码%@",requestAddress);
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
        NSDictionary *JsonDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];

        if ([[JsonDic objectForKey:@"result"] isEqual:@1]) {

            [MBProgressHUD showSuccess:@"修改成功"];
            //把保存的密码情况
            [defaults setObject:self.nPassworldTextfield.text forKey:@"pwd"];
            [defaults setBool:NO forKey:@"rem"];
            [defaults setBool:NO forKey:@"auto"];
            //强制同步
            [defaults synchronize];
            
            LoginViewController *logInV =[[LoginViewController alloc] init];
            
            self.view.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:logInV];
            
        }
       else
       {
            [MBProgressHUD showError:@"密码修改失败,请确认原始密码是否正确"];
                
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
    }];
}




- (UILabel *)createLabelwithframe:(CGRect)rect font:(CGFloat)font title:(NSString *)title titleColor:(UIColor *)color
{
    UILabel *label =[[UILabel alloc] initWithFrame:rect];
    label.font = [UIFont systemFontOfSize:font];
    [label setText:title];
    label.textColor =color;
    [label setTextAlignment:UITextAlignmentLeft];
    return label;
    
    
    
}

- (UITextField *)createViewWithFrame:(CGRect)rect titleName:(NSString *)titleName placeholdName:(NSString *)placehold withTag:(NSInteger)tag
{
    UIView *baView =[[UIView alloc] initWithFrame:rect];
    UILabel *label=  [self createLabelwithframe:CGRectMake(10, 0, 100, 50) font:15 title:titleName titleColor:[UIColor blackColor]];
    
    UITextField *textField =[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+10, 0, self.backgroundView.frame.size.width-CGRectGetMaxX(label.frame)-10, 50)];
    textField.font = [UIFont systemFontOfSize:15];
    textField.clearButtonMode=UITextFieldViewModeAlways;
    textField.delegate =self;
    textField.tag = tag;
    textField.borderStyle =UITextBorderStyleNone;
    textField.placeholder = placehold;
    textField.returnKeyType =UIReturnKeyDone;
    UIView *line =[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(textField.frame), self.backgroundView.frame.size.width-10, 1)];
    line.backgroundColor =RGB(238.0, 238.0, 238.0);
    [baView addSubview:label];
    [baView addSubview:textField];
    [baView addSubview:line];
    [self.backgroundView addSubview:baView];
    return textField;
    
}


#pragma mark - textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    
    //if(textField.tag == 100)
    //{
    //    NSLog(@"检测密码正确与否");
    //    if ([self.olderPassworldTextfield.text isEqualToString:@""]) {
    //        //原始密码为空
    //        [MBProgressHUD showError:@"请输入原始密码"];
    //
    //    }else if (![self.olderPassworldTextfield.text isEqualToString:[defaults objectForKey:@"pwd"]] )
    //    {
    //        NSLog(@"++++%@",[defaults objectForKey:@"pwd"]);
    //    [MBProgressHUD showError:@"原始密码不正确"];
    //        self.olderPassworldTextfield.text = nil;
    //    }
    //    else
    //    {
    //        NSLog(@"原始密码正确");
    //
    //
    //    }
    //
    //}
    //
    //    if(textField.tag == 102)
    //    {
    //    if([self.nPassworldTextfield.text isEqualToString:@""])
    //    {
    //
    //        [MBProgressHUD showError:@"请输入新密码"];
    //    }
    //    if(![self.confirmNewPasswordTextfield.text isEqualToString:self.nPassworldTextfield.text])
    //        [MBProgressHUD showError:@"亲!2次密码输入不一样!"];
    //
    //    }
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.olderPassworldTextfield resignFirstResponder];
    [self.nPassworldTextfield resignFirstResponder];
    [self.confirmNewPasswordTextfield resignFirstResponder];
    
    
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
