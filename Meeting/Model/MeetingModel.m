//
//  MeetingModel.m
//  HAYD
//
//  Created by 吴定如 on 16/8/29.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "MeetingModel.h"

@implementation MeetingModel

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

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
