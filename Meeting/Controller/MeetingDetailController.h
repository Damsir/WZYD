//
//  MeetingDetailController.h
//  HAYD
//
//  Created by 吴定如 on 16/8/29.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeetingDetailController : UIViewController

@property(nonatomic,strong) UITableView *meetingTableView;
@property(nonatomic,strong) NSMutableArray *meetingArray;

// 编辑日程成功回调
@property(nonatomic,strong) void(^editMeetingSuccessBlock)(BOOL isSuccess);

@end
