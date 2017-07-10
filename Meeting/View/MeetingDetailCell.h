//
//  MeetingDetailCell.h
//  HAYD
//
//  Created by 吴定如 on 16/8/30.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingModel.h"

@interface MeetingDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *meetingTitle;
@property (weak, nonatomic) IBOutlet UILabel *meetingHoster;
@property (weak, nonatomic) IBOutlet UILabel *meetingAddress;
@property (weak, nonatomic) IBOutlet UILabel *meetingTime;

-(void)setMeetingDetailCell:(MeetingModel *)model;

@end
