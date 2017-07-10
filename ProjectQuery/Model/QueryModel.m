//
//  QueryModel.m
//  WZYD
//
//  Created by 吴定如 on 16/10/24.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "QueryModel.h"


@implementation QueryModel

-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init])
    {
        self.groupName = [dic objectForKey:@"groupName"];
        self.child = [NSMutableArray array];
        NSArray *child = [dic objectForKey:@"child"];
        for (NSDictionary *dic in child)
        {
            ChildModel *model = [[ChildModel alloc] initWithDictionary:dic];
            [self.child addObject:model];
        }
    }
    
    return self;
}

@end

@implementation ChildModel

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
