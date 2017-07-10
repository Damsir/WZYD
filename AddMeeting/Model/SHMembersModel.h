//
//  SHMembersModel.h
//  distmeeting
//
//  Created by songdan Ye on 15/10/29.
//  Copyright (c) 2015年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SHMembers;
@interface SHMembersModel : NSObject
/*
 [
 {
 "OrganId": "4028816f4d42adb0014d45e011550059",
 "OrganName": "局领导",
 "UserList": [
 {
 "id": "13764301931",
 "name": "元哲起",
 "phoneNumber": "13764301931",
 "status": false
 },
 {
 "id": "13917095772",
 "name": "杜秀清",
 "phoneNumber": "13917095772",
 "status": false
 },
 {
 "id": "18017680466",
 "name": "苏乐平",
 "phoneNumber": "18017680466",
 "status": false
 },
 {
 "id": "18918010303",
 "name": "曹健",
 "phoneNumber": "18918010303",
 "status": false
 },
 {
 "id": "33",
 "name": "wmy",
 "phoneNumber": "",
 "status": true
 }
 ]
 },
 
 ]
 */
@property (nonatomic ,strong)NSString *organId;
@property (nonatomic ,strong)NSString *organName;


//成员数组SHMembers
@property (nonatomic ,strong)NSArray *userList;

@property (nonatomic, assign, getter = isOpened) BOOL opened;
@property (nonatomic, assign, getter = isSelected) BOOL selected;



- (instancetype) initWithDict:(NSDictionary *)dict;

+ (instancetype) memebersModelWithDict:(NSDictionary *)dict;

@end
