//
//  Global.h
//  iBusiness
//
//  Created by zhangliang on 15/4/29.
//  Copyright (c) 2015年 sh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@interface Global : NSObject

+(NSString *)serverAddress;
+(NSDictionary *)userInfo;
+(NSString *)userId;
+(NSString *)userName;
+(void)initializeSystem:(NSString *)serverAddress deviceUUID:(NSString *)deviceUUID user:(NSDictionary *)userInfo;
+(NSString *)token;
+(void)token:(NSString *)val;
+(void)setUserId:(NSString *)userId;
+(NSString *)myuserId;
+(void)setDeviceUUID:(NSString *)deviceUUID;
+(NSString *)deviceUUID;
+(void)setUrl:(NSString *)Url;
+(NSString *)Url;
//初始化系统数据
+(void)initSystem;

//初始化用户信息
+(void)initializeUserInfo:(NSString *)name userId:(NSString *)userId org:(NSString *)org;

//退出登录
+(void)logout;

//当前用户
+(UserInfo *)currentUser;

//服务地址
+(NSString *) serviceUrl;

//网络状态
+(BOOL)isOnline;
+(void)isOnline:(BOOL)online;

//提交数据到服务器（图片也可以）
+(void)addDataToSyn:(NSString *)name data:(NSMutableDictionary *)data;

+(NSString *)newUuid;

+(NSString *)serverAddresss;
+(void)lock:(NSString *)code;
+(void)unlock;

+(BOOL)locked;
+(void)wait:(NSString *)msg;

//获得一张图配置信息
+(NSString *)mapConfigAddress;

//+(void)setGolbal:(UIViewController *)sysVC;
//
//+(UIViewController *)getGlobaltSysVC;

@end
