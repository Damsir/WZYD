//
//  BaseInfoModel.m
//  WZYD
//
//  Created by 吴定如 on 16/10/21.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "BaseInfoModel.h"

@implementation BaseInfoModel

-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        for (NSString *key in dic) {
            //NSLog(@"key:::%@",key);
            [self setValue:dic[key] forKey:key];
        }
    }
    return self;

}

@end
