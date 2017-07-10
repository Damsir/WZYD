//
//  SHMembers.m
//  distmeeting
//
//  Created by songdan Ye on 15/10/26.
//  Copyright (c) 2015年 dist. All rights reserved.
//

#import "SHMembers.h"

@implementation SHMembers

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self=[super init]) {
        self.userId = [dict objectForKey:@"id"];
        self.name = [dict objectForKey:@"name"];
        self.phoneNumber = [dict objectForKey:@"phoneNumber"];
        
        self.status = [[dict objectForKey:@"status"] boolValue];
        
    }
    return self;


}

+ (instancetype)membersModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];



}

@end
