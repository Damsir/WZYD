//
//  QuestionModel.h
//  WZYD
//
//  Created by 吴定如 on 16/12/13.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionModel : NSObject

/*
 {
 "id": "1",
 "userId": "318",
 "userName": "王建平",
 "replyToUser": "",
 "content": "这里有问题，我是王建平",
 "parentId": "0",
 "createDate": "2016-12-12",
 "type": "0",
 "replyList": [
 {
 "id": "2",
 "userId": "320",
 "userName": "孙兴林",
 "replyToUser": "王建平",
 "content": "哪里有问题嘛，回复王建平，我是孙兴林",
 "parentId": "1",
 "createDate": "2016-12-13",
 "type": "0"
 }
 }
 */

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, copy) NSString *replyToUser;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) NSMutableArray *replyList;

-(instancetype)initWithDictionary:(NSDictionary *)dic;

@end

@interface ReplyListModel : NSObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, copy) NSString *replyToUser;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *type;

-(instancetype)initWithDictionary:(NSDictionary *)dic;

@end

