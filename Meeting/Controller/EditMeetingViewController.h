//
//  EditMeetingViewController.h
//  WZYD
//
//  Created by 吴定如 on 16/10/27.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingModel.h"

@interface EditMeetingViewController : UIViewController

@property(nonatomic,strong) MeetingModel *model;

@property(nonatomic,strong) void(^editSuccessBlock)(BOOL isSuccess,MeetingModel *model);
@property(nonatomic,strong) void(^deleteSuccessBlock)(BOOL isSuccess);

@end
