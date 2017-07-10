//
//  ProjectsModel.m
//  WZYD
//
//  Created by 吴定如 on 16/10/25.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "ProjectsModel.h"

@implementation ProjectsModel

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
