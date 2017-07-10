//
//  MeetingBaseVC.h
//  HAYD
//
//  Created by 吴定如 on 16/8/31.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeetingBaseVC : UIViewController

@property(nonatomic,strong) NSString *meetingId;
@property(nonatomic,strong) UINavigationController *nav;


-(void)screenRotation;
- (void)transFromMeetingId:(NSString *)meetingId;

@end
