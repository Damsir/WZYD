//
//  errorCode.m
//  解析乱码
//
//  Created by wudingru on 15/11/26.
//  Copyright © 2015年 wudingru. All rights reserved.
//

#import "errorCode.h"

@implementation errorCode

+ (NSString *)analysisByErrorCode:(NSString *)string
{
    
    NSMutableString *mutStr = [NSMutableString stringWithString:string];
    
    for (int i = 0 ; i < string.length; i++) {
        
        NSRange range = [mutStr rangeOfString:@">" options:NSLiteralSearch range:NSMakeRange(0, mutStr.length)];
        
        NSRange range1 = [mutStr rangeOfString:@"<" options:NSLiteralSearch range:NSMakeRange(0, mutStr.length)];
        
        if(range1.length == 0) break;
        
        if (range.location > range1.location)
        {
            [mutStr deleteCharactersInRange:NSMakeRange(range1.location, range.location-range1.location+1)];
        }
        else
        {
            [mutStr deleteCharactersInRange:NSMakeRange(range.location, 1)];
        }
        
    }
    
    for (int i = 0; i < string.length; i++) {
        
        NSRange range2 = [mutStr rangeOfString:@"&" options:NSLiteralSearch range:NSMakeRange(0, mutStr.length)];
        
        if(range2.length == 0)
            break ;
        
        [mutStr deleteCharactersInRange:NSMakeRange(range2.location, 5)];
    }
    
    [mutStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [mutStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [mutStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    return mutStr ;
    
}

+ (NSString *)deleteFlagOfHTML:(NSString *)html{
    
    NSScanner *theScanner;
    NSString *text = nil;
    
    // 将原来的 \n(换行符) 替换为 @""
    html = [html stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    theScanner = [NSScanner scannerWithString:html];
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        
        // </P> 为换行
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"</P>"] withString:@"\n"];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"回复"] withString:@""];
        
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
        
    } // while //
    // NSLog(@"-----===%@",html);
    return html;
}











@end
