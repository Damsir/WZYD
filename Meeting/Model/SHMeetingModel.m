//
//  SHMeetingModel.m
//  distmeeting
//
//  Created by songdan Ye on 15/10/19.
//  Copyright (c) 2015年 dist. All rights reserved.
//

#import "SHMeetingModel.h"

@implementation SHMeetingModel


//-(void)setValue:(id)value forUndefinedKey:(NSString *)key
//{
//

//}

//@property (nonatomic,copy) NSString *endtime;
//@property (nonatomic,copy) NSString *meetingId;
//@property (nonatomic,copy) NSString *meetingintroduce;
//@property (nonatomic,copy) NSString *meetingplace;
//@property (nonatomic,copy) NSString *meetingstate;
//@property (nonatomic,copy) NSString *meetingtitle;
//@property (nonatomic,copy) NSString *presenterid;
//@property (nonatomic,copy) NSString *starttime;
- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self=[super init]) {
        self.endtime = [dict objectForKey:@"endtime"];
        self.meetingId = [dict objectForKey:@"id"];
        self.meetingintroduce = [dict objectForKey:@"meetingintroduce"];
        self.meetingplace = [dict objectForKey:@"meetingplace"];
        self.meetingstate = [dict objectForKey:@"meetingstate"];
        self.meetingtitle = [dict objectForKey:@"meetingtitle"];
        self.presenterid = [dict objectForKey:@"presenterid"];
    self.starttime = [dict objectForKey:@"starttime"];
        self.userName =[dict objectForKey:@"userName"];
    
    }
    return self;
    
    
}

+(instancetype)meetingModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
    
    
}


//+ (id)copyWithZone:(NSZone *)zone {
//    return (id)self;
//}
- (id)copy {
    return [(id)self copyWithZone:NULL];
}

@end
