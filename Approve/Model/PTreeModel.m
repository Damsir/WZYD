//
//  PTreeModel.m
//  XAYD
//
//  Created by songdan Ye on 16/3/14.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "PTreeModel.h"

#import "PTreeItems.h"

@implementation PTreeModel
/*
{
    "success": "true",
    "result": [
               {
                   "group": "建设项目选址意见书核发(含变更、延续)",
                   "groupid": "122",
                   "items": [
                             {
                                 "name": "义乌商贸服务业集聚区商贸流通创新区（佛堂地块）配套道路工程(XZ20150014)"
                             }
                             ]
               }
               ]
}



*/
- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self=[super init]) {
        self.group = [dict objectForKey:@"group"];
        self.groupid = [dict objectForKey:@"groupid"];
        self.name = [dict objectForKey:@"name"];
        
        NSArray *tempArray = [NSArray array];
        tempArray= [dict objectForKey:@"child"];
        NSMutableArray *array =[NSMutableArray array];
        for (NSDictionary *dict in tempArray) {
            PTreeItems *itemModel = [PTreeItems itemsWithDict:dict];
            [array addObject:itemModel];
        }
        self.items = array;
        
    }
    return self;
    
    
}

+(instancetype)pTreeWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
    
}



@end
