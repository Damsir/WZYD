//
//  MeetingMaterialModel.m
//  HAYD
//
//  Created by 吴定如 on 16/9/1.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "MeetingMaterialModel.h"
#import "MJExtension.h"

//1.
@implementation MeetingMaterialModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"result":@"MaterialResultModel"};
}

@end
//2.
@implementation MaterialResultModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"MaterialList":@"MaterialList"};
}

@end

//3.
@implementation MaterialList
- (NSDictionary *)dictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
   
    [dict setObject:self.ID forKey:@"ID"];
    [dict setObject:self.MaterialName forKey:@"MaterialName"];
    [dict setObject:self.MaterialType forKey:@"MaterialType"];
    [dict setObject:self.MaterialDetials forKey:@"MaterialDetials"];
    
    
    return dict;
}

+ (NSDictionary *)dictionaryWithMaterialListModel:(MaterialList *)model
{
    return [model dictionary];
}

@end