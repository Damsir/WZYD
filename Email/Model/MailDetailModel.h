//
//  MailDetailModel.h
//  WZYD
//
//  Created by 吴定如 on 16/11/2.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MailDetailModel : NSObject

/*
{
    "EmailTile": "测试",
    "MailID": "154249",
    "SenderID": "580",
    "TargetName": "jzj",
    "body": "测试wweerrt",
    "SenderName": "李卫",
    "DateTime1": "2016/10/13 16:52:55",
    "DateTime2": "2016/10/13 16:52:55"
}
 */

@property (nonatomic, copy) NSString *MailID;
@property (nonatomic, copy) NSString *EmailTile;
@property (nonatomic, copy) NSString *DateTime2;
@property (nonatomic, copy) NSString *TargetName;
@property (nonatomic, copy) NSString *DateTime1;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *SenderName;
@property (nonatomic, copy) NSString *SenderID;


-(instancetype)initWithDictionary:(NSDictionary *)dic;

@end
