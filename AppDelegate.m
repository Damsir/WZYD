//
//  AppDelegate.m
//  WZYD
//
//  Created by 叶松丹 on 16/7/21.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "AppDelegate.h"
#import "SHHomeViewController.h"
#import "LoginViewController.h"
#import "GesturesUnLock.h"
#import "Global.h"
#import "ApplyViewController.h"
#import "WarnViewController.h"
#import "AFNetworking.h"
#import "SvUDIDTools.h"
#import "MBProgressHUD+MJ.h"
#import "DamUpdateManager.h"


@interface AppDelegate ()

@property(strong,nonatomic) UINavigationController *nav;
@property(nonatomic,strong) LoginViewController *loginView;
@property(nonatomic,strong) SHHomeViewController *homeV;
@property(nonatomic,strong) NSTimer *timer;

@end

@implementation AppDelegate

//允许旋转
-(BOOL)shouldAutorotate{
    return YES;
}
//设置设备返回横竖屏
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    // 手机
    if(MainR.size.width <= 414)
    {
        return UIInterfaceOrientationMaskPortrait;
    }
    else // ipad
    {
        return  UIInterfaceOrientationMaskAll;
    }
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    // 
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:60 * 60 target:self selector:@selector(checkUpdated) userInfo:nil repeats:YES];
    }
    

    [defaults setObject:@"33" forKey:@"userId"];
    LoginViewController *loginView = [[LoginViewController alloc] init];
    _loginView = loginView;
    SHHomeViewController *homeV = [[SHHomeViewController alloc] init];
    _homeV = homeV;
    BOOL autoBtn = [[defaults objectForKey:@"auto"] boolValue];
    //获得系统时间
    NSDate * curdate=[NSDate date];
    //    NSTimeInterval time =24 * 60 * 60*2;//一天的秒数
    //    NSDate * lastDay = [curdate dateByAddingTimeInterval:time];
    NSDate *olderdate = (NSDate *)[defaults objectForKey:@"startTime"] ;
    //计算两个天数差
    NSInteger interval = [self getDaysFrom:olderdate To:curdate];

    if (autoBtn)
    {
        NSString *url = [defaults objectForKey:@"serverAddress"];
        [Global initializeSystem:url deviceUUID:[defaults objectForKey:@"deviceUUID"] user:[defaults objectForKey:@"account"]];
        
        [Global initializeUserInfo:[[defaults objectForKey:@"account"] objectForKey:@"name"] userId:[[defaults objectForKey:@"account"] objectForKey:@"id"] org:[[defaults objectForKey:@"account"] objectForKey:@"org"]];
        
        //时间差超过7天需要重新输入密码
        if (interval >= 2) {
            self.nav=[[UINavigationController alloc]initWithRootViewController:loginView];
            [defaults setObject:@""forKey:@"pwd"];
            [defaults setBool:NO forKey:@"auto"];
            [defaults setBool:NO forKey:@"rem"];
            [defaults synchronize];
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已自动登录2天,为了保证账户安全,请重新输入密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [message show];
            
        }
        else
        {
            self.nav = [[UINavigationController alloc]initWithRootViewController:homeV];
        }
    }
    else
    {
        self.nav = [[UINavigationController alloc]initWithRootViewController:loginView];
    }
    
    self.window.rootViewController = self.nav;
    self.nav.navigationBar.hidden = YES;
    
    //显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    //将状态栏颜色设为白色
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    
    
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        //IOS8
        //创建UIUserNotificationSettings，并设置消息的显示类类型
        UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:nil];
        
        [application registerUserNotificationSettings:notiSettings];
        
    } else{ // ios7
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge                                       |UIRemoteNotificationTypeSound                                      |UIRemoteNotificationTypeAlert)];
    }
    //申请用户的许可
    float version=[[[UIDevice currentDevice]systemVersion]floatValue];
    if (version>8.0) {
        UIUserNotificationSettings *setting=[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication]registerUserNotificationSettings:setting];
    }
    UILocalNotification *localNotification=[launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotification!=nil) {
        [self processLocationNotification:localNotification];
    }
    // 启动基本SDK
    [[PgyManager sharedPgyManager] startManagerWithAppId:PGY_APP_ID];
    // 启动更新检查SDK
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:PGY_APP_ID];
    // 用户反馈
    [[PgyManager sharedPgyManager] setEnableFeedback:NO];
    
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

-(void)changeRootView
{
    //self.nav = [[UINavigationController alloc]initWithRootViewController:[[LoginViewController alloc] init]];
   // self.nav = [[UINavigationController alloc]initWithRootViewController:[[SHHomeViewController alloc] init]];
    //self.nav.navigationBar.hidden = YES;
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[SHHomeViewController alloc] init]];
}


//计算两个天数差
-(NSInteger)getDaysFrom:(NSDate *)serverDate To:(NSDate *)endDate
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    [gregorian setFirstWeekday:2];
    
    //去掉时分秒信息
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:serverDate];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:endDate];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    
    return dayComponents.day;
}



- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"---Token--%@", deviceToken);
    
  	 
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    
    NSLog(@"Regist fail%@",error);
    
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    NSLog(@"userInfo == %@",userInfo);
    NSString *message = [[userInfo objectForKey:@"aps"]objectForKey:@"alert"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    
    [alert show];
    
}

- (void)processLocationNotification:(UILocalNotification *)localNotification{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"lanchApp" message:@"loc" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}



//注册设置提醒后   调用的代理方法
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    if (notificationSettings.types!=UIUserNotificationTypeNone) {
        //注册本地推送  首先是生成UILocalNotification对象
        UILocalNotification *localNotification=[[UILocalNotification alloc]init];
        //        //提示触发的时间
        //        localNotification.fireDate=[NSDate dateWithTimeIntervalSinceNow:5];
        //提示推送的内容
        //        localNotification.alertBody=@"这是一个本地推送测试";
        localNotification.alertBody=nil;
        
        localNotification.repeatInterval=0;
        localNotification.repeatInterval=NSCalendarUnitMinute;
        //定制消息到来时候播放的声音文件  一定要在Bunddle内，而且声音的持续时间不能超过30s
        //        localNotification.soundName=@"CAT2.WV";
        //设置系统角标
//        localNotification.applicationIconBadgeNumber=1;
        //注册本地通知到系统中，这样系统到指定的时间会触发该通知
        [[UIApplication sharedApplication]scheduleLocalNotification:localNotification];
    }
}
//当程序运行在后台的时候或者程序没有启动，，当注册的本地通知到达时候，ios会弹框并且播放你设置的声音
//当应用程序运行在前台的时候会调用该代理方法  不会播放声音也不会弹框
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    //判断应用程序状态来决定是否弹框
    //    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    //    if (application.applicationState == UIApplicationStateActive) {
    //        UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:@"本地推送" message:notification.alertBody delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    //        [alterView show];
    //    }else if (application.applicationState == UIApplicationStateInactive)
    //    {
    //        NSLog(@"UIApplicationStateInactive");
    //    }else{
    //        //background
    //        NSLog(@"UIApplicationStateBackground");
    //    }
    //
    
}



//打开其他应用的url,收到数据调用

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSString *handleURL = [url absoluteString];
    NSString *str= [[url host]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@,%@",str,handleURL);
    SHHomeViewController *homeV =[[SHHomeViewController alloc] init];
    
    LoginViewController *loginView=[[LoginViewController alloc] init];
    NSArray *info=[str componentsSeparatedByString:@"&"];
    NSString *name =info[0];
    NSString *pwd = info[1];
    if ([name isEqualToString:[defaults objectForKey:@"name"]]&[pwd isEqualToString:[defaults objectForKey:@"pwd"]])
    {
        
        self.nav=[[UINavigationController alloc]initWithRootViewController:homeV];
    }else
    {
     self.nav=[[UINavigationController alloc]initWithRootViewController:loginView];
    
    }
    self.window.rootViewController=self.nav;
    
    return YES;
}


- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    
    
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    for (UILocalNotification *noti in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        
        
        NSString *notiID = noti.userInfo[@"kLocalNotificationID"];
        NSString *receiveNotiID = @"kLocalNotificationID";
        if ([notiID isEqualToString:receiveNotiID]) {
            [[UIApplication sharedApplication] cancelLocalNotification:noti];
            return;
        }
    }
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    NSDictionary *dic=[userDefaults objectForKey:@"touchLock"];
    
    //   if ([[dic objectForKey:@"isLock"]isEqualToString:@"YES"] &&nil!=[Global userId]) {
    if ([[dic objectForKey:@"isLock"] isEqualToString:@"YES"] ) {
        GesturesUnLock *lockView=[[GesturesUnLock alloc]init];
        lockView.isHomePage=YES;
        [self.nav pushViewController:lockView animated:NO];
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.dist.HAYD" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"WZYD" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"WZYD.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
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
//        [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:PGY_APP_ID];
    //    // 系统更新方法
    //    //[[PgyUpdateManager sharedPgyManager] checkUpdate];
    //    // 自定义更新方法
//        [[PgyUpdateManager sharedPgyManager] checkUpdateWithDelegete:self selector:@selector(updateMethod:)];
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
    
    // 错误
    //_BSMachError: (os/kern) invalid capability (20)
    //_BSMachError: (os/kern) invalid name (15)
    //通过使用多线程延迟调用解决这个问题:
    dispatch_after(0.2, dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    });
    
}


@end
