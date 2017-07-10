//
//  SHMyMeetingModel.m
//  distmeeting
//
//  Created by songdan Ye on 15/11/23.
//  Copyright (c) 2015年 dist. All rights reserved.
//

#import "SHMyMeetingModel.h"
#import "SHMeetingModel.h"

@implementation SHMyMeetingModel


- (instancetype) initWithDict:(NSDictionary *)dict
{

    if (self=[super init]) {
        self.mymeetingId = [dict objectForKey:@"id"];
        self.userid = [dict objectForKey:@"userid"];
        self.userstate = [dict objectForKey:@"userstate"];
        self.meeting =[SHMeetingModel meetingModelWithDict:[dict objectForKey:@"meeting"]];
        
    }
    
    return self;

}

+ (instancetype) myMeetingModelWithDict:(NSDictionary *)dict
{

    return  [[self alloc] initWithDict:dict];

}


@end
