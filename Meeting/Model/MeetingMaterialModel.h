//
//  MeetingMaterialModel.h
//  HAYD
//
//  Created by 吴定如 on 16/9/1.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MaterialList,MaterialResultModel;
//1.
@interface MeetingMaterialModel : NSObject

@property(nonatomic,strong) NSString *success;
@property(nonatomic,strong) NSArray *result;//MeetingResultModel

@end
//2.
@interface MaterialResultModel : NSObject

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
@property (nonatomic, copy) NSString *createUserId;


@property(nonatomic,strong) NSArray *MaterialList;

/**
 "Id": "0",
 "DiscussID": "29",
 "ProjectName": "宸悦大厦",
 "ProjectNo": "295",
 "MeetingState": "会审结束",
 "ProjectId": "295",
 "MeetingType": "局业务会",
 "DesignUnit": "",
 "ApplyTime ": "",
 "DecideMeetingTime": "2016/8/2 9:30:00",
 "MeetingOpinion": "同意",
 "ProjectInfo": "",
 "MeetingId": "4",
 "CheckSelect": "False",
 "SortId": "0",
 "ApplyPeople": "朱玉洁",
 "ApplyOrg": "新城分局"
*/

@end

//3.
@interface MaterialList : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *MaterialName;
@property (nonatomic, copy) NSString *MaterialType;
@property (nonatomic, copy) NSString *MaterialDetials;//文件
@property (nonatomic, copy) NSString *projectId;
- (NSDictionary *)dictionary;

+ (NSDictionary *)dictionaryWithMaterialListModel:(MaterialList *)model;
/**
 "MaterialName": "淮安市《建设项目选址意见书》网上填报表",
 "MaterialDetials": "595",
 "MaterialType": "表单",
 "ID": "256"
*/

@end

