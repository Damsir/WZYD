//
//  SHMeetingModel.h
//  distmeeting
//
//  Created by songdan Ye on 15/10/19.
//  Copyright (c) 2015年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHMeetingModel : NSObject

/*
 
 "endtime": "2015-10-16 18:00:00",
 "id": "4028826f505a3b0f0150653791900b19",
 "meetingintroduce": "“2015第四届规划信息中心圆桌研讨会”暨“2016第十届规划信息化实务论坛筹备会”",
 "meetingplace": "上海浦东绿地假期酒店一楼大厅",
 "meetingstate": "0",
 "meetingtitle": "“2015第四届规划信息中心圆桌研讨会”暨“2016第十届规划信息化实务论坛筹备会”",
 "presenterid": "33",
 "starttime": "2015-10-16 13:00:00",
 "userName": "王明远"
 */


/*
 
 [
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

@property (nonatomic,copy) NSString *endtime;
@property (nonatomic,copy) NSString *meetingId;
@property (nonatomic,copy) NSString *meetingintroduce;
@property (nonatomic,copy) NSString *meetingplace;
@property (nonatomic,copy) NSString *meetingstate;
@property (nonatomic,copy) NSString *meetingtitle;
@property (nonatomic,copy) NSString *presenterid;
@property (nonatomic,copy) NSString *starttime;
@property (nonatomic,copy) NSString *userName;
- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)meetingModelWithDict:(NSDictionary *)dict;

- (id)copy;

@end
