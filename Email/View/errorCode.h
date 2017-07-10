//
//  errorCode.h
//  解析乱码
//
//  Created by wudingru on 15/11/26.
//  Copyright © 2015年 wudingru. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface errorCode : NSObject

+ (NSString *)analysisByErrorCode:(NSString *)string;

+ (NSString *)deleteFlagOfHTML:(NSString *)html;

@end
