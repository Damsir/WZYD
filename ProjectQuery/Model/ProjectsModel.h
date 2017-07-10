//
//  ProjectsModel.h
//  WZYD
//
//  Created by 吴定如 on 16/10/25.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectsModel : NSObject
/*
{
    "buildAddr": "",
    "buildOrg": "",
    "bzName": "规划编制审批",
    "id": "96198",
    "mianJi": "0",
    "projName": "温州市半岛起步区控制性详细规划(2014年修订)",
    "projNo": "OJKGHBZ20150004",
    "projState": "在办",
    "regTime": "2015/10/21 9:25:59",
    "zhengTime": "0001/1/1 0:00:00",
    "pageCount": "50"
}
*/
@property (nonatomic, copy) NSString *buildOrg;
@property (nonatomic, copy) NSString *bzName;
@property (nonatomic, copy) NSString *mianJi;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *projName;
@property (nonatomic, copy) NSString *projNo;
@property (nonatomic, copy) NSString *projState;
@property (nonatomic, copy) NSString *regTime;
@property (nonatomic, copy) NSString *zhengTime;
@property (nonatomic, copy) NSString *pageCount;
@property (nonatomic, copy) NSString *buildAddr;

-(instancetype)initWithDictionary:(NSDictionary *)dic;

@end
