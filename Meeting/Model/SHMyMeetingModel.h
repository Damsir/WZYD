//
//  SHMyMeetingModel.h
//  distmeeting
//
//  Created by songdan Ye on 15/11/23.
//  Copyright (c) 2015年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SHMeetingModel;
@interface SHMyMeetingModel : NSObject
/*
 
 {
 "id": "4028826f505a3b0f01506553ca9e0d1a",
 "meeting": {
 "endtime": "2015-09-25 19:00:00",
 "id": "4028826f505a3b0f01506553b0c80c3a",
 "meetingintroduce": "智慧流程产品线花好月圆心悦会",
 "meetingplace": "一楼会议室",
 "meetingplaceid": "1",
 "meetingstate": "0",
 "meetingtitle": "智慧流程产品线花好月圆心悦会",
 "presenterid": "33",
 "starttime": "2015-09-25 16:11:00",
 "userName": "王明远"
 },
 "userid": "13552005259",
 "userstate": "0"
 },
 
 */

//成员数组SHMembers
@property (nonatomic,copy) NSString *mymeetingId;
@property (nonatomic,strong)  SHMeetingModel *meeting;
@property (nonatomic,copy) NSString *userid;

@property (nonatomic,copy) NSString *userstate;

- (instancetype) initWithDict:(NSDictionary *)dict;

+ (instancetype) myMeetingModelWithDict:(NSDictionary *)dict;



@end
