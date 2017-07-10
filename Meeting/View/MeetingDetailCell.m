//
//  MeetingDetailCell.m
//  HAYD
//
//  Created by 吴定如 on 16/8/30.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "MeetingDetailCell.h"

@implementation MeetingDetailCell

-(void)setMeetingDetailCell:(MeetingModel *)model
{
    _meetingTitle.text = model.context;
    _meetingHoster.text = model.leader;
    _meetingAddress.text = [model.start substringToIndex:10];
    _meetingTime.text = model.startTime;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
