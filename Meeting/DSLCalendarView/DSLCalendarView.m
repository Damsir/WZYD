/*
 DSLCalendarView.m
 
 Copyright (c) 2012 Dative Studios. All rights reserved.
 

 */


//#import "DSLCalendarDayCalloutView.h"
#import "DSLCalendarDayView.h"
#import "DSLCalendarMonthSelectorView.h"
#import "DSLCalendarMonthView.h"
#import "DSLCalendarView.h"
#import "DSLCalendarDayView.h"


@interface DSLCalendarView ()

//@property (nonatomic, strong) DSLCalendarDayCalloutView *dayCalloutView;
@property (nonatomic, copy) NSDateComponents *draggingFixedDay;
@property (nonatomic, copy) NSDateComponents *draggingStartDay;
@property (nonatomic, assign) BOOL draggedOffStartDay;

@property (nonatomic, strong) NSMutableDictionary *monthViews;
@property (nonatomic, strong) UIView *monthContainerView;
@property (nonatomic, strong) UIView *monthContainerViewContentView;
@property (nonatomic, strong) DSLCalendarMonthSelectorView *monthSelectorView;

@end


@implementation DSLCalendarView {
    CGFloat _dayViewHeight;
    NSDateComponents *_visibleMonth;
}

#pragma mark - Memory management

- (void)dealloc {
}


#pragma mark - Initialisation

// Designated initialisers

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self commonInit];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self != nil) {
//        [self commonInit];

    }

    return self;
}

- (void)commonInit {
    
    _dayViewHeight = 44;
    
    _visibleMonth = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSCalendarCalendarUnit fromDate:[NSDate date]];
    _visibleMonth.day = 1;
    
    self.monthSelectorView = [[[self class] monthSelectorViewClass] view];
    self.monthSelectorView.backgroundColor = [UIColor clearColor];
    self.monthSelectorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    
    self.monthSelectorView.frame = CGRectMake(0, 0, SCREEN_WIDTH-10, 64);
    self.monthSelectorView.backButton.frame = CGRectMake(0, 0, 40, 40);
    
    CGFloat titleX =CGRectGetMaxX(self.monthSelectorView.backButton.frame);
    CGFloat titleY = 0;
    CGFloat titleW = SCREEN_WIDTH - 2*40-20;
    CGFloat titleH = 44;
    
    
    self.monthSelectorView.titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
    self.monthSelectorView.forwardButton.frame = CGRectMake(SCREEN_WIDTH-50, 0, 40, 40);
    CGFloat dateFX=0;
    CGFloat dateFY = 44;
    CGFloat dateFW= SCREEN_WIDTH/7-1;
    CGFloat dateFH= 20;
    
    
    self.monthSelectorView.sun.frame =CGRectMake(dateFX, dateFY, dateFW, dateFH);
    
    self.monthSelectorView.mon.frame = CGRectMake(CGRectGetMaxX(self.monthSelectorView.sun.frame), dateFY, dateFW, dateFH);
    self.monthSelectorView.tues.frame = CGRectMake(CGRectGetMaxX(self.monthSelectorView.mon.frame), dateFY, dateFW, dateFH);
    self.monthSelectorView.wed.frame = CGRectMake(CGRectGetMaxX(self.monthSelectorView.tues.frame), dateFY, dateFW, dateFH);
    self.monthSelectorView.thur.frame = CGRectMake(CGRectGetMaxX(self.monthSelectorView.wed.frame), dateFY, dateFW, dateFH);
    self.monthSelectorView.fri.frame = CGRectMake(CGRectGetMaxX(self.monthSelectorView.thur.frame), dateFY, dateFW, dateFH);
    self.monthSelectorView.sat.frame = CGRectMake(CGRectGetMaxX(self.monthSelectorView.fri.frame), dateFY, dateFW, dateFH);
    
    
    
    [self addSubview:self.monthSelectorView];//把指示视图添加上去
    
    [self.monthSelectorView.backButton addTarget:self action:@selector(didTapMonthBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.monthSelectorView.forwardButton addTarget:self action:@selector(didTapMonthForward:) forControlEvents:UIControlEventTouchUpInside];

    // Month views are contained in a content view inside a container view - like a scroll view, but not a scroll view so we can have proper control over animations
    CGRect frame = self.bounds;
    frame.origin.x = 0;
    frame.origin.y = CGRectGetMaxY(self.monthSelectorView.frame);
    frame.size.height -= frame.origin.y;
    self.monthContainerView = [[UIView alloc] initWithFrame:frame];
    self.monthContainerView.clipsToBounds = YES;
    
    
    [self addSubview:self.monthContainerView];
    
    self.monthContainerViewContentView = [[UIView alloc] initWithFrame:self.monthContainerView.bounds];
    [self.monthContainerView addSubview:self.monthContainerViewContentView];
    
    self.monthViews = [[NSMutableDictionary alloc] init];

    [self updateMonthLabelMonth:_visibleMonth];
    [self positionViewsForMonth:_visibleMonth fromMonth:_visibleMonth animated:NO];
    
    
}


#pragma mark - Properties

+ (Class)monthSelectorViewClass {
    
    return [DSLCalendarMonthSelectorView class];
}

+ (Class)monthViewClass {
    return [DSLCalendarMonthView class];
}

+ (Class)dayViewClass {
    return [DSLCalendarDayView class];
}

//- (void)setSelectedRange:(DSLCalendarRange *)selectedRange {
//    _selectedRange = selectedRange;
//    
//    for (DSLCalendarMonthView *monthView in self.monthViews.allValues) {
//        [monthView updateDaySelectionStatesForRange:self.selectedRange];
//    }
//}

- (void)setDraggingStartDay:(NSDateComponents *)draggingStartDay {

    _draggingStartDay = [draggingStartDay copy];
    if (draggingStartDay == nil) {
       // [self.dayCalloutView removeFromSuperview];
    }
}

- (NSDateComponents*)visibleMonth {
    return [_visibleMonth copy];
}

- (void)setVisibleMonth:(NSDateComponents *)visibleMonth {
    [self setVisibleMonth:visibleMonth animated:NO];
}

- (void)setVisibleMonth:(NSDateComponents *)visibleMonth animated:(BOOL)animated {
    NSDateComponents *fromMonth = [_visibleMonth copy];
    _visibleMonth = [visibleMonth.date dslCalendarView_monthWithCalendar:self.visibleMonth.calendar];

    [self updateMonthLabelMonth:_visibleMonth];
    [self positionViewsForMonth:_visibleMonth fromMonth:fromMonth animated:animated];
}


#pragma mark - Events

- (void)didTapMonthBack:(id)sender {
    NSDateComponents *newMonth = self.visibleMonth;
    newMonth.month--;

    [self setVisibleMonth:newMonth animated:YES];
}

- (void)didTapMonthForward:(id)sender {
    NSDateComponents *newMonth = self.visibleMonth;
    newMonth.month++;
    
    [self setVisibleMonth:newMonth animated:YES];
}


#pragma mark - 

- (void)updateMonthLabelMonth:(NSDateComponents*)month {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"MMM yyyy";
//    formatter.dateFormat = [NSString stringWithFormat:@"%d",]
    formatter.dateFormat = @"yyyy 年 M 月";
    
    NSDate *date = [month.calendar dateFromComponents:month];
    self.monthSelectorView.titleLabel.text = [formatter stringFromDate:date];

    
}

- (NSString*)monthViewKeyForMonth:(NSDateComponents*)month {
    month = [month.calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:month.date];
    return [NSString stringWithFormat:@"%d.%d", month.year, month.month];
}

- (DSLCalendarMonthView*)cachedOrCreatedMonthViewForMonth:(NSDateComponents*)month {
    month = [month.calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSCalendarCalendarUnit fromDate:month.date];

    NSString *monthViewKey = [self monthViewKeyForMonth:month];
    DSLCalendarMonthView *monthView = [self.monthViews objectForKey:monthViewKey];
    if (monthView == nil) {
        monthView = [[[[self class] monthViewClass] alloc] initWithMonth:month width:self.bounds.size.width dayViewClass:[[self class] dayViewClass] dayViewHeight:_dayViewHeight tempArray:self.datasa];
            monthView.tempArray=self.datasa;
        [self.monthViews setObject:monthView forKey:monthViewKey];
        [self.monthContainerViewContentView addSubview:monthView];

//        [monthView updateDaySelectionStatesForRange:self.selectedRange];
    }
    
    return monthView;
    
    
    
}

- (void)positionViewsForMonth:(NSDateComponents*)month fromMonth:(NSDateComponents*)fromMonth animated:(BOOL)animated {
    fromMonth = [fromMonth copy];
    month = [month copy];
    
    CGFloat nextVerticalPosition = 0;
    CGFloat startingVerticalPostion = 0;
    CGFloat restingVerticalPosition = 0;
    CGFloat restingHeight = 0;
    
    NSComparisonResult monthComparisonResult = [month.date compare:fromMonth.date];
    NSTimeInterval animationDuration = (monthComparisonResult == NSOrderedSame || !animated) ? 0.0 : 0.5;
    
    NSMutableArray *activeMonthViews = [[NSMutableArray alloc] init];
    
    // Create and position the month views for the target month and those around it
    for (NSInteger monthOffset = -2; monthOffset <= 2; monthOffset += 1) {
        NSDateComponents *offsetMonth = [month copy];
        offsetMonth.month = offsetMonth.month + monthOffset;
        offsetMonth = [offsetMonth.calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSCalendarCalendarUnit fromDate:offsetMonth.date];
        
        // Check if this month should overlap the previous month
        if (![self monthStartsOnFirstDayOfWeek:offsetMonth]) {
            nextVerticalPosition -= _dayViewHeight;
        }
        
        // Create and position the month view
        DSLCalendarMonthView *monthView = [self cachedOrCreatedMonthViewForMonth:offsetMonth];
        [activeMonthViews addObject:monthView];
        [monthView.superview bringSubviewToFront:monthView];

        CGRect frame = monthView.frame;
        frame.origin.y = nextVerticalPosition;
        nextVerticalPosition += frame.size.height;
        monthView.frame = frame;

        // Check if this view is where we should animate to or from
        if (monthOffset == 0) {
            // This is the target month so we can use it to determine where to scroll to
            restingVerticalPosition = monthView.frame.origin.y;
            restingHeight += monthView.bounds.size.height;
        }
        else if (monthOffset == 1 && monthComparisonResult == NSOrderedAscending) {
            // This is the month we're scrolling back from
            startingVerticalPostion = monthView.frame.origin.y;
            
            if ([self monthStartsOnFirstDayOfWeek:offsetMonth]) {
                startingVerticalPostion -= _dayViewHeight;
            }
        }
        else if (monthOffset == -1 && monthComparisonResult == NSOrderedDescending) {
            // This is the month we're scrolling forward from
            startingVerticalPostion = monthView.frame.origin.y;
            
            if ([self monthStartsOnFirstDayOfWeek:offsetMonth]) {
                startingVerticalPostion -= _dayViewHeight;
            }
        }

        // Check if the active or following month start on the first day of the week
        if (monthOffset == 0 && [self monthStartsOnFirstDayOfWeek:offsetMonth]) {
            // If the active month starts on a monday, add a day view height to the resting height and move the resting position up so the user can drag into that previous month
            restingVerticalPosition -= _dayViewHeight;
            restingHeight += _dayViewHeight;
        }
        else if (monthOffset == 1 && [self monthStartsOnFirstDayOfWeek:offsetMonth]) {
            // If the month after the target month starts on a monday, add a day view height to the resting height so the user can drag into that month
            restingHeight += _dayViewHeight;
        }
    }
    
    // Size the month container to fit all the month views
    CGRect frame = self.monthContainerViewContentView.frame;
    frame.size.height = CGRectGetMaxY([[activeMonthViews lastObject] frame]);
    self.monthContainerViewContentView.frame = frame;
    
    // Remove any old month views we don't need anymore
    NSArray *monthViewKeyes = self.monthViews.allKeys;
    for (NSString *key in monthViewKeyes) {
        UIView *monthView = [self.monthViews objectForKey:key];
        if (![activeMonthViews containsObject:monthView]) {
            [monthView removeFromSuperview];
            [self.monthViews removeObjectForKey:key];
        }
    }
    
    // Position the content view to show where we're animating from
    if (monthComparisonResult != NSOrderedSame) {
        CGRect frame = self.monthContainerViewContentView.frame;
        frame.origin.y = -startingVerticalPostion;
        self.monthContainerViewContentView.frame = frame;
    }
    
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:animationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        for (NSInteger index = 0; index < activeMonthViews.count; index++) {
            DSLCalendarMonthView *monthView = [activeMonthViews objectAtIndex:index];
             for (DSLCalendarDayView *dayView in monthView.dayViews) {
                 // Use a transition so it fades between states nicely
                 [UIView transitionWithView:dayView duration:animationDuration options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                     dayView.inCurrentMonth = (index == 2);
                 } completion:NULL];
             }
        }
        
        // Animate the content view to show the target month
        CGRect frame = self.monthContainerViewContentView.frame;
        frame.origin.y = -restingVerticalPosition;
        self.monthContainerViewContentView.frame = frame;
        
        // Resize the container view to show the height of the target month
        frame = self.monthContainerView.frame;
        frame.size.height = restingHeight;
        self.monthContainerView.frame = frame;
        
        // Resize the our frame to show the height of the target month
        frame = self.frame;
        frame.size.height = CGRectGetMaxY(self.monthContainerView.frame);
        self.frame = frame;
        
        // Tell the delegate method that we're about to animate to a new month
        if (monthComparisonResult != NSOrderedSame && [self.delegate respondsToSelector:@selector(calendarView:willChangeToVisibleMonth:duration:)]) {
            [self.delegate calendarView:self willChangeToVisibleMonth:[month copy] duration:animationDuration];
        }
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;

        if (finished) {
            // Tell the delegate method that we've animated to a new month
            if (monthComparisonResult != NSOrderedSame && [self.delegate respondsToSelector:@selector(calendarView:didChangeToVisibleMonth:)]) {
                [self.delegate calendarView:self didChangeToVisibleMonth:[month copy]];
            }
        }
    }];
}

- (BOOL)monthStartsOnFirstDayOfWeek:(NSDateComponents*)month {
    // Make sure we have the components we need to do the calculation
    month = [month.calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSCalendarCalendarUnit fromDate:month.date];
    
    return (month.weekday - month.calendar.firstWeekday == 0);
}


#pragma mark - Touches




- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    DSLCalendarDayView *touchedView = [self dayViewForTouches:touches];
    if (touchedView == nil) {
        self.draggingStartDay = nil;
        return;
    }
    
    self.draggingStartDay = touchedView.day;
    self.draggingFixedDay = touchedView.day;
    self.draggedOffStartDay = NO;
    
    DSLCalendarRange *newRange = self.selectedRange;
    
    newRange.datas = _datasa;
    
    if (self.selectedRange == nil) {
        newRange = [[DSLCalendarRange alloc] initWithStartDay:touchedView.day endDay:touchedView.day];
    }
    else if (![self.selectedRange.startDay isEqual:touchedView.day] && ![self.selectedRange.endDay isEqual:touchedView.day]) {
        newRange = [[DSLCalendarRange alloc] initWithStartDay:touchedView.day endDay:touchedView.day];
    }
    else if ([self.selectedRange.startDay isEqual:touchedView.day]) {
        self.draggingFixedDay = self.selectedRange.endDay;
    }
    else {
        self.draggingFixedDay = self.selectedRange.startDay;
    }
    
    if ([self.delegate respondsToSelector:@selector(calendarView:didDragToDay:selectingRange:)]) {
        newRange = [self.delegate calendarView:self didDragToDay:touchedView.day selectingRange:newRange];
    }
    self.selectedRange = newRange;
    
    //[self positionCalloutViewForDayView:touchedView];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.draggingStartDay == nil) {
        return;
    }
    
    DSLCalendarDayView *touchedView = [self dayViewForTouches:touches];
    if (touchedView == nil) {
        self.draggingStartDay = nil;
        return;
    }
    
    DSLCalendarRange *newRange;
    if ([touchedView.day.date compare:self.draggingFixedDay.date] == NSOrderedAscending) {
        newRange = [[DSLCalendarRange alloc] initWithStartDay:touchedView.day endDay:self.draggingFixedDay];
    }
    else {
        newRange = [[DSLCalendarRange alloc] initWithStartDay:self.draggingFixedDay endDay:touchedView.day];
    }

    if ([self.delegate respondsToSelector:@selector(calendarView:didDragToDay:selectingRange:)]) {
        newRange = [self.delegate calendarView:self didDragToDay:touchedView.day selectingRange:newRange];
    }
    self.selectedRange = newRange;

    if (!self.draggedOffStartDay) {
        if (![self.draggingStartDay isEqual:touchedView.day]) {
            self.draggedOffStartDay = YES;
        }
    }

   // [self positionCalloutViewForDayView:touchedView];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.draggingStartDay == nil) {
        return;
    }
    
    DSLCalendarDayView *touchedView = [self dayViewForTouches:touches];
    if (touchedView == nil) {
        self.draggingStartDay = nil;
        return;
    }
    
    if (!self.draggedOffStartDay && [self.draggingStartDay isEqual:touchedView.day]) {
        self.selectedRange = [[DSLCalendarRange alloc] initWithStartDay:touchedView.day endDay:touchedView.day];
    }
    
    self.draggingStartDay = nil;
    
    // Check if the user has dragged to a day in an adjacent month
    if (touchedView.day.year != _visibleMonth.year || touchedView.day.month != _visibleMonth.month) {
        // Ask the delegate if it's OK to animate to the adjacent month
        BOOL animateToAdjacentMonth = YES;
        if ([self.delegate respondsToSelector:@selector(calendarView:shouldAnimateDragToMonth:)]) {
            animateToAdjacentMonth = [self.delegate calendarView:self shouldAnimateDragToMonth:[touchedView.dayAsDate dslCalendarView_monthWithCalendar:_visibleMonth.calendar]];
        }
        
        if (animateToAdjacentMonth) {
            if ([touchedView.dayAsDate compare:_visibleMonth.date] == NSOrderedAscending) {
                [self didTapMonthBack:nil];
            }
            else {
                [self didTapMonthForward:nil];
            }
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(calendarView:didSelectRange:)]) {
        [self.delegate calendarView:self didSelectRange:self.selectedRange];
    }

}


- (DSLCalendarDayView*)dayViewForTouches:(NSSet*)touches {
    if (touches.count != 1) {
        return nil;
    }

    UITouch *touch = [touches anyObject];
    
    // Check if the touch is within the month container
    if (!CGRectContainsPoint(self.monthContainerView.frame, [touch locationInView:self.monthContainerView.superview])) {
        return nil;
    }
    
    // Work out which day view was touched. We can't just use hit test on a root view because the month views can overlap
    for (DSLCalendarMonthView *monthView in self.monthViews.allValues) {
        UIView *view = [monthView hitTest:[touch locationInView:monthView] withEvent:nil];
        if (view == nil) {
            continue;
        }
        
        while (view != monthView) {
            if ([view isKindOfClass:[DSLCalendarDayView class]]) {
                return (DSLCalendarDayView*)view;
            }
            
            view = view.superview;
        }
    }
    
    return nil;
}


#pragma mark - Day callout view methods

/*- (void)positionCalloutViewForDayView:(DSLCalendarDayView*)dayView {
    if (dayView == nil) {
        [self.dayCalloutView removeFromSuperview];
    }
    else {
        CGRect calloutFrame = [self convertRect:dayView.frame fromView:dayView.superview];
        calloutFrame.origin.y -= calloutFrame.size.height;
        calloutFrame.size.height *= 2;
        
        if (self.dayCalloutView == nil) {
            self.dayCalloutView = [DSLCalendarDayCalloutView view];
        }

        self.dayCalloutView.frame = calloutFrame;
        [self.dayCalloutView configureForDay:dayView.day];
        
        if (self.dayCalloutView.superview == nil) {
            [self addSubview:self.dayCalloutView];
        }
        else {
            [self bringSubviewToFront:self.dayCalloutView];
        }
    }
}
*/


//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    _dayViewHeight = 44;
//    
//    _visibleMonth = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSCalendarCalendarUnit fromDate:[NSDate date]];
//    _visibleMonth.day = 1;
//    
//    self.monthSelectorView = [[[self class] monthSelectorViewClass] view];
//    self.monthSelectorView.backgroundColor = [UIColor clearColor];
//    self.monthSelectorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
//    
//    self.monthSelectorView.frame = CGRectMake(0, 0, SCREEN_WIDTH-10, 64);
//    self.monthSelectorView.backButton.frame = CGRectMake(0, 0, 40, 40);
//    
//    CGFloat titleX =CGRectGetMaxX(self.monthSelectorView.backButton.frame);
//    CGFloat titleY = 0;
//    CGFloat titleW = SCREEN_WIDTH - 2*40-20;
//    CGFloat titleH = 44;
//    
//    
//    self.monthSelectorView.titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
//    self.monthSelectorView.forwardButton.frame = CGRectMake(SCREEN_WIDTH-50, 0, 40, 40);
//    CGFloat dateFX=0;
//    CGFloat dateFY = 44;
//    CGFloat dateFW= SCREEN_WIDTH/7-1;
//    CGFloat dateFH= 20;
//    
//    
//    self.monthSelectorView.sun.frame =CGRectMake(dateFX, dateFY, dateFW, dateFH);
//    
//    self.monthSelectorView.mon.frame = CGRectMake(CGRectGetMaxX(self.monthSelectorView.sun.frame), dateFY, dateFW, dateFH);
//    self.monthSelectorView.tues.frame = CGRectMake(CGRectGetMaxX(self.monthSelectorView.mon.frame), dateFY, dateFW, dateFH);
//    self.monthSelectorView.wed.frame = CGRectMake(CGRectGetMaxX(self.monthSelectorView.tues.frame), dateFY, dateFW, dateFH);
//    self.monthSelectorView.thur.frame = CGRectMake(CGRectGetMaxX(self.monthSelectorView.wed.frame), dateFY, dateFW, dateFH);
//    self.monthSelectorView.fri.frame = CGRectMake(CGRectGetMaxX(self.monthSelectorView.thur.frame), dateFY, dateFW, dateFH);
//    self.monthSelectorView.sat.frame = CGRectMake(CGRectGetMaxX(self.monthSelectorView.fri.frame), dateFY, dateFW, dateFH);
//    
//    
//    
//    [self addSubview:self.monthSelectorView];//把指示视图添加上去
//    
//    [self.monthSelectorView.backButton addTarget:self action:@selector(didTapMonthBack:) forControlEvents:UIControlEventTouchUpInside];
//    [self.monthSelectorView.forwardButton addTarget:self action:@selector(didTapMonthForward:) forControlEvents:UIControlEventTouchUpInside];
//    
//    // Month views are contained in a content view inside a container view - like a scroll view, but not a scroll view so we can have proper control over animations
//    CGRect frame = self.bounds;
//    frame.origin.x = 0;
//    frame.origin.y = CGRectGetMaxY(self.monthSelectorView.frame);
//    frame.size.height -= frame.origin.y;
//    self.monthContainerView = [[UIView alloc] initWithFrame:frame];
//    self.monthContainerView.clipsToBounds = YES;
//    
//    
//    [self addSubview:self.monthContainerView];
//    
//    self.monthContainerViewContentView = [[UIView alloc] initWithFrame:self.monthContainerView.bounds];
//    [self.monthContainerView addSubview:self.monthContainerViewContentView];
//    
//    self.monthViews = [[NSMutableDictionary alloc] init];
//    
//    [self updateMonthLabelMonth:_visibleMonth];
//    [self positionViewsForMonth:_visibleMonth fromMonth:_visibleMonth animated:NO];
//    
//    
//    
//    
//}



@end
