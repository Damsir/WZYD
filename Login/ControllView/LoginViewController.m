//
//  LoginViewController.m
//  WZYD
//
//  Created by 吴定如 on 16/12/2.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h> // 震动
#import "RCAnimatedImagesView.h"
#import "AFHTTPRequestOperationManager.h"
#import "Global.h"
#import "SHHomeViewController.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworking.h"
#import "ApplyViewController.h"
#import "WarnViewController.h"
#import "DeviceInfo.h"
#import "DamUpdateManager.h"

static NSString *keyPath_CicrleAnimation = @"clickCicrleAnimation";
static NSString *keyPath_CicrleAnimationGroup = @"clickCicrleAnimationGroup";

@interface LoginViewController () <UITextFieldDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSString *deviceUUID;
@property (nonatomic,strong) CAShapeLayer *clickCicrleLayer;

@end

@implementation LoginViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    // 这个是苹果自带的屏幕左侧向右滑动 == 返回效果
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    // 背景动画
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(scrollAnimation) userInfo:nil repeats:YES];
    }
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //停止
    [_timer invalidate];
    _timer = nil;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 版本更新请求
    //[self checkVersion];
    [self checkUpdated];
    
//    UIDevice *device = [[UIDevice alloc] init];
//    device.systemVersion
//    device.systemName
//    device.name
//    NSString *UUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    _deviceUUID = [DeviceInfo deviceUUID];
    
    // 检测设备验证是否通过
    BOOL isPassApplyDevice = [[defaults objectForKey:@"isPassApplyDevice"] boolValue];
    if (!isPassApplyDevice)
    {
        // 设备是否申请过
        //        BOOL isSubmitApplyDevice = [[defaults objectForKey:@"isSubmitApplyDevice"] boolValue];
        //        if (isSubmitApplyDevice)
        //        {
        //            WarnViewController *warnVC = [[WarnViewController alloc] init];
        //            //[self.navigationController pushViewController:warnVC animated:YES];
        //            warnVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        //            //[self presentViewController:warnVC animated:YES completion:nil];
        //        }
        //        else{
        //            NSString *deviceId = [SvUDIDTools UDID];
        //            _deviceId = deviceId;
        // 没有通过,或者是第一次验证
        [self loadDeviceVerify];
        //        }
    }
    
    // 背景动画
    [self createBackAnimationView];
    
    self.userName.delegate=self;
    self.passWord.delegate=self;
    self.passWord.secureTextEntry = YES;
    self.loginBackView.layer.cornerRadius= 6;
    self.loginBackView.layer.masksToBounds = YES;
    self.loginButton.layer.cornerRadius = 6;
    self.loginButton.layer.masksToBounds = YES;
    if(MainR.size.height < 568)
    {
        self.loginBackView_top.constant = 50;
    }
    if(MainR.size.width > 414)
    {
        self.loginBackViewHight.constant = 400;
        self.loginBackView_left.constant = self.loginBackView_right.constant = (MainR.size.width-400)/2.0;
        if(MainR.size.width < MainR.size.height)
        {
            self.loginBackView_top.constant = 270;
        }
        else
        {
            self.loginBackView_top.constant = 170;
        }
        if (MainR.size.width >= 768)
        {
            self.loginButton_bottom.constant = 30;
        }
    }
    if (MainR.size.width == 320)
    {
        self.userLine_left.constant = self.userLine_right.constant = 20;
        self.loginButton_left.constant = self.loginButton_right.constant = 20;
        self.passWordLine_left.constant = self.passWordLine_right.constant = 20;
        self.userIcon_left.constant = self.passWordIcon_left.constant = 25;
        self.remenberButton_left.constant = self.autoLoginLabel_right.constant = 25;
    }
    
    /**
     *  Description
     */
    //self.loginPanelHeight =self.loginPanelViewHeight.constant;
    
    
    //读取本地存储的用户信息
    self.userName.text = [defaults objectForKey:@"name"];
    
    self.rememberButton.selected = [[defaults objectForKey:@"rem"] boolValue];
    if (self.rememberButton.selected)
    {
        self.passWord.text=[defaults objectForKey:@"pwd"];
    }
    else
    {
        self.passWord.text = @"";
    }
    
    self.autoLoginButton.selected = [[defaults objectForKey:@"auto"] boolValue];
    
    //设置记住密码按钮的图片
    if(self.rememberButton.selected == YES)
    {
        [self.rememberButton setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    }
    else
    {
        [self.rememberButton setImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
    }
    
    [self.rememberButton setImageEdgeInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
    [self.rememberButton addTarget:self action:@selector(selectedChanged:) forControlEvents:UIControlEventTouchUpInside];
    
    //设置自动登录按钮的图片
    if(self.autoLoginButton.selected == YES)
    {
        [self.autoLoginButton setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];}
    else
    {
        [self.autoLoginButton setImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
    }
    [self.autoLoginButton setImageEdgeInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
    [self.autoLoginButton addTarget:self action:@selector(autoLoginChanged:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //监听屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

#pragma mark -- 屏幕旋转

- (void)screenRotation:(NSNotification *)noti
{
    _scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH + 150, SCREEN_HEIGHT);
    _imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH + 150, SCREEN_HEIGHT);
//    if (SCREEN_WIDTH > 768)
//    {
//        _scrollView.contentSize = CGSizeMake(1.2*SCREEN_WIDTH, SCREEN_HEIGHT);
//        _imageView.frame = CGRectMake(0, 0, 1.2*SCREEN_WIDTH, SCREEN_HEIGHT);
//    }
    
    if(MainR.size.height < 568)
    {
        self.loginBackView_top.constant = 50;
    }
    if(MainR.size.width > 414) {
        
        self.loginBackViewHight.constant = 400;
        self.loginBackView_left.constant=self.loginBackView_right.constant=(MainR.size.width-400)/2.0;
        if(MainR.size.width < MainR.size.height)
        {
            self.loginBackView_top.constant = 270;
        }
        else
        {
            self.loginBackView_top.constant = 170;
        }
        if (MainR.size.width >= 768)
        {
            self.loginButton_bottom.constant = 30;
        }
        
    }
    if (MainR.size.width == 320)
    {
        self.userLine_left.constant = self.userLine_right.constant = 20;
        self.loginButton_left.constant = self.loginButton_right.constant = 20;
        self.passWordLine_left.constant = self.passWordLine_right.constant = 20;
        self.userIcon_left.constant = self.passWordIcon_left.constant = 25;
        self.remenberButton_left.constant = self.autoLoginLabel_right.constant = 25;
    }
    
    /**
     *  Description
     */
    //self.loginPanelHeight = self.loginPanelViewHeight.constant;
}

//自动登录改变修改图片
- (void)autoLoginChanged:(UIButton *)autoLogin
{
    autoLogin.selected = !autoLogin.selected;
    [self.autoLoginButton setSelected:autoLogin.selected];
    
    if(self.autoLoginButton.selected == YES)
    {
        [self.autoLoginButton setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
        self.rememberButton.selected = autoLogin.selected;
        [self.rememberButton setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    }
    else
    {
        [self.autoLoginButton setImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
    }
}

//记住密码值改变
- (void)selectedChanged:(UIButton *)remeberBtn
{
    remeberBtn.selected = !remeberBtn.selected;
    [self.rememberButton setSelected:remeberBtn.selected];
    if(self.rememberButton.selected == YES)
    {
        [self.rememberButton setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];}
    else
    {
        [self.rememberButton setImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
        [self.autoLoginButton setImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
        [self.autoLoginButton setSelected:remeberBtn.selected];
    }
}

- (void)checkVersion
{
    NSError *error;
    NSString *newVersion = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.dist.com.cn/App/wz/wzyd/version.txt"] encoding:NSUTF8StringEncoding error:&error];
    //NSString *newVersion = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.dist.com.cn/App/wz/wzydtest/version.txt"] encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"newVersion=%@",newVersion);
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"currentVersion=%@",currentVersion);
    
    
    if(newVersion != nil && ![newVersion isEqualToString:@""] && ![newVersion isEqualToString:currentVersion])
    {
        if (![newVersion isEqualToString:currentVersion]) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"新版本已发布" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"去更新", nil];
            
            [alert show];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        NSURL *url=[NSURL URLWithString:@"http://dist.com.cn/app/wz/wzyd"];
        //NSURL *url=[NSURL URLWithString:@"http://dist.com.cn/app/wz/wzydtest"];
        
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark -- 检测版本更新

-(void)checkUpdated{
    
    // 1.
    [DamUpdateManager compareVersionWithPlist:^(BOOL isNewVersion,NSString *versionAddress) {
        
        if(isNewVersion){
            // 当前是最新版本
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
            });
            return ;
            
        }else if(!isNewVersion && [versionAddress isEqualToString:VersionUrl_Dist]){
            [self showAlertWithDownloadUrl:AppDownloadUrl_Dist];
        }else if(!isNewVersion && [versionAddress isEqualToString:VersionUrl_Mayun]){
            [self showAlertWithDownloadUrl:AppDownloadUrl_Pgyer];
        }
    }];
    
    
    // 2.
//    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:PGY_APP_ID];
//    // 系统更新方法
//    //[[PgyUpdateManager sharedPgyManager] checkUpdate];
//    // 自定义更新方法
//    [[PgyUpdateManager sharedPgyManager] checkUpdateWithDelegete:self selector:@selector(updateMethod:)];
}

/**
 *  检查更新回调
 *
 *  @param response 检查更新的返回结果
 */
- (void)updateMethod:(NSDictionary *)response
{
    if (response[@"downloadURL"]) {
        
        NSString *message = response[@"releaseNote"];
        //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发现新版本,是否前往更新?" message:message delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil,nil];
        //        [alertView show];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"发现新版本,请前往更新" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:response[@"downloadURL"]]];
            //  调用checkUpdateWithDelegete后可用此方法来更新本地的版本号，本地存储的Build号被更新后，SDK会将本地版本视为最新。对当前版本调用检查更新方法将不再回传更新信息。
            [[PgyUpdateManager sharedPgyManager] updateLocalBuildNumber];
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:updateAction];
        //[alert addAction:cancelAction];
        [[UIApplication sharedApplication].keyWindow.rootViewController  presentViewController:alert animated:YES completion:nil];
    }
}

-(void)showAlertWithDownloadUrl:(NSString *)downloadUrl{
    
    NSError *error;
    NSString *updateContent = [NSString stringWithContentsOfURL:[NSURL URLWithString:UpdateUrl_Mayun] encoding:NSUTF8StringEncoding error:&error];
    // 提示更新
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"新版本已发布,请前往更新" message:updateContent preferredStyle:UIAlertControllerStyleAlert];
    
    //UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //            }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downloadUrl]];
    }];
    
    //[alert addAction:cancelAction];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)keyboardWillChange:(NSNotification  *)note
{
    // 获取键盘弹出的动画时间
    CGFloat durtion = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 获取键盘的frame
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (frame.origin.y == MainR.size.height) { // 没有弹出键盘
        [UIView animateWithDuration:durtion animations:^{
            
            self.view.transform =  CGAffineTransformIdentity;
        }];
    }else{ // 弹出键盘
        // 工具条往上移动258
        [UIView animateWithDuration:durtion animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0,-frame.size.height+self.tabBarController.tabBar.frame.size.height);
        }];
    }
    
}

//画圆
-(UIBezierPath *)drawclickCircleBezierPath:(CGFloat)radius{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    /**
     *  center: 弧线中心点的坐标
     radius: 弧线所在圆的半径
     startAngle: 弧线开始的角度值
     endAngle: 弧线结束的角度值
     clockwise: 是否顺时针画弧线
     *
     */
    [bezierPath addArcWithCenter:CGPointMake(0,0) radius:radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
    return bezierPath;
}

- (IBAction)loginButtonOnClick:(id)sender
{
    UIButton *loginButton = (UIButton *)sender;
    //点击出现白色圆形
    CAShapeLayer *clickCicrleLayer = [CAShapeLayer layer];
    _clickCicrleLayer = clickCicrleLayer;
    
    clickCicrleLayer.frame = CGRectMake(loginButton.bounds.size.width/2, loginButton.bounds.size.height/2, 5, 5);
    clickCicrleLayer.fillColor = [UIColor whiteColor].CGColor;
    clickCicrleLayer.path = [self drawclickCircleBezierPath:5].CGPath;
    [loginButton.layer addSublayer:clickCicrleLayer];
    
    //放大变色圆形
    CABasicAnimation *basicAnimation2 = [CABasicAnimation animationWithKeyPath:@"path"];
    basicAnimation2.duration = 0.5;
    basicAnimation2.toValue = (__bridge id _Nullable)([self drawclickCircleBezierPath:(loginButton.bounds.size.height - 10*2)/2].CGPath);
    basicAnimation2.removedOnCompletion = NO;
    basicAnimation2.fillMode = kCAFillModeForwards;
    [clickCicrleLayer addAnimation:basicAnimation2 forKey:keyPath_CicrleAnimation];
    
    //圆形变圆弧
    clickCicrleLayer.fillColor = [UIColor clearColor].CGColor;
    clickCicrleLayer.strokeColor = [UIColor whiteColor].CGColor;
    clickCicrleLayer.lineWidth = 10;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    
    //圆弧变大
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    basicAnimation.duration = 0.5;
    basicAnimation.toValue = (__bridge id _Nullable)([self drawclickCircleBezierPath:(loginButton.bounds.size.height - 10*2)].CGPath);
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    //变透明
    CABasicAnimation *basicAnimation1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    basicAnimation1.beginTime = 0.10;
    basicAnimation1.duration = 0.5;
    basicAnimation1.toValue = @0;
    basicAnimation1.removedOnCompletion = NO;
    basicAnimation1.fillMode = kCAFillModeForwards;
    
    animationGroup.duration = basicAnimation1.beginTime + basicAnimation1.duration;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.animations = @[basicAnimation,basicAnimation1];
    
    [clickCicrleLayer addAnimation:animationGroup forKey:keyPath_CicrleAnimationGroup];
    
    //退去软键盘
    [self.userName resignFirstResponder];
    [self.passWord resignFirstResponder];
    
    //把数据存起来
    [defaults setValue:self.userName.text forKey:@"name"];
    [defaults setBool:self.rememberButton.selected  forKey:@"rem"];
    
    //是否需要存储密码
    if (self.rememberButton.selected) {
        [defaults setValue:self.passWord.text forKey:@"pwd"];
    }
    else
    {
        [defaults setValue:@"" forKey:@"pwd"];
    }
    NSString *name = self.userName.text;
//    NSString *pwdTemp = @"";
    NSString *pwd = self.passWord.text;
    
    // 根据输入的用户名是否含有 (-test)字段,有(测试服务器236),没有(现场234)
    if ([self.userName.text containsString:@"-test"]) {
        [Global setUrl:@"http://61.153.29.236:8891/mobileService/"];
    }else{
        //[Global setUrl:@"http://61.153.29.234:8888/mobileService/"];
        [Global setUrl:@"http://117.149.227.87:50080/MobileService/"];
    }
    
    // 当输入为空时提醒
    if (name == nil || [name isEqualToString:@""]) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入用户名" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [message show];
    }else{
        
        [MBProgressHUD showMessage:@"正在登录" toView:self.view];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //申明返回的结果是json类型
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        
        //传入的参数
        NSString *token = [Global token];
        if (nil==token) {
            token = @"";
        }
        //NSDictionary *parameters = @{@"type":@"smartplan",@"action":@"login",@"name":name,@"pwd":pwd};
        NSDictionary *parameters = @{@"un":name,@"pwd":pwd};
        
        
        // 接口地址
        NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/Login.ashx"];
        // url = @"http://61.153.29.236:8891/mobileService/service/Login.ashx?un=lw&pwd=";
        
        NSMutableString *requestAddress=[NSMutableString stringWithFormat:@"%@",url];
        [requestAddress appendString:@"?"];
        
        if (nil!=parameters) {
            for (NSString *key in parameters.keyEnumerator) {
                NSString *val = [parameters objectForKey:key];
                [requestAddress appendFormat:@"&%@=%@",key,val];
            }
        }
        
        NSLog(@"登录%@",requestAddress);
        
        //发送请求
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *rs = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
            // 密码错误
            if (rs == nil)
            {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

                UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或密码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [message show];
            }
            else
            {
                // NSDictionary *rs = (NSDictionary *)responseObject;
                NSLog(@"rs::%@",rs);
                // NSLog(@"userId::%@",rs);
                //            if ([[rs objectForKey:@"success"] isEqualToString:@"true"]) {
                
                // 设备uuid
                NSString *deviceUUID = [defaults objectForKey:@"deviceUUID"];
                if ([deviceUUID isEqualToString:@""] || deviceUUID == nil) {
                    [Global setDeviceUUID:_deviceUUID];
                }else
                {
                    [Global setDeviceUUID:deviceUUID];
                }
                
                
                [Global initializeSystem:[Global Url] deviceUUID:[Global deviceUUID] user:[[rs objectForKey:@"data"] firstObject]];
                [Global setUserId:[[[rs objectForKey:@"data"] firstObject] objectForKey:@"id"]];
                
                //初始化用户信息
                [Global initializeUserInfo:self.userName.text userId:[[[rs objectForKey:@"data"] firstObject]objectForKey:@"id"] org:@""];
                [self loginSuccessfully];
                //            }
                //            else
                //            {
                //                UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或者密码不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                //                [message show];
                //
                //
                //            }
            }
            
            
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            // 震动
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [message show];
        }];
    }
    
}

-(void)loginSuccessfully{
    //登录成功后保存自动登录状态
    [defaults setBool:self.autoLoginButton.selected forKey:@"auto"];
    [defaults setValue:[Global serverAddress] forKey:@"serverAddress"];
    
    if(self.autoLoginButton.selected)
    {
        //获得系统时间
        NSDate * curdate=[NSDate date];
        [defaults setObject:curdate forKey:@"startTime"];
    }
    
    [defaults synchronize];
    
    //SHHomeViewController *homeVC=[[SHHomeViewController alloc] init];
    // homeVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    //[self presentViewController:homeVC animated:YES completion:nil];
    //[self.navigationController pushViewController:homeVC animated:YES];
    
    // 防止按钮重复点击
    self.loginButton.enabled = NO;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 1.8;
    transition.type = @"rippleEffect";
    //transition.type = @"cube";
    transition.subtype = kCATransitionFromRight;
    [_scrollView.layer addAnimation:transition forKey:nil];
//    [self.navigationController.view.layer addAnimation:transition forKey:nil];
//    SHHomeViewController *homeVC = [[SHHomeViewController alloc] init];
//    [self.navigationController pushViewController:homeVC animated:YES];
    
    // 定时
    [self performSelector:@selector(push:) withObject:nil afterDelay:1.5];
    
}
#pragma mark -- push
-(void)push:(id)sender
{
    // 防止按钮重复点击
    self.loginButton.enabled = YES;
    SHHomeViewController *homeVC = [[SHHomeViewController alloc] init];
    [self.navigationController pushViewController:homeVC animated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /**
     *  Description
     */
    //self.loginPanelViewHeight.constant = self.loginPanelHeight;
    
    [self.userName resignFirstResponder];
    [self.passWord resignFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    /**
     *  Description
     */
    //self.loginPanelViewHeight.constant = self.loginPanelHeight;
    
    [textField resignFirstResponder];
    return  YES;
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField.tag ==100)
    {
        if (MainR.size.width==320)
        {
            self.loginBackView_top.constant = 0;
        }
    }
    return  YES;
}

-(void)loadDeviceVerify
{
    // 设备验证是否通过(是否授权)
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    //NSString *url = [NSString stringWithFormat:@"%@%@",@"http://61.153.29.234:8888/mobileService/",@"service/Device.ashx"];
    NSString *url = DeviceVerify_Url;

    NSDictionary *paremeters = @{@"deviceNumber":_deviceUUID,@"action":@"validate"};
    
    //[MBProgressHUD showMessage:@"正在检测" toView:self.view];
    
    [manager POST:url parameters:paremeters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *JsonDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        // 0 待审核,1 正常,2 挂失,3 禁用,-1 新设备
        if ([[JsonDic objectForKey:@"result"] isEqualToString:@"1"])
        {
            
        }
        
        else if([[JsonDic objectForKey:@"result"] isEqualToString:@"-1"])
        {
            ApplyViewController *applyVC = [[ApplyViewController alloc] init];
            //[self.navigationController pushViewController:applyVC animated:YES];
            applyVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:applyVC animated:YES completion:nil];
        }
        else
        {
            WarnViewController *warnVC = [[WarnViewController alloc] init];
            //[self.navigationController pushViewController:warnVC animated:YES];
            warnVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:warnVC animated:YES completion:nil];
        }
        
        //[MBProgressHUD hideHUDForView:self.view animated:NO];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //[MBProgressHUD hideHUDForView:self.view animated:NO];
        [MBProgressHUD showError:@"网络连接失败!"];
        NSLog(@"%@",error);
    }];
    
}

#pragma mark -- 背景动画

-(void)createBackAnimationView
{
    if (!_scrollView) {
        UIImage *backImage = [UIImage imageNamed:@"bg1322.jpg"];
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        scroll.contentSize = CGSizeMake(SCREEN_WIDTH + 150, SCREEN_HEIGHT);
        scroll.contentOffset = CGPointMake(0, 0);
        scroll.bounces = NO;
        scroll.delegate = self;
        scroll.showsHorizontalScrollIndicator = NO;
        scroll.showsVerticalScrollIndicator = NO;
        scroll.userInteractionEnabled = NO;
        _scrollView = scroll;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH + 150, SCREEN_HEIGHT)];
        imageView.image = backImage;
        _imageView = imageView;
        //imageView.contentMode = UIViewContentModeScaleAspectFill;
        [scroll addSubview:imageView];
        [self.view addSubview:scroll];
        [self.view bringSubviewToFront:self.loginBackView];
        
//        if (SCREEN_WIDTH > 768)
//        {
//            scroll.contentSize = CGSizeMake(1.2*SCREEN_WIDTH, SCREEN_HEIGHT);
//            imageView.frame = CGRectMake(0, 0, 1.2*SCREEN_WIDTH, SCREEN_HEIGHT);
//        }
    }
    
//    if (!_timer) {
//        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(scrollAnimation) userInfo:nil repeats:YES];
//    }
    
}

-(void)scrollAnimation
{
    static BOOL isLeft = YES;
    if (isLeft)
    {
        [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x + 4.0, _scrollView.contentOffset.y) animated:YES];
        if (_scrollView.contentOffset.x >= _scrollView.contentSize.width - SCREEN_WIDTH - 10.0)
        {
            isLeft = NO;
        }
    }
    else
    {
        [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x - 4.0, _scrollView.contentOffset.y) animated:YES];
        if (_scrollView.contentOffset.x <= 10.0)
        {
            isLeft = YES;
        }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
