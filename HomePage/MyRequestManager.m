//
//  MyRequestManager.m
//  
//
//  Created by 吴定如 on 15/10/28.
//  Copyright © 2015年 Dam. All rights reserved.
//

#import "MyRequestManager.h"

@implementation MyRequestManager

//1.异步GET请求数据
+(void)requestWithUrl:(NSString *)urlStr andSuccess:(successReqBlock)successBlock andFailBlock:(failReqBlock)failBlock
{
    MyRequest *myRequest = [[MyRequest alloc] init];
    myRequest.url = urlStr;
    myRequest.successReqBlock = successBlock;
    myRequest.failReqBlock = failBlock;
    //开始请求网络数据GET
    [myRequest startRequestData];
}
//2.异步POST请求数据
+(void)requestWithUrl:(NSString *)urlStr andBodyDic:(NSDictionary *)bodyDic andBodyStr:(NSString *)bodyStr andSuccess:(successReqBlock)successBlock andFailBlock:(failReqBlock)failBlock
{
    MyRequest *myRequest = [[MyRequest alloc] init];
    myRequest.url = urlStr;
    myRequest.bodyDic = bodyDic;
    myRequest.bodyStr = bodyStr;
    myRequest.successReqBlock = successBlock;
    myRequest.failReqBlock = failBlock;
    //开始请求网络数据POST
    [myRequest startRequestDataWithPOST];
}

@end

@interface MyRequest ()<NSURLConnectionDataDelegate,NSURLConnectionDelegate>
//在.m文件里面写interface和在外面写interface实际上没有太大的区别,
//唯一的区别:(.h文件)定义的外边可以访问到,已经看到,(.m文件)一般不用暴露给外边看到
{
    ////保存请求到的数据
    NSMutableData *netData;
    //请求类
    NSURLConnection *urlConnection;
}

@end

@implementation MyRequest

//1.异步GET请求数据
-(void)startRequestData
{
    //1.处理链接:对字符串进行UFT8编码,为了防止链接中出现汉字,最终导致请求失败
    self.url = [self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //2.用外部传入的url 作为网络请求的url链接
    NSURL *requestUrl = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];
    //3.创建网络请求链接
    urlConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    netData = [NSMutableData data];
    //开始网络请求
    [urlConnection start];
}
//2.异步POST请求数据
-(void)startRequestDataWithPOST
{
    //1.处理链接:对字符串进行UFT8编码,为了防止链接中出现汉字,最终导致请求失败
    self.url = [self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //2.用外部传入的url 作为网络请求的url链接
    NSURL *requestUrl = [NSURL URLWithString:self.url];
    //POST和GET方法的区分点
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl];
    [request setHTTPMethod:@"POST"];
    if (!_bodyStr)
    {
        NSData *data = [NSJSONSerialization dataWithJSONObject:_bodyDic options:NSJSONWritingPrettyPrinted error:nil];
        [request setHTTPBody:data];
    }
    else if(!_bodyDic)
    {
        NSData *data = [NSJSONSerialization dataWithJSONObject:_bodyStr options:NSJSONWritingPrettyPrinted error:nil];
        [request setHTTPBody:data];
    }
    
    //3.创建网络请求链接
    urlConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    netData = [NSMutableData data];
    //开始网络请求
    [urlConnection start];
}

#pragma mark--NSURLConnectionDataDelegate

//第一次得到服务器的回应
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [netData setLength:0];
}
//每一次请求到的数据流
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [netData appendData:data];
}
//网络请求结束
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.successReqBlock)
    {
        self.successReqBlock(netData);
    }
    
}
//请求失败
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [netData setLength:0];
    //如果外面没有赋值,直接调用就会造成程序崩溃
    if (self.failReqBlock)
    {
        self.failReqBlock(error);
    }
}

@end
