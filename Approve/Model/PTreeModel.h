//
//  PTreeModel.h
//  XAYD
//
//  Created by songdan Ye on 16/3/14.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 http://58.246.138.178:8040/iOffice/serviceprovider.ashx?type=smartplan&action=projecttree&showType=3&slbh=XZ20150014&includeAllResources=false6
 {
 "success": "true",
 "result": [
 {
 "group": "建设项目选址意见书核发(含变更、延续)",
 "groupid": "122",
 "items": [
 {
 "name": "义乌商贸服务业集聚区商贸流通创新区（佛堂地块）配套道路工程(XZ20150014)"
 }
 ]
 }
 ]
 }
 
 
 
 */
@interface PTreeModel : NSObject

@property (nonatomic,strong) NSString *group;
@property (nonatomic,strong) NSString *groupid;
//@property (nonatomic,assign)int lever;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,strong) NSArray *items;
@property (nonatomic, assign, getter = isOpened) BOOL opened;


- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)pTreeWithDict:(NSDictionary *)dict;


@end
