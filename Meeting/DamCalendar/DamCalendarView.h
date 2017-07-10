//
//  DamCalendarView.h
//  DamCalendar
//
//  Created by 吴定如 on 16/8/5.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DamCalendarItem.h"

@protocol DamCalendarViewDelegate <NSObject>

- (void)seletedOneDay:(NSInteger )day withMonth:(NSInteger )month withYear:(NSInteger )year;

@end

@interface DamCalendarView : UIView<UIScrollViewDelegate,DamCalendarItemDelegate>

@property (nonatomic,assign)NSInteger currentDay;
@property (nonatomic,assign)NSInteger currentMonth;
@property (nonatomic,assign)NSInteger currentYear;
@property (nonatomic,assign)id <DamCalendarItemDelegate>delegate;
//存放数据
@property (nonatomic,strong) NSArray *meetingData;
//-(void)loadCalendarMeetingData:(NSArray *)meetingData;


@property(nonatomic,strong) void(^currentDateBlock)(NSInteger year,NSInteger month);

-(void)screenRotation;
//初始化日历并赋值数据
- (instancetype)initWithFrame:(CGRect)frame withMeetingData:(NSArray *)meetingData;

@end
