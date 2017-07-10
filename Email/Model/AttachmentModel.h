//
//  AttachmentModel.h
//  WZYD
//
//  Created by 吴定如 on 16/11/8.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttachmentModel : NSObject

/*
 {
 "Name": "三廊桥规划修改答复20141020(4)11.doc",
 "MailID": "176388",
 "ftpFullPath": "MailAttach//176388"
 }
*/

@property (nonatomic, copy) NSString *Extension;//自己截取
@property (nonatomic, copy) NSString *MailID;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *ftpFullPath;

-(instancetype)initWithDictionary:(NSDictionary *)dic;

@end
