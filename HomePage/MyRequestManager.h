//
//  MyRequestManager.h
//  
//
//  Created by 吴定如 on 15/10/28.
//  Copyright © 2015年 Dam. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ successReqBlock)(NSData *data);
typedef void(^ failReqBlock)(NSError *error);
//typedef 定义的block 和属性直接定义的block区别在于:
//直接定义属性的话,别的地方想要使用必须得重新定义,没法用.....
//#import "MyRequest.h"
@class MyRequest;

@interface MyRequestManager : NSObject

//1.异步GET请求数据
+(void)requestWithUrl:(NSString *)urlStr andSuccess:(successReqBlock)successBlock andFailBlock:(failReqBlock)failBlock;
//2.异步POST请求数据
+(void)requestWithUrl:(NSString *)urlStr andBodyDic:(NSDictionary *)bodyDic andBodyStr:(NSString *)bodyStr andSuccess:(successReqBlock)successBlock andFailBlock:(failReqBlock)failBlock;


@end

@interface MyRequest : NSObject

//定义外面可以访问的字符串URL
@property(nonatomic,strong) NSString *url;

//POST方式的bodyDic和bodyStr(二者二选其一即可)
@property(nonatomic,strong) NSDictionary *bodyDic;
@property(nonatomic,strong) NSString *bodyStr;

//请求成功的回调Block
@property(nonatomic,copy) successReqBlock successReqBlock;
//请求失败的回调Block
@property(nonatomic,copy) failReqBlock failReqBlock;

//1.异步GET请求数据
-(void)startRequestData;
//2.异步POST请求数据
-(void)startRequestDataWithPOST;

@end
