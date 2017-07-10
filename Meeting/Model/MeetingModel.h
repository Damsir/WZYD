//
//  MeetingModel.h
//  HAYD
//
//  Created by 吴定如 on 16/8/29.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeetingModel : NSObject

//@property (nonatomic, copy) NSString *meetingTime;//会议时间
//@property (nonatomic, copy) NSString *meetingType;//会议类型
//@property (nonatomic, copy) NSString *meetingState;//会议状态
//@property (nonatomic, copy) NSString *HostUserName;//会议主持人
//@property (nonatomic, copy) NSString *meetingAddress;//会议地点
//@property (nonatomic, copy) NSString *meetingId;//会议编号
//@property (nonatomic, copy) NSString *meetingName;//会议名称
//@property (nonatomic, copy) NSString *meetingNo;
//@property (nonatomic, copy) NSString *createUserId;

/*
 {
 "id": "402",
 "context": "法国回忆",
 "year": "2016",
 "month": "10",
 "day": "19",
 "startTime": "05:00",
 "remindHoursAhead": "0",
 "remindDaysAhead": "1",
 "isRemind": "0",
 "editDate": "",
 "editor": "李卫",
 "editorId": "0",
 "leader": "李卫",
 "userId": "996",
 "messageId": "0",
 "start": "2016-10-19 00:00:00",
 "end": "2016-10-19 12:00:00"
 }
 */
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *start;
@property (nonatomic, copy) NSString *messageId;
@property (nonatomic, copy) NSString *editorId;
@property (nonatomic, copy) NSString *remindDaysAhead;
@property (nonatomic, copy) NSString *leader;
@property (nonatomic, copy) NSString *context;
@property (nonatomic, copy) NSString *editDate;
@property (nonatomic, copy) NSString *day;
@property (nonatomic, copy) NSString *remindHoursAhead;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *isRemind;
@property (nonatomic, copy) NSString *month;
@property (nonatomic, copy) NSString *editor;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *end;

-(instancetype)initWithDictionary:(NSDictionary *)dic;

@end
