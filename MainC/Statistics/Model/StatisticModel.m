//
//  StatisticModel.m
//  HAYD
//
//  Created by 叶松丹 on 16/8/30.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "StatisticModel.h"

@implementation StatisticModel
- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self=[super init]) {
        self.month = [dict objectForKey:@"MONTH"];
        self.sjCount =[dict objectForKey:@"SJCOUNT"];
        self.fjCount = [dict objectForKey:@"FJCOUNT"];
        
    }
    return self;

}

+ (instancetype)StaticModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];

}
@end
