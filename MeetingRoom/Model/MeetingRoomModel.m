//
//  MeetingRoomModel.m
//  WZYD
//
//  Created by 吴定如 on 16/11/17.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "MeetingRoomModel.h"

@implementation MeetingRoomModel

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
