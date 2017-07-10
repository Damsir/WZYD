/*
 DSLCalendarView.h
 
 Copyright (c) 2012 Dative Studios. All rights reserved.
 
 */


#import "DSLCalendarRange.h"
#import "NSDate+DSLCalendarView.h"
#import "DSLCalendarDayView.h"
@protocol DSLCalendarViewDelegate;


@interface DSLCalendarView : UIView

@property (nonatomic, weak) id<DSLCalendarViewDelegate>delegate;
@property (nonatomic, copy) NSDateComponents *visibleMonth;
@property (nonatomic, strong) DSLCalendarRange *selectedRange;
//存放数据
@property (nonatomic,strong) NSArray *datasa;


@property (nonatomic,strong) DSLCalendarDayView *dayView;

+ (Class)monthSelectorViewClass;
+ (Class)monthViewClass;
+ (Class)dayViewClass;

- (void)setVisibleMonth:(NSDateComponents *)visibleMonth animated:(BOOL)animated;

-(void)commonInit;

@end


@protocol DSLCalendarViewDelegate <NSObject>

@optional
- (void)calendarView:(DSLCalendarView*)calendarView didSelectRange:(DSLCalendarRange*)range;
- (void)calendarView:(DSLCalendarView *)calendarView willChangeToVisibleMonth:(NSDateComponents*)month duration:(NSTimeInterval)duration;
- (void)calendarView:(DSLCalendarView *)calendarView didChangeToVisibleMonth:(NSDateComponents*)month;
- (DSLCalendarRange*)calendarView:(DSLCalendarView*)calendarView didDragToDay:(NSDateComponents*)day selectingRange:(DSLCalendarRange*)range;
- (BOOL)calendarView:(DSLCalendarView *)calendarView shouldAnimateDragToMonth:(NSDateComponents*)month;

@end
