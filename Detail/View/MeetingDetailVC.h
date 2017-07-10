//
//  MeetingDetailVC.h
//  XAYD
//
//  Created by songdan Ye on 16/5/12.
//  Copyright © 2016年 dist. All rights reserved.
//会议详情

#import <UIKit/UIKit.h>
@class SHMeetingModel;
@interface MeetingDetailVC : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewB;
//会议标题
@property (weak, nonatomic) IBOutlet UILabel *mTitle;
//会议时间
@property (weak, nonatomic) IBOutlet UILabel *time;
//会议地点
@property (weak, nonatomic) IBOutlet UILabel *location;
//会议大纲
@property (weak, nonatomic) IBOutlet UILabel *outline;
//列席人员
@property (weak, nonatomic) IBOutlet UILabel *liepersonnel;
//出席人员
@property (weak, nonatomic) IBOutlet UILabel *chupersonnel;
//会议议题
@property (weak, nonatomic) IBOutlet UILabel *subjectToptic;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *mTitleT;
@property (weak, nonatomic) IBOutlet UILabel *timeT;
@property (weak, nonatomic) IBOutlet UILabel *locationT;
@property (weak, nonatomic) IBOutlet UILabel *outlineT;
@property (weak, nonatomic) IBOutlet UILabel *liexiT;
@property (weak, nonatomic) IBOutlet UILabel *chuxiT;
@property (weak, nonatomic) IBOutlet UILabel *subTopicT;

//会议模型
@property (nonatomic,strong)SHMeetingModel *mDatas;





@end
