//
//  pressModel.m
//  XAYD
//
//  Created by songdan Ye on 16/2/17.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "pressModel.h"


@implementation pressModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self=[super init]) {
        self.title = [dict objectForKey:@"MainTitle"];
        self.content =[dict objectForKey:@"content"];
        self.date = [dict objectForKey:@"publishTime"];
        self.showurl =[dict objectForKey:@"showurl"];
        
    }
    return self;
    
    
}

+(instancetype)pressModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
    
    
}



@end
