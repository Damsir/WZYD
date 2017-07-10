//
//  CYQYAllModel.m
//  XAYD
//
//  Created by songdan Ye on 16/5/24.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "CYQYAllModel.h"
#import "CQhistoryModel.h"
@implementation CYQYAllModel
- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self=[super init]) {
        self.historydiscrption = [dict objectForKey:@"historydiscrption"];
        self.remark = [dict objectForKey:@"remark"];
        
        NSMutableArray *mulA=[NSMutableArray array];
        for (NSDictionary *detailDict in [dict objectForKey:@"files"]) {
           CQhistoryModel  *cyqyModel=[CQhistoryModel CQHisModelWithDict:detailDict];
            [mulA addObject:cyqyModel];
        }
        self.files = [mulA copy];
        
    }
    return self;
    
    
}

+(instancetype)AllCQWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
    
}

@end
