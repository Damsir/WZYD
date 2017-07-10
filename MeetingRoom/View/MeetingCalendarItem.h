//
//  DamCalendarItem.h
//  DamCalendar
//
//  Created by 吴定如 on 16/8/5.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DamCalendarItemDelegate <NSObject>

- (void)seletedOneDay:(NSInteger)day withMonth:(NSInteger)month withYear:(NSInteger)year withDayMeetingArray:(NSArray *)dayMeetingArray;
@optional
- (void)monthOnclick:(NSInteger)lastOrNext;
- (void)yearOnclick:(NSInteger)lastOrNext;

@end

@interface MeetingCalendarItem : UIView<UIAlertViewDelegate>


- (NSDate *)nextMonth:(NSDate *)date;
- (NSDate *)lastMonth:(NSDate *)date;
- (NSDate *)nextYear:(NSDate *)date;
- (NSDate *)lastYear:(NSDate *)date;
- (NSDate *)previousMonthDate;
- (NSDate *)nextMonthDate;

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) id <DamCalendarItemDelegate>delegate;

@property (nonatomic, assign) NSInteger currentDay;
@property (nonatomic, assign) NSInteger currentMonth;
@property (nonatomic, assign) NSInteger currentYear;
@property (nonatomic, assign) NSInteger selectedDay;
@property (nonatomic, assign) NSInteger selectedMonth;
@property (nonatomic, assign) NSInteger selectedYear;
@property(nonatomic,strong) NSArray *meetingData;//数据源

@property(nonatomic,strong) void(^currentDateBlock)(NSInteger year,NSInteger month);

-(void)screenRotation;

@end
