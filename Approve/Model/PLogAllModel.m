//
//  PLogAllModel.m
//  XAYD
//
//  Created by songdan Ye on 16/3/29.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "PLogAllModel.h"

@implementation PLogAllModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self=[super init]) {
        self.log = [dict objectForKey:@"log"];
        self.date = [dict objectForKey:@"date"];
        self.opened = [[dict objectForKey:@"open"]boolValue];
                   }
    return self;
    
    
}

+(instancetype)pLogAllWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
    
}




@end
