//
//  SHMeetingDCell.h
//  distmeeting
//
//  Created by songdan Ye on 15/10/21.
//  Copyright (c) 2015年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SHMeetingModel;

@interface SHMeetingDCell : UITableViewCell
//meetingplace meetingtitle starttime
@property (weak, nonatomic) IBOutlet UILabel *meetingtitle;
@property (weak, nonatomic) IBOutlet UILabel *meetingplace;
@property (weak, nonatomic) IBOutlet UILabel *starttime;

//保存当前cell显示数据
@property (nonatomic,retain) SHMeetingModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *presenticon;
@property (weak, nonatomic) IBOutlet UILabel *userName;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
