//
//  ContactModel.h
//  HAYD
//
//  Created by 叶松丹 on 16/9/7.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactModel : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *bmName;
@property (nonatomic, strong) NSNumber *index;


@property (nonatomic ,strong)NSString *organId;
@property (nonatomic ,strong)NSString *organName;


//成员数组SHMembers
@property (nonatomic ,strong)NSArray *userList;

@property (nonatomic, assign, getter = isOpened) BOOL opened;
@property (nonatomic, assign, getter = isSelected) BOOL selected;



- (instancetype) initWithDict:(NSDictionary *)dict;

+ (instancetype) contactModelWithDict:(NSDictionary *)dict;

@end
