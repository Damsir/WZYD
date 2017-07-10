//
//  ViewController.m
//  MKTreeTest
//
//  Created by 张平 on 15/12/24.
//  Copyright © 2015年 zhangping. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKPeopleCellModel : NSObject

@property (assign, nonatomic) NSInteger messageId;//主键id
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *peoples;
@property (strong, nonatomic) NSDictionary *peopleDic;
@property (strong, nonatomic) NSArray *node;
@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString *mobileID;
@property (assign, nonatomic) BOOL isCheck;


//users
@property (nonatomic, copy) NSString *activityName;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *activityID;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *type;

+ (MKPeopleCellModel *)sharedPeople;

+ (void)clear;

- (void)updateWithDictionary:(NSDictionary *)dict;

- (void)savePeoples;

- (id)initWithName:(NSString *)name people:(NSArray *)people;

+ (id)dataObjectWithName:(NSString *)name children:(NSArray *)peoples;

/*
 {"type":"1","activityID":"c5177287ca4a4079a8267da9cbc531bf","activityName":"分件","userName":"钱向光","userId":"81","node":[]}
 
 */
- (id)initWithActivityName:(NSString *)activityName activityID:(NSString *)activityID userName:(NSString *)userName userId:(NSString *)userId type:(NSString *)type people:(NSArray *)people;

+ (id)dataObjectWithActivityName:(NSString *)activityName activityID:(NSString *)activityID userName:(NSString *)userName userId:(NSString *)userId type:(NSString *)type children:(NSArray *)peoples;

@end
