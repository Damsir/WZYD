//
//  matterModel.m
//  XAYD
//
//  Created by songdan Ye on 16/3/1.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "matterModel.h"

@implementation matterModel


- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self =[super init]) {
        self.publishtime = [dict objectForKey:@"publishtime"];
        self.maintitle =[dict objectForKey:@"maintitle"];
        self.content = [dict objectForKey:@"content"];
    }
    return self;
}


+(instancetype)matterWithDict:(NSDictionary *)dict
{
    return  [[self alloc] initWithDict:dict];
}

    
@end
