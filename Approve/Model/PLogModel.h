//
//  PLogModel.h
//  XAYD
//
//  Created by songdan Ye on 16/3/14.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLogModel : NSObject

//
//{
//    "Id": "21a8a873d0bc48a4a04da1b7fea5fa09",
//    "StartTime": "2015/12/1 15:05:25",
//    "EndTime": "2015/12/4 1:31:27",
//    "LogName": "窗口受理，初审",
//    "UserName": "banyq",
//    "Type": "发送",
//    "Remark": "经办复审（banyq）"
//},

//@property (nonatomic,strong) NSString *logId;
//@property (nonatomic,strong) NSString *startTime;
//@property (nonatomic,strong) NSString *endTime;
//@property (nonatomic,strong) NSString *logName;
//@property (nonatomic,strong) NSString *userName;
//@property (nonatomic,strong) NSString *type;
//@property (nonatomic,strong) NSString *remark;

/*
{"ActivityContent":"开始——>数据分发",
    "PreviousRoleName":"",
    "NextRoleName":"信息中心上机",
    "ReceiveTime":"2016/3/21 10:09:45",
    "SendTime":"2016/3/21 10:09:45"}
 */

// 项目办理
@property (nonatomic, copy) NSString *PreviousRoleName;
@property (nonatomic, copy) NSString *NextRoleName;
@property (nonatomic, copy) NSString *ReceiveTime;
@property (nonatomic, copy) NSString *SendTime;
@property (nonatomic, copy) NSString *ActivityContent;
@property (nonatomic, copy) NSString *content;//显示的内容
/*
{
    "ActivityContent": "开始——>经办人拟稿",
    "PreviousRoleName": "",
    "NextRoleName": "朱淑慧",
    "ReceiveTime": "2016/3/17 16:31:43",
    "SendTime": "2016/3/17 16:31:43"
}
 */

// 项目审批
//@property (nonatomic, copy) NSString *PreviousRoleName;
//@property (nonatomic, copy) NSString *ReceiveTime;
//@property (nonatomic, copy) NSString *NextRoleName;
//@property (nonatomic, copy) NSString *SendTime;
//@property (nonatomic, copy) NSString *ActivityContent;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)plogWithDict:(NSDictionary *)dict;

@end
