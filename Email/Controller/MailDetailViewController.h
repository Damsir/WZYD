//
//  MailDetailViewController.h
//  WZYD
//
//  Created by 吴定如 on 16/11/2.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MailModel.h"

@interface MailDetailViewController : UIViewController

@property(nonatomic,strong) MailModel *mailModel;
@property(nonatomic,strong) NSString *mailType;

@end
