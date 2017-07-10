//
//  MembersModel.m
//  HAYD
//
//  Created by 叶松丹 on 16/9/7.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "MembersModel.h"

@implementation MembersModel
- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self=[super init]) {
        self.userId = [dict objectForKey:@"Id"];
        self.name = [dict objectForKey:@"Name"];
        self.phoneNumber = [dict objectForKey:@"MobilePhone"];
        
//        self.status = [[dict objectForKey:@"status"] boolValue];
        
    }
    return self;
    
    
}

+ (instancetype)membersModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
    
    
    
}
@end
