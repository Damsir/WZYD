//
//  MeetingMaterialVC.h
//  HAYD
//
//  Created by 吴定如 on 16/8/31.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeetingMaterialVC : UIViewController

@property(nonatomic,strong) NSString *meetingId;
@property(nonatomic,strong) UINavigationController *nav;

- (void)transFromMeetingId:(NSString *)meetingId;
-(void)screenRotation;

@end
