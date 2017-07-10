//
//  SHMembersModel.m
//  distmeeting
//
//  Created by songdan Ye on 15/10/29.
//  Copyright (c) 2015年 dist. All rights reserved.
//

#import "SHMembersModel.h"
#import "SHMembers.h"
@interface SHMembersModel ()

@end
@implementation SHMembersModel

- (instancetype) initWithDict:(NSDictionary *)dict
{
     if (self=[super init]) {
        self.organId = [dict objectForKey:@"OrganId"];
         self.organName = [dict objectForKey:@"OrganName"];
                  NSArray *tempArray = [NSArray array];
        tempArray= [dict objectForKey:@"UserList"];
         NSMutableArray *array =[NSMutableArray array];
         for (NSDictionary *dict in tempArray) {
             SHMembers *mem = [SHMembers membersModelWithDict:dict];
             [array addObject:mem];
         }
         self.userList = array;
         

        
    }
    
    return self;
}

+(instancetype)memebersModelWithDict:(NSDictionary *)dict
{

    return  [[self alloc ]initWithDict:dict];

}




@end
