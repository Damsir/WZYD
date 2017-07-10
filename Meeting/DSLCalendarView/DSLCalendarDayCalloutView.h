/*
 DSLCalendarDayCalloutView.h
 
 Copyright (c) 2012 Dative Studios. All rights reserved.
 
 */
#import <UIKit/UIKit.h>


@interface DSLCalendarDayCalloutView : UIView

// Designated initialisers
+ (id)view;
- (id)initWithFrame:(CGRect)frame;

- (void)configureForDay:(NSDateComponents*)day;

@end
