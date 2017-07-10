
//
//  PTreeItems.m
//  XAYD
//
//  Created by songdan Ye on 16/3/15.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "PTreeItems.h"

@implementation PTreeItems

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self=[super init]) {
        self.name = [dict objectForKey:@"name"];
        self.Id = [dict objectForKey:@"id"];
        self.projectNo = [dict objectForKey:@"projectNo"];
        self.projectCaseNo = [dict objectForKey:@"projectCaseNo"];
//        self.lever = 1;
        
    }
    return self;
    
    
}

+(instancetype)itemsWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
    
    
}

@end
