//
//  MailModel.h
//  WZYD
//
//  Created by 吴定如 on 16/11/1.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MailModel : NSObject

/*
 {
 "EmailTile": "郑元德件信息修改申请",
 "MailID": "154172",
 "sendUser": "孔丽蝶",
 "reciveTime": "2016/3/28 8:59:00",
 "tempId": "154170",
 "count": "68"
 }
 */

@property (nonatomic, copy) NSString *EmailTile;
@property (nonatomic, copy) NSString *sendUser;
@property (nonatomic, copy) NSString *tempId;
@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *reciveTime;
@property (nonatomic, copy) NSString *MailID;


-(instancetype)initWithDictionary:(NSDictionary *)dic;

@end
