/*
 DSLCalendarDayView.h
 
 Copyright (c) 2012 Dative Studios. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 * Neither the name of the author nor the names of its contributors may be used
 to endorse or promote products derived from this software without specific
 prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


#import "DSLCalendarDayView.h"
#import "NSDate+DSLCalendarView.h"
#import "SHMeetingModel.h"
#import "SHMyMeetingModel.h"


@interface DSLCalendarDayView ()
{
}

@end


@implementation DSLCalendarDayView {
    __strong NSCalendar *_calendar;
    __strong NSDate *_dayAsDate;
    __strong NSDateComponents *_day;
    __strong NSString *_labelText;
    __strong UIImageView *_imageV;
    
}






#pragma mark - Initialisation

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        
        self.backgroundColor = [UIColor blackColor];
        _positionInWeek = DSLCalendarDayViewMidWeek;
    }
    
    return self;
}


#pragma mark Properties属性

- (void)setSelectionState:(DSLCalendarDayViewSelectionState)selectionState {
    _selectionState = selectionState;
    //setNeedsDisplay会调用自动调用drawRect方法
    [self setNeedsDisplay];
}

//set _day
- (void)setDay:(NSDateComponents *)day {
    _calendar = [day calendar];
    _dayAsDate = [day date];
    _day = nil;
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy" ];
    
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSInteger *curY =[[dateString substringToIndex:4] integerValue];
    NSInteger *curM = [[dateString substringWithRange:NSMakeRange(5, 2)] integerValue];
    
    NSInteger * curD = [[dateString substringWithRange:NSMakeRange(8, 2)] integerValue];
    
    _labelText= [NSString stringWithFormat:@"%ld", (long)day.day];
    
    
    NSString *str= [NSString stringWithFormat:@"%.2ld-%.2ld-%ld",day.day,day.month,day.year];
    
    NSString *str1 =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld",day.year,day.month,day.day];
    
    _need = NO;
   
    for (SHMyMeetingModel  *tmodel in _datasss) {
        if(iOS8)
        {
            if ([tmodel.meeting.starttime containsString:str1])
            {
            _need = YES;
            _state = tmodel.meeting.meetingstate;
            
        }
        }
        else
        {
            if([tmodel.meeting.starttime rangeOfString:str1].location !=NSNotFound)//
            {
                _need = YES;
                _state = tmodel.meeting.meetingstate;
                
                
            }}
        
    }
    if ([str isEqualToString:dateString]) {
        _labelText = @"今天";
        
        
        
    }
    
    
    
    
    
}

//get _day
- (NSDateComponents*)day {
    if (_day == nil) {
        _day = [_dayAsDate dslCalendarView_dayWithCalendar:_calendar];
    }
    
    return _day;
}

- (NSDate*)dayAsDate {
    return _dayAsDate;
    
}

//
- (void)setInCurrentMonth:(BOOL)inCurrentMonth {
    _inCurrentMonth = inCurrentMonth;
    [self setNeedsDisplay];
}


#pragma mark UIView methods

- (void)drawRect:(CGRect)rect {
    if ([self isMemberOfClass:[DSLCalendarDayView class]]) {
        // If this isn't a subclass of DSLCalendarDayView, use the default drawing
        [self drawBackground];
        [self drawBorders];
        [self drawDayNumber];
        
    }
}


#pragma mark Drawing

- (void)drawBackground {
    
    //如果日期是未选中状态
    if (self.selectionState == DSLCalendarDayViewNotSelected) {
        if (self.isInCurrentMonth) {//是当月
            
            [[UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1]setFill];
//            [[UIColor whiteColor] setFill];
        }
        else {
            [[UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1]setFill];
//            [[UIColor whiteColor ]setFill];
            
            
        }
        UIRectFill(self.bounds);
    }
    
    //iphone
    CGRect rect = CGRectMake(self.bounds.origin.x+38, self.bounds.origin.y +38, self.bounds.size.width -38, self.bounds.size.height-38);
    //plus
    CGRect rectp = CGRectMake(self.bounds.origin.x+38+12, self.bounds.origin.y +35, self.bounds.size.width -38, self.bounds.size.height-35);
    //ipad
    CGRect rect2ipad = CGRectMake(self.bounds.origin.x+self.bounds.size.width*4.0/5.0+10, self.bounds.origin.y+self.bounds.size.height*3.0/4.0+5, self.bounds.size.width/5.0-10, self.bounds.size.height/4.0-5);
    
    
    //未
    //iphone
    CGRect rect1 = CGRectMake(self.bounds.origin.x+5, self.bounds.origin.y+5, self.bounds.size.width-10, self.bounds.size.height-10);
    //plus
    CGRect rect1p = CGRectMake(self.bounds.origin.x+5+5, self.bounds.origin.y+5, self.bounds.size.width-20, self.bounds.size.height-10);
    //ipad
    CGRect rect2ipa =CGRectMake(self.bounds.origin.x+self.bounds.size.width*0.5-22, self.bounds.origin.y+4,  self.bounds.size.height, self.bounds.size.height-8);
 
    
    
    if (_need) {
        //    在指定位置画下角标
        if ([_state isEqualToString:@"1"]||[_state isEqualToString:@"2"]) {
            
            if (SCREEN_HEIGHT==736) {
                [[UIImage imageNamed:@"iconfont-weixuanzhong"] drawInRect:rect1p];

            }
            else if (MainR.size.width>414)
            {
                [[UIImage imageNamed:@"iconfont-weixuanzhong"] drawInRect:rect2ipa];

            
            }
            else
            {
                [[UIImage imageNamed:@"iconfont-weixuanzhong"] drawInRect:rect1];

            
            }
            
        }
        else
        {//已经开过的
            
            if (SCREEN_HEIGHT==736) {
                [[UIImage imageNamed:@"calendar_bg_tag"] drawInRect:rectp];
                
            } else if (MainR.size.width>414)
            {
                [[UIImage imageNamed:@"calendar_bg_tag"] drawInRect:rect2ipad];
                
                
            }
            else
            {[[UIImage imageNamed:@"calendar_bg_tag"] drawInRect:rect];
            }
        }
    }
    
    
    
    
    
}



- (void)drawBorders {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 0.2);
    
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:255.0/255.0 alpha:1.0].CGColor);
    CGContextMoveToPoint(context, 0.5, self.bounds.size.height - 0.5);
    CGContextAddLineToPoint(context, 0.5, 0.5);
    CGContextAddLineToPoint(context, self.bounds.size.width - 0.5, 0.5);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    
    if (self.isInCurrentMonth) {
        CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    }
    else {
        CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
        
    }
    CGContextMoveToPoint(context, self.bounds.size.width - 0.5, 0.0);
    CGContextAddLineToPoint(context, self.bounds.size.width - 0.5, self.bounds.size.height - 0.5);
    CGContextAddLineToPoint(context, 0.0, self.bounds.size.height - 0.5);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}






- (void)drawDayNumber {
    //DayNumber设置
    if (self.selectionState == DSLCalendarDayViewNotSelected) {
        //        [[UIColor colorWithWhite:66.0/255.0 alpha:1.0] set] ;
        
        if (self.isInCurrentMonth) {//是当月
            [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6] set];
        }
        else {
            [[UIColor lightGrayColor]set];
        }
    }
    else {
        [[UIColor whiteColor] set];
    }
    
    //    NSStrokeWidthAttributeName
    
    //设置文本属性
    UIFont *textFont = [UIFont systemFontOfSize:15.0];
    CGSize textSize = [_labelText sizeWithFont:textFont];
    //设置显示位置
    CGRect textRect = CGRectMake(ceilf(CGRectGetMidX(self.bounds) - (textSize.width / 2.0))+1, ceilf(CGRectGetMidY(self.bounds) - (textSize.height / 2.0)), textSize.width, textSize.height);
    
    if ([_labelText isEqualToString:@"今天"]) {
        
        NSMutableDictionary *dict =[NSMutableDictionary dictionary];
        [dict setValue:[UIColor redColor] forKey:NSForegroundColorAttributeName];
        [dict setValue:[UIFont systemFontOfSize:13.0] forKey:NSFontAttributeName];
        
        [_labelText drawInRect:textRect withAttributes: dict];
    }
//    else if([_state isEqualToString:@"1"])
//    {
//        NSMutableDictionary *dict =[NSMutableDictionary dictionary];
//        
//        [dict setValue:[UIFont systemFontOfSize:15.0] forKey:NSFontAttributeName];
//        [dict setValue:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
//        
//        [_labelText drawInRect:textRect withAttributes: dict];
//        
//    }
    else
    {
        
        //    //把文本属性画在指定位置
        [_labelText drawInRect:textRect withFont:textFont];
        
    }
    
//    if ([_state isEqualToString:@"2"]&&[_labelText isEqualToString:@"今天"]) {
//        NSMutableDictionary *dict =[NSMutableDictionary dictionary];
//        
//        [dict setValue:[UIFont systemFontOfSize:15.0] forKey:NSFontAttributeName];
//        [dict setValue:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
//        
//        [_labelText drawInRect:textRect withAttributes: dict];
//        
//    }
    
}





@end
