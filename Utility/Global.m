//
//  Global.m
//  iBusiness
//
//  Created by zhangliang on 15/4/29.
//  Copyright (c) 2015年 sh. All rights reserved.
//

#import "Global.h"

@implementation Global

static NSString *_serverAddress;
static NSDictionary *_userInfo;
static NSString *_token;
static NSString *_myuserid;
static NSString *_deviceUUID;
static NSString *_Url;

+(void)initializeSystem:(NSString *)serverAddress deviceUUID:(NSString *)deviceUUID user:(NSDictionary *)userInfo{
    _serverAddress = serverAddress;
    _Url = serverAddress;
    _deviceUUID = deviceUUID;
    [defaults setObject:_deviceUUID forKey:@"deviceUUID"];
    _userInfo = userInfo;
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults setObject:userInfo forKey:@""];
    [defaults setObject:userInfo forKey:@"account"];
    [Global setUserId:[_userInfo objectForKey:@"id"]];
}

+(NSString *)serverAddress{
    return _serverAddress;
}

+(NSDictionary *)userInfo{
    return _userInfo;
}

+(NSString *)userId{
    if (nil==_userInfo) {
        return nil;
    }
    return [_userInfo objectForKey:@"id"];
}


+(NSString *)userName{
    return [_userInfo objectForKey:@"name"];
}

+(void)token:(NSString *)val{
    _token = val;
}

+(NSString *)token{
    return _token;
}

+(void)setUserId:(NSString *)userId{
    _myuserid=userId;
}

+(NSString *)myuserId{
    return _myuserid;
}
#pragma mark -- 设备uuid
+(void)setDeviceUUID:(NSString *)deviceUUID{
//    [defaults setObject:deviceId forKey:@"deviceId"];
//    [defaults synchronize];
//    _deviceId = [defaults objectForKey:@"deviceId"];
    _deviceUUID = deviceUUID;
}

+(NSString *)deviceUUID{
    return _deviceUUID;
}
#pragma mark -- 请求服务器url
+(void)setUrl:(NSString *)Url{
//    [defaults setObject:Url forKey:@"Url"];
//    [defaults synchronize];
//    _Url = [defaults objectForKey:@"Url"];
    _Url = Url;
}
+(NSString *)Url{
    return _Url;
}




////////////////////////////
static UserInfo *_currentUser;
static NSString *_userlistSavePath;
static NSString *_lockInfoSavePath;
static NSMutableDictionary *_userlist;
//static UIViewController *_sysVC;
static BOOL _isOnline = NO;
static BOOL _locked = NO;
//static SynPool *_pool;
static bool _sysInitialized;

//+(void)addDataToSyn:(NSString *)name data:(NSMutableDictionary *)data{
//    [_pool add:name data:data];
//}

+(NSString *)serviceUrl{
    return [NSString stringWithFormat:@"%@/ServiceProvider.ashx",[Global serverAddress]];
}

//+(NSString *)serverAddresss{
//    //return @"http://58.246.138.178:8040/nbServices";//公司地址
//    //return @"http://10.19.67.79/Servicestest";//宁波政务外网
//    return @"http://60.12.211.13:10091/servicestest";//宁波互联网
//}
//+(NSString *)mapConfigAddress{
//    //return @"http://58.246.138.178:8040/dmpMap";//公司运维
//    //return @"http://192.168.23.1/dmpMap";
//    return nil;
//}

+(void)initializeUserInfo:(NSString *)name userId:(NSString *)userId org:(NSString *)org{
    //UserInfo
    _currentUser = [UserInfo userWithNameAndId:name userId:userId];
    _currentUser.org = org;
    //保存到字典中
    [_userlist setObject:_currentUser forKey:name];
    [_userlist writeToFile:_userlistSavePath atomically:YES];
}

+(void)logout{
    _currentUser = nil;
}

+(UserInfo *)currentUser{
    return _currentUser;
}

////+(BOOL)isOnline{
////    BOOL isReachable = NO;
////    Reachability *reachability = [Reachability reachabilityWithHostName:[Global serviceUrl]];
////    switch ([reachability currentReachabilityStatus]) {
////        case NotReachable:{
////            isReachable = NO;
////        }
////            break;
////        case ReachableViaWWAN:{
////            isReachable = YES;
////        }
////            break;
////        case ReachableViaWiFi:{
////            isReachable = YES;
////        }
////            break;
////        default:
////            isReachable = NO;
////            break;
////    }
////    return isReachable;
////}
//
//+(void)isOnline:(BOOL)online{
//    _isOnline = online;
//}
//
//+(void)initSystem{
//    
//    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
//    _lockInfoSavePath = [[paths objectAtIndex:0] stringByAppendingString:@"/lock.txt"];
//    
//    NSString *lockInfo = [NSString stringWithContentsOfFile:_lockInfoSavePath encoding:NSUTF8StringEncoding error:nil];
//    
//    if (!_locked && nil!=lockInfo && ![lockInfo isEqualToString:@""]) {
//        [self lock:lockInfo];
//    }else if(!_sysInitialized){
//        _userlistSavePath = [[paths objectAtIndex:0] stringByAppendingString:@"/users.plist"];
//        _userlist = [NSMutableDictionary dictionaryWithContentsOfFile:_userlistSavePath];
//        if (nil==_userlist) {
//            _userlist = [NSMutableDictionary dictionaryWithCapacity:3];
//        }
//        _pool = [[SynPool alloc] init];
//        [_pool start];
//        _sysInitialized = YES;
//    }
//}


+(NSString *)newUuid{
    // ios6.0 之前获取设备的 UUID
    CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *cfuuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
    return cfuuidString;
}

//static LockViewController *_lockView;
//static UIViewController *_workView;

//+(void)lock:(NSString *)code{
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    if (nil==_lockView) {
//        if (iPhone) {
//            _lockView=[[LockViewController alloc]initWithNibName:@"PhoneLockViewControler" bundle:nil];
//        }
//        else
//            _lockView = [[LockViewController alloc] initWithNibName:@"LockViewController" bundle:nil];
//    }
//    if (![window.rootViewController isKindOfClass:[LockViewController class]]) {
//        _workView = window.rootViewController;
//    }
//    
//    window.rootViewController=_lockView;
//    //    window.rootViewController = _lockView;
//    [code writeToFile:_lockInfoSavePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
//    _locked = YES;
//    _lockView.code = code;
//}
//
//+(void)unlock{
//    if (nil!=_workView) {
//        UIWindow *window = [UIApplication sharedApplication].keyWindow;
//        window.rootViewController = _workView;
//    }
//    [@"" writeToFile:_lockInfoSavePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
//    _locked = NO;
//    if (!_sysInitialized) {
//        [Global initSystem];
//    }
//}

+(BOOL)locked{
    return _locked;
}


//static WaitingView *wv;
static bool wvInWindow;
//+(void)wait:(NSString *)msg{
//    if (nil==msg && nil!=wv) {
//        [wv removeFromSuperview];
//        wvInWindow = NO;
//    }else{
//        UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
//        while (controller.presentedViewController != nil) {
//            controller = controller.presentedViewController;
//        }
//        if (nil==wv) {
//            wv = [[WaitingView alloc] initWithFrame:CGRectMake(0, 0, 1024,768)];
//        }
//        wv.msg = msg;
//        if (!wvInWindow) {
//            [controller.view addSubview:wv];
//        }
//        wvInWindow = YES;
//    }
//}
//
//+(void)setGolbal:(UIViewController *)sysVC{
//    _sysVC=sysVC;
//}
//
//+(UIViewController *)getGlobaltSysVC{
//    return _sysVC;
//}






@end
