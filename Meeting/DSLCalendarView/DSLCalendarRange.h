/*
 DSLCalendarRange.h
 
 Copyright (c) 2012 Dative Studios. All rights reserved.
 
 
 */
#import <UIKit/UIKit.h>


@interface DSLCalendarRange : NSObject

@property (nonatomic, copy) NSDateComponents *startDay;
@property (nonatomic, copy) NSDateComponents *endDay;

@property (nonatomic,strong) NSArray *datas;

// Designated initialiser
- (id)initWithStartDay:(NSDateComponents*)start endDay:(NSDateComponents*)end;

- (BOOL)containsDay:(NSDateComponents*)day;
- (BOOL)containsDate:(NSDate*)date;

@end
