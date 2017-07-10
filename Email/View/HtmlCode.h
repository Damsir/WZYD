//
//  HtmlCode.h
//  WZYD
//
//  Created by 吴定如 on 16/11/29.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HtmlCode : NSObject

+ (NSString *)analysisByErrorCode:(NSString *)string;  /**< 去除乱码 */

+ (NSString *)deleteFlagOfHTML:(NSString *)html; /**< 去除Html标签 */

@end
