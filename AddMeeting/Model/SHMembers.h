//
//  SHMembers.h
//  distmeeting
//
//  Created by songdan Ye on 15/10/26.
//  Copyright (c) 2015年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 {
 \"id\": \"15821797656\",
 \"name\": \"汤磊\",
 \"phoneNumber\": \"15821797656\",
 \"status\": false
 },
 */
@interface SHMembers : NSObject

@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *phoneNumber;
@property (nonatomic,assign,getter = isStatu ) BOOL *status;
@property (nonatomic,assign,getter = isSelected ) BOOL *selected;


- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)membersModelWithDict:(NSDictionary *)dict;
@end
