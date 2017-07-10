//
//  CQhistoryModel.m
//  XAYD
//
//  Created by songdan Ye on 16/5/24.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "CQhistoryModel.h"

@implementation CQhistoryModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    
    if (self=[super init]) {
        self.cqId = [dict objectForKey:@"id"];
        self.historydiscrption = [dict objectForKey:@"historydiscrption"];
        
        
    }
    return self;
    
    
}

+ (instancetype)CQHisModelWithDict:(NSDictionary *)dict
{
    
    return [[self alloc] initWithDict:dict];
}


@end
