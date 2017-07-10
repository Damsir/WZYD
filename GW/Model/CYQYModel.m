//
//  CYQYModel.m
//  XAYD
//
//  Created by songdan Ye on 16/5/24.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "CYQYModel.h"

@implementation CYQYModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    
    if (self=[super init]) {
        self.cyId = [dict objectForKey:@"id"];
        self.name = [dict objectForKey:@"name"];
        self.bh = [dict objectForKey:@"bh"];
        self.type = [dict objectForKey:@"type"];
        self.time = [dict objectForKey:@"time"];
        self.itemid = [dict objectForKey:@"itemid"];
        self.owner = [dict objectForKey:@"owner"];

        
    }
    return self;
    
    
}

+ (instancetype)CYQYModelWithDict:(NSDictionary *)dict
{
    
    return [[self alloc] initWithDict:dict];
}
- (NSDictionary *)dictionaryGWCQ
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.name forKey:@"name"];
    [dict setObject:self.cyId forKey:@"cyId"];
    [dict setObject:self.itemid forKey:@"itemid"];
    [dict setObject:self.bh forKey:@"bh"];
    [dict setObject:self.type forKey:@"type"];
    [dict setObject:self.owner forKey:@"owner"];
    [dict setObject:self.time forKey:@"time"];
    return dict;
    
    
}
+ (NSDictionary *)dictionaryGWCQ:(CYQYModel *)model
{
    
    return [model dictionaryGWCQ];
}




@end
