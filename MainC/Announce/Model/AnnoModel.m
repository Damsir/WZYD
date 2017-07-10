//
//  AnnoModel.m
//  XAYD
//
//  Created by songdan Ye on 16/2/29.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "AnnoModel.h"

@implementation AnnoModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self=[super init]) {
        self.mainTitle = [dict objectForKey:@"MainTitle"];
        //        self.image =[dict objectForKey:@"image"];
        self.publishTime = [dict objectForKey:@"publishTime"];
        self.showurl =[dict objectForKey:@"showurl"];
        self.content = [dict objectForKey:@"content"];
        //        self.name =[dict objectForKey:@"name"];
        self.comeFrom = [dict objectForKey:@"creater"];
    }
    return self;
    
    
}

+(instancetype)annoModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
    
    
}



@end
