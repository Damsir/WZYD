//
//  DamPeopleCellModel.h
//  WZYD
//
//  Created by 吴定如 on 16/12/4.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DamPeopleCellModel : NSObject

@property (assign, nonatomic) NSInteger messageId;//主键id
@property (strong, nonatomic) NSArray *peoples;
@property (strong, nonatomic) NSDictionary *peopleDic;
@property (strong, nonatomic) NSArray *node;
@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString *mobileID;
@property (assign, nonatomic) BOOL isCheck;

// users
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *type;


+ (DamPeopleCellModel *)sharedPeople;

+ (void)clear;

- (void)updateWithDictionary:(NSDictionary *)dict;

- (void)savePeoples;

//{"name":"yjh-test(叶建辉)","id":"587","type":"1","node":[]}
- (id)initWithName:(NSString *)name Id:(NSString *)Id type:(NSString *)type people:(NSArray *)people;

+ (id)dataObjectWithName:(NSString *)name Id:(NSString *)Id type:(NSString *)type children:(NSArray *)peoples;

@end
