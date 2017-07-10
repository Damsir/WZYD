//
//  AddMeetingViewController.h
//  WZYD
//
//  Created by 吴定如 on 16/10/27.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddMeetingViewController : UIViewController

// 添加日程回调
@property(nonatomic,strong) void(^addMeetingSuccessBlock)(BOOL isSuccess);

@end
