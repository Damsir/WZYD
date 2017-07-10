//
//  ContactModel.m
//  HAYD
//
//  Created by 叶松丹 on 16/9/7.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "ContactModel.h"
#import "MembersModel.h"
@implementation ContactModel

- (instancetype) initWithDict:(NSDictionary *)dict
{
//    if (self=[super init]) {
//        self.organId = [dict objectForKey:@"Id"];
//        self.organName = [dict objectForKey:@"Name"];
//        NSArray *tempArray = [NSArray array];
//        tempArray= [dict objectForKey:@"children"];
//        NSMutableArray *array =[NSMutableArray array];
//        for (NSDictionary *dict in tempArray) {
//            MembersModel *mem = [MembersModel membersModelWithDict:dict];
//            [array addObject:mem];
//        }
//        self.userList = array;
//        
//    }
//    return self;
    
    if (self = [self init])
    {
        for (NSString *key in dict)
        {
            [self setValue:dict[key] forKey:key];
        }
    }
    return self;
    
}


+(instancetype)contactModelWithDict:(NSDictionary *)dict
{
    
    return  [[self alloc ]initWithDict:dict];
    
}

@end
