//
//  MeetingInfoModel.h
//  HAYD
//
//  Created by 吴定如 on 16/8/31.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class personList,topicList,MeetingResultModel;

@interface MeetingInfoModel : NSObject

@property (nonatomic, copy) NSString *success;
@property (nonatomic, copy) NSArray *result;//MeetingResultModel


@end

@interface MeetingResultModel : NSObject

@property (nonatomic, copy) NSString *meetingTime;//会议时间
@property (nonatomic, copy) NSString *meetingType;//会议类型
@property (nonatomic, copy) NSString *meetingState;//会议状态
@property (nonatomic, copy) NSString *HostUserName;//会议主持人
@property (nonatomic, copy) NSString *meetingAddress;//会议地点
@property (nonatomic, copy) NSString *meetingId;//会议编号
@property (nonatomic, copy) NSString *meetingName;//会议名称
@property (nonatomic, copy) NSString *meetingNo;
@property (nonatomic, copy) NSString *createUserId;
@property(nonatomic,strong) NSString *meetingContent;//会议简介/内容
@property(nonatomic,strong) NSString *meetingSummary;//"3.jpg",

@property(nonatomic,strong) NSArray *personList;//
@property(nonatomic,strong) NSArray *topicList;//

@end

//成员列表
@interface personList : NSObject

@property (nonatomic, copy) NSString *personName;
@property (nonatomic, copy) NSString *personType;//"出席人"
@property (nonatomic, copy) NSString *personId;

@end

//讨论议题
@interface topicList : NSObject

@property (nonatomic, copy) NSString *ApplyTime ;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *DesignUnit;
@property (nonatomic, copy) NSString *SortId;
@property (nonatomic, copy) NSString *MeetingOpinion;
@property (nonatomic, copy) NSString *ProjectNo;
@property (nonatomic, copy) NSString *MeetingId;
@property (nonatomic, copy) NSString *CheckSelect;
@property (nonatomic, copy) NSString *MeetingType;
@property (nonatomic, copy) NSString *DecideMeetingTime;
@property (nonatomic, copy) NSString *ProjectInfo;
@property (nonatomic, copy) NSString *ApplyPeople;
@property (nonatomic, copy) NSString *MeetingState;
@property (nonatomic, copy) NSString *ProjectName;
@property (nonatomic, copy) NSString *ApplyOrg;
@property (nonatomic, copy) NSString *DiscussID;
@property (nonatomic, copy) NSString *ProjectId;
/**
 "Id": "0",
 "DiscussID": "1",
 "ProjectName": "选址",
 "ProjectNo": "0",
 "MeetingState": "会审结束",
 "ProjectId": "0",
 "MeetingType": "局业务会",
 "DesignUnit": "",
 "ApplyTime ": "",
 "DecideMeetingTime": "2016/8/5 9:30:00",
 "MeetingOpinion": "",
 "ProjectInfo": "选址",
 "MeetingId": "1",
 "CheckSelect": "False",
 "SortId": "0",
 "ApplyPeople": "张齐全",
 "ApplyOrg": "淮阴分局"
*/

@end
