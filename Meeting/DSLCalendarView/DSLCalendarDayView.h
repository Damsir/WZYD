/*
 DSLCalendarDayView.m
 
 Copyright (c) 2012 Dative Studios. All rights reserved.
 
 */
#import <UIKit/UIKit.h>
enum {
    DSLCalendarDayViewNotSelected = 0,
    DSLCalendarDayViewWholeSelection,
    DSLCalendarDayViewStartOfSelection,
    DSLCalendarDayViewWithinSelection,
    DSLCalendarDayViewEndOfSelection,
} typedef DSLCalendarDayViewSelectionState;

enum {
    DSLCalendarDayViewStartOfWeek = 0,
    DSLCalendarDayViewMidWeek,
    DSLCalendarDayViewEndOfWeek,
} typedef DSLCalendarDayViewPositionInWeek;


@class SHHomePageViewController;
@interface DSLCalendarDayView : UIView

@property (nonatomic, copy) NSDateComponents *day;
@property (nonatomic, assign) DSLCalendarDayViewPositionInWeek positionInWeek;
@property (nonatomic, assign) DSLCalendarDayViewSelectionState selectionState;
@property (nonatomic, assign, getter = isInCurrentMonth) BOOL inCurrentMonth;

@property (nonatomic, strong, readonly) NSDate *dayAsDate;
@property (nonatomic,strong) SHHomePageViewController *homePage;
@property (nonatomic,strong) NSArray *datasss;
@property (nonatomic, assign, getter = isNeed) BOOL need;

//会议情况
@property (nonatomic, copy) NSString * state;





@end
