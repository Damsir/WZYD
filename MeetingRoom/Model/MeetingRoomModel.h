//
//  MeetingRoomModel.h
//  WZYD
//
//  Created by 吴定如 on 16/11/17.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeetingRoomModel : NSObject

/*
{
    "id": "1827",
    "refMeetingRoomID": "1",
    "roomName": "527会议室",
    "proposer": "张蓓英",
    "timeStart": "2015/12/9 14:30:00",
    "timeEnd": "2015/12/9 17:30:00",
    "timeApply": "2015/12/8 0:00:00",
    "purpose": "讨论都市区建设统筹协调机制管理办法"
}
 */

@property (nonatomic, copy) NSString *roomName;
@property (nonatomic, copy) NSString *proposer;
@property (nonatomic, copy) NSString *timeEnd;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *timeApply;
@property (nonatomic, copy) NSString *timeStart;
@property (nonatomic, copy) NSString *purpose;
@property (nonatomic, copy) NSString *refMeetingRoomID;

-(instancetype)initWithDictionary:(NSDictionary *)dic;

@end
