//
//  SendMailViewController.h
//  WZYD
//
//  Created by 吴定如 on 16/11/2.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MailDetailModel.h"


@interface SendMailViewController : UIViewController

@property(nonatomic,strong) MailDetailModel *model;

// 区分 发送 or 回复(草稿)
@property(nonatomic,strong) NSString *fsOrhf;

@end
