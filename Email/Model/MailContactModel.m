//
//  MailContactModel.m
//  WZYD
//
//  Created by 吴定如 on 16/11/3.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "MailContactModel.h"
@class UsersModel;

@implementation MailContactModel

-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [self init])
    {
        self.users = [NSMutableArray array];
        self.bmName = [dic objectForKey:@"bmName"];
        NSArray *users = [dic objectForKey:@"users"];
        for (NSDictionary *dic in users)
        {
            UsersModel *model = [[UsersModel alloc] initWithDictionary:dic];
            [self.users addObject:model];
        }
    }
    return self;
}

@end

@implementation UsersModel

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