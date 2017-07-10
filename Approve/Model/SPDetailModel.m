//
//  SPDetailModel.m
//  XAYD
//
//  Created by songdan Ye on 16/3/7.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "SPDetailModel.h"

@implementation SPDetailModel

/*
 {
 
 
 "projectName": "梅园",
 "projectId": "12680",
 "wfWorkItemId": "ab5b5045e6094c1cbf93ddfe0406631b",
 "address": "天天",
 "company": "天天",
 "xmbh": "SP201500152",
 "slbh": "XZ20150014",
 "activityName": "科长审核",
 "currentUser": " banyq",
 "contactName": "天天",
 "contactPhone": "111111111",
 "hjjs": "在办",
 "time": "2015/12/1 15:05:03",
 "business": "建设项目选址意见书核发(含变更、延续)(省扩权)",
 "day": "3"
 
 }
 */
- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [self init])
    {
        for (NSString *key in dict)
        {
            [self setValue:dict[key] forKey:key];
        }
    }
    return self;
}

+(instancetype)spDetailModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
    
}

#pragma mark - 模型转字典
- (NSDictionary *)dictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.projectName forKey:@"projectName"];
    [dict setObject:self.ProjectId forKey:@"ProjectId"];
    [dict setObject:self.wfWorkItemId forKey:@"wfWorkItemId"];
    [dict setObject:self.address forKey:@"address"];
    [dict setObject:self.company forKey:@"company"];
    [dict setObject:self.xmbh forKey:@"xmbh"];
    [dict setObject:self.slbh forKey:@"slbh"];
    [dict setObject:self.activityName forKey:@"activityName"];
    [dict setObject:self.currentUser forKey:@"currentUser"];
    [dict setObject:self.hjjs forKey:@"hjjs"];
    [dict setObject:self.time forKey:@"time"];
    [dict setObject:self.business forKey:@"business"];
    [dict setObject:self.FLOWLEFTTIME forKey:@"FLOWLEFTTIME"];
    [dict setObject:self.name forKey:@"name"];
    [dict setObject:self.count forKey:@"count"];

    return dict;
}

+ (NSDictionary *)dictionaryWithSPDetailModel:(SPDetailModel *)model
{
    
    return [model dictionary];
    
}


- (NSDictionary *)dictionaryGW
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.projectName forKey:@"projectName"];
    [dict setObject:self.ProjectId forKey:@"projectId"];
    [dict setObject:self.wfWorkItemId forKey:@"wfWorkItemId"];
    [dict setObject:self.xmbh forKey:@"xmbh"];
    [dict setObject:self.slbh forKey:@"slbh"];
    [dict setObject:self.activityName forKey:@"activityName"];
    [dict setObject:self.currentUser forKey:@"currentUser"];
    [dict setObject:self.hjjs forKey:@"hjjs"];
    [dict setObject:self.time forKey:@"time"];
    [dict setObject:self.business forKey:@"business"];
    return dict;


}
+ (NSDictionary *)dictionaryWithGWModel:(SPDetailModel *)model
{

return [model dictionaryGW];
}



@end
