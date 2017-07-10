//
//  SHAgencyVController.h
//  distmeeting
//
//  Created by songdan Ye on 15/10/26.
//  Copyright (c) 2015年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SHMeetingModel;
@class SHMembers;
@interface SHAgencyVController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *agencySView;

@property (weak, nonatomic) IBOutlet UILabel *meetingSite;
@property (weak, nonatomic) IBOutlet UILabel *appear;

//会议开始时间
@property (weak, nonatomic) IBOutlet UILabel *starttime;
//会议主题
@property (strong, nonatomic) UILabel *meetingtitle1;


//会议时间
@property (weak, nonatomic) IBOutlet UILabel *time;
//参会人员
@property (weak, nonatomic) IBOutlet UILabel *MeetingMembers;
//会议议题
@property (weak, nonatomic) IBOutlet UILabel *meetingintroduce;

//会议内容
@property (weak, nonatomic) IBOutlet UILabel *meetingintroduce1;


@property (nonatomic,strong)NSString *meetingId;
@property (nonatomic,strong)SHMeetingModel *dataS;
//会议成员
@property (nonatomic,strong)NSArray *dataM;
@property (weak, nonatomic) IBOutlet UILabel *meetContext;
@property (weak, nonatomic) IBOutlet UILabel *meetTime;
@property (weak, nonatomic) IBOutlet UILabel *meetSite;
@property (weak, nonatomic) IBOutlet UILabel *meetMember;
@property (weak, nonatomic) IBOutlet UILabel *meetAgency;


@end
