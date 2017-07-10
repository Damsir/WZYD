//
//  AttachmentModel.m
//  WZYD
//
//  Created by 吴定如 on 16/11/8.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "AttachmentModel.h"

@implementation AttachmentModel

-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [self init])
    {
        for (NSString *key in dic)
        {
            [self setValue:dic[key] forKey:key];
        }
    }
    return self;
}

@end
