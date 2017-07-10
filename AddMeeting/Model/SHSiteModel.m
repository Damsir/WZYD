//
//  SHSiteModel.m
//  distmeeting
//
//  Created by songdan Ye on 15/10/29.
//  Copyright (c) 2015年 dist. All rights reserved.
//

#import "SHSiteModel.h"

@implementation SHSiteModel

- (instancetype)initWithDict:(NSDictionary *)dict
{

    if (self=[super init]) {
        self.siteId = [dict objectForKey:@"id"];
        self.name = [dict objectForKey:@"name"];
        
    }
    return self;


}

+ (instancetype)siteModelWithDict:(NSDictionary *)dict
{

    return [[self alloc] initWithDict:dict];
}


@end
