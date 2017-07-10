//
//  DamUpdateManager.m
//  WZYD
//
//  Created by 吴定如 on 16/11/28.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "DamUpdateManager.h"
#import "AFNetworking.h"

@implementation DamUpdateManager

+ (void)compareVersionWithPlist:(Picker_CheckUpdatedBlock)block{
    
    NSError *error;
    NSString *newVersion = [NSString stringWithContentsOfURL:[NSURL URLWithString:VersionUrl_Dist] encoding:NSUTF8StringEncoding error:&error];
    NSString *currentAppVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    if(![newVersion isEqualToString:@""] && newVersion != nil){
        if ([newVersion isEqualToString:currentAppVersion]) {
            //当前是最新版本
            block(YES,VersionUrl_Dist);
        }else{
            //提示更新
            block(NO,VersionUrl_Dist);
        }
    }else{
        newVersion = [NSString stringWithContentsOfURL:[NSURL URLWithString:VersionUrl_Mayun] encoding:NSUTF8StringEncoding error:&error];
        if ([newVersion isEqualToString:currentAppVersion]||[newVersion isEqualToString:@""]||newVersion == nil) {
            //当前是最新版本
            block(YES,VersionUrl_Mayun);
        }else{
            //提示更新
            block(NO,VersionUrl_Mayun);
        }
    }
    
    
    /*
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/plain", nil];
    
    [manager GET:Version_Url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    
        NSString *newVersion = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //        NSRange range = [str rangeOfString:@">1"];
        //NSString *str1 = [newVersion substringWithRange:NSMakeRange(988, 5)];
        if([newVersion isEqualToString:currentAppVersion]){
            block(YES);//当前是最新版本
        }else{
            //提示更新
            block(NO);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
         NSLog(@"%@",error.description);
    }];
    */
}

@end
