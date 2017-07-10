//
//  ContactsModel.m
//  WZYD
//
//  Created by 吴定如 on 16/12/22.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "ContactsModel.h"

@implementation ContactsModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [self init])
    {
        for (NSString *key in dic)
        {
            [self setValue:dic[key] forKey:key];
            self.users = [NSMutableArray array];
            NSArray *users = [dic objectForKey:@"users"];
            for (NSDictionary *dic in users) {
                ChildrenModel *model = [[ChildrenModel alloc] initWithDictionary:dic];
                [self.users addObject:model];
            }
        }
    }
    return self;
}

@end

@implementation ChildrenModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
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
