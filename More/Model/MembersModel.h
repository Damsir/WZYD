//
//  MembersModel.h
//  HAYD
//
//  Created by 叶松丹 on 16/9/7.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MembersModel : NSObject
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *phoneNumber;
//@property (nonatomic,assign,getter = isStatu ) BOOL *status;
@property (nonatomic,assign,getter = isSelected ) BOOL *selected;


- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)membersModelWithDict:(NSDictionary *)dict;

@end
