//
//  SPDetailModel.h
//  XAYD
//
//  Created by songdan Ye on 16/3/7.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>



/*
{
   
 
 "projectName": "梅园",
 "projectId": "12680",
 "wfWorkItemId": "ab5b5045e6094c1cbf93ddfe0406631b",
 "address": "天天",
 "company": "天天",
 "xmbh": "SP201500152",
 "slbh": "XZ20150014",
 "activityName": "科长审核",
 "currentUser": " banyq",
 "contactName": "天天",
 "contactPhone": "111111111",
 "hjjs": "在办",
 "time": "2015/12/1 15:05:03",
 "business": "建设项目选址意见书核发(含变更、延续)(省扩权)",
 "day": "3"
 
}
 */


@interface SPDetailModel : NSObject

// 项目办理(审批)
@property (nonatomic,copy) NSString *ProjectId;
@property (nonatomic,copy) NSString *activityName;// 环节名称
@property (nonatomic,copy) NSString *businessName;// 业务名称
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *count;

// 项目查询
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

// 公文
@property (nonatomic, copy) NSString *ProjectNo;
@property (nonatomic, copy) NSString *ProjectCaseNo;
//@property (nonatomic, copy) NSString *ActivityName;
//@property (nonatomic, copy) NSString *count;
//@property (nonatomic, copy) NSString *name;
//@property (nonatomic, copy) NSString *ProjectId;


/**
 *  以前
 */
@property (nonatomic,copy) NSString *projectName;
@property (nonatomic,copy)NSString *wfWorkItemId;
@property (nonatomic,copy)NSString *address;
@property (nonatomic,copy)NSString *company;
@property (nonatomic,copy)NSString *xmbh;
@property (nonatomic,copy)NSString *slbh;

@property (nonatomic,copy)NSString *currentUser;
@property (nonatomic,copy)NSString *hjjs;
@property (nonatomic,copy)NSString *time;
@property (nonatomic,copy)NSString *business;
@property (nonatomic,copy)NSString *FLOWLEFTTIME;


//字典转模型
- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)spDetailModelWithDict:(NSDictionary *)dict;

//模型转字典
- (NSDictionary *)dictionary;
+ (NSDictionary *)dictionaryWithSPDetailModel:(SPDetailModel *)model;

//模型转字典
- (NSDictionary *)dictionaryGW;
+ (NSDictionary *)dictionaryWithGWModel:(SPDetailModel *)model;




@end
