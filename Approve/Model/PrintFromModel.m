//
//  PrintFromModel.m
//  XAYD
//
//  Created by songdan Ye on 16/3/15.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "PrintFromModel.h"
/*
{
    "identity": "550",
    "project": "12680",
    "busiFormId": "250",
    "name": "义乌市《建设项目选址意见书》申请表"
},
 */
@implementation PrintFromModel
- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self=[super init]) {
        self.identity = [dict objectForKey:@"identity"];
        self.project = [dict objectForKey:@"project"];
        self.busiFormId = [dict objectForKey:@"busiFormId"];
        self.name = [dict objectForKey:@"name"];
        
        
    }
    return self;
    
    
}

+(instancetype)printFromWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
    
}


- (NSDictionary *)dictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setObject:self.litpic forKey:@"litpic"];
    [dict setObject:self.identity forKey:@"identity"];
    [dict setObject:self.project forKey:@"project"];
    [dict setObject:self.busiFormId forKey:@"busiFormId"];
    [dict setObject:self.name forKey:@"name"];
    
    
    return dict;
}

+ (NSDictionary *)dictionaryWithprintModel:(PrintFromModel *)model
{
    return [model dictionary];
}


@end
