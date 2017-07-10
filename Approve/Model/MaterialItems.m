//
//  MaterialItems.m
//  XAYD
//
//  Created by songdan Ye on 16/4/21.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "MaterialItems.h"

@implementation MaterialItems
- (instancetype)initDetailWithDict:(NSDictionary *)dict
{
//    if (self=[super init]) {
//        self.name = [dict objectForKey:@"name"];
//        self.ext = [dict objectForKey:@"ext"];
//        self.identity = [dict objectForKey:@"identity"];
//    }
//    return self;
    self = [super init];
    if (self) {
        for (NSString *key in dict) {
            //NSLog(@"key:::%@",key);
            [self setValue:dict[key] forKey:key];
        }
    }
    return self;
}

+ (instancetype)materialDetailWithDict:(NSDictionary *)dict
{
    return [[self alloc] initDetailWithDict:dict];
    
}


@end
