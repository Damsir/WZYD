//
//  MeetingInfoModel.m
//  HAYD
//
//  Created by 吴定如 on 16/8/31.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "MeetingInfoModel.h"
#import "MJExtension.h"

@implementation MeetingInfoModel

//1.
+(NSDictionary *)mj_objectClassInArray
{
    return @{@"result":@"MeetingResultModel"};
}


@end

@implementation  MeetingResultModel

//2.
+(NSDictionary *)mj_objectClassInArray
{
    return @{@"personList":@"personList",@"topicList":@"topicList"};
}

@end

//3.
@implementation personList

@end

//4.
@implementation topicList


@end

