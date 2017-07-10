//
//  DamCalendarView.m
//  DamCalendar
//
//  Created by 吴定如 on 16/8/5.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "MeetingCalendarView.h"
#import "MyDatePicker.h"

#define Weekdays @[@"周一", @"周二", @"周三", @"周四", @"周五", @"周六",@"周日"]

static NSDateFormatter *dateFormattor;

@interface MeetingCalendarView()

{
    CGFloat itemW;
    CGFloat itemH;
}
@property(nonatomic,strong) MeetingCalendarItem *calendarItem;
@property(nonatomic,strong) UIScrollView *scrollView;
@property(strong,nonatomic) MeetingCalendarItem *leftCalendarItem;
@property(strong,nonatomic) MeetingCalendarItem *centerCalendarItem;
@property(strong,nonatomic) MeetingCalendarItem *rightCalendarItem;
@property(nonatomic,strong) NSMutableArray *weeksArray;
@property(nonatomic,strong) UIView *weekBg;
@property(nonatomic,strong) UIView *dateBackView;
@property(nonatomic,strong) UIButton *dateSelectBtn;
@property(nonatomic,strong) NSMutableArray *weekNumberArr;
@property(nonatomic,strong) UIView *weekNumber;
@property(nonatomic,assign) NSInteger year;
@property(nonatomic,assign) NSInteger month;
@property(nonatomic,strong) MyDatePicker *datePicker;
@property(nonatomic,strong) NSMutableArray *lineArray_h;
@property(nonatomic,strong) NSMutableArray *lineArray_v;

@end

@implementation MeetingCalendarView

- (instancetype)initWithFrame:(CGRect)frame withMeetingData:(NSArray *)meetingData
{
    self = [super initWithFrame:frame];
    if (self) {
        _meetingData = meetingData;
        self.backgroundColor = [UIColor clearColor];
        [self initCalendarView];
        [self createCalendarItems];
    }
    return self;
}
// 设置包含3个日历的item的scrollView
- (void)initCalendarView
{
    //日历的宽&高
    itemW   = self.frame.size.width / 7;
    itemH   = 40.0;
    //获取当前年月
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    NSString *monthStr = [dateFormatter stringFromDate:[NSDate date]];
    _month = [monthStr integerValue];
    [dateFormatter setDateFormat:@"yyyy"];
    monthStr = [dateFormatter stringFromDate:[NSDate date]];
    _year = [monthStr integerValue];
   
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    if (MainR.size.width<375) {
        self.scrollView.frame = CGRectMake(0, 45+itemH, self.frame.size.width, itemH*6);
    }
    else
    {
        self.scrollView.frame = CGRectMake(0, 75+itemH, self.frame.size.width, itemH*6);
    }
    
    self.scrollView.contentSize = CGSizeMake(3 * self.frame.size.width, itemH*6);
    self.scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
    [self addSubview:self.scrollView];
    
    //星期
    UIView *weekBg = [[UIView alloc] init];
//    weekBg.backgroundColor = GRAYCOLOR;
//    weekBg.backgroundColor = [UIColor colorWithWhite:0.392 alpha:1.000];
    weekBg.backgroundColor = [UIColor whiteColor];
    if (MainR.size.width<375) {
        weekBg.frame = CGRectMake(0, 45, itemW*7, itemH);
    }
    else
    {
        weekBg.frame = CGRectMake(0, 75, itemW*7, itemH);

    }
    _weekBg = weekBg;
    [self addSubview:weekBg];
    _weeksArray = [NSMutableArray array];
    for (int i = 0; i < 7; i++) {
        UILabel *week = [[UILabel alloc] init];
        week.text = Weekdays[i];
        if (MainR.size.width<375) {
            week.font = [UIFont systemFontOfSize:13];
        }
        else
        {
            week.font = [UIFont systemFontOfSize:14];
        }
        week.frame = CGRectMake(itemW*i, 0, itemW, itemH);
        week.textAlignment = NSTextAlignmentCenter;
        week.backgroundColor = [UIColor clearColor];
        week.textColor = [UIColor colorWithRed:0.986 green:0.000 blue:0.027 alpha:1.000];
        [weekBg addSubview:week];
        [_weeksArray addObject:week];
    }
    //横线
    _lineArray_h = [NSMutableArray array];
    for (int i=0; i<8; i++) {
        UIView *line_h = [[UIView alloc] init];
        if (MainR.size.width<375) {
            line_h.frame = CGRectMake(0, 45+i*itemH, self.frame.size.width, 1);
        }
        else
        {
            line_h.frame = CGRectMake(0, 75+i*itemH, self.frame.size.width, 1);
        }
        
        line_h.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
        [self addSubview:line_h];
        [_lineArray_h addObject:line_h];
    }
    //竖线
    _lineArray_v = [NSMutableArray array];
    for (int i=0; i<8; i++) {
        
        UIView *line_v = [[UIView alloc] init];
        if (MainR.size.width<375) {
            line_v.frame = CGRectMake(i*itemW, 45, 1, itemH*7);
        }
        else
        {
            line_v.frame = CGRectMake(i*itemW, 75, 1, itemH*7);
        }
        
        line_v.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];;
        [self addSubview:line_v];
        [_lineArray_v addObject:line_v];
    }
    //日期选择
    UIView *dateBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 30)];
    _dateBackView = dateBackView;
    dateBackView.center = CGPointMake(MainR.size.width/2, 15);
    [self addSubview:dateBackView];
    
    UIButton *dateSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dateSelectBtn.frame = CGRectMake(60,0,130,30);
    dateSelectBtn.layer.borderWidth = 1;
    dateSelectBtn.layer.borderColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1].CGColor;
    [dateSelectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    dateSelectBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [dateSelectBtn addTarget:self action:@selector(dateSelected) forControlEvents:UIControlEventTouchUpInside];
    _dateSelectBtn = dateSelectBtn;
    [dateBackView addSubview:dateSelectBtn];
    
    //    上一月 按钮
    UIButton *lastMonthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    lastMonthBtn.frame = CGRectMake(0, 0, 30, 30);
    [lastMonthBtn setImage:[UIImage imageNamed:@"zuosanjiao"] forState:UIControlStateNormal];
    lastMonthBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 8, 5, 8);
    [lastMonthBtn addTarget:self action:@selector(previousMonthDateClick) forControlEvents:UIControlEventTouchUpInside];
    [dateBackView addSubview:lastMonthBtn];
    //    下一月 按钮
    UIButton *nextMonthBtn = [[UIButton alloc]initWithFrame:CGRectMake(220, 0, 30, 30)];
    [nextMonthBtn setImage:[UIImage imageNamed:@"yousanjiao"] forState:UIControlStateNormal];
    nextMonthBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 8, 5, 8);
    [nextMonthBtn addTarget:self action:@selector(nextMonthDateClick) forControlEvents:UIControlEventTouchUpInside];
    [dateBackView addSubview:nextMonthBtn];
    
}

// 设置3个日历的item
-(void)createCalendarItems
{
    //NSLog(@"meetingData_View:%@",_meetingData);
    self.leftCalendarItem = [[MeetingCalendarItem alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, itemH*6)];
    [self.scrollView addSubview:self.leftCalendarItem];
    
    self.centerCalendarItem = [[MeetingCalendarItem alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, itemH*6)];
    self.centerCalendarItem.meetingData = _meetingData;
    self.centerCalendarItem.delegate = self;
    _centerCalendarItem.currentDay     = _currentDay;
    _centerCalendarItem.currentMonth   = _currentMonth;
    _centerCalendarItem.currentYear    = _currentYear;
    [self.scrollView addSubview:self.centerCalendarItem];
    
    self.rightCalendarItem = [[MeetingCalendarItem alloc] initWithFrame:CGRectMake(2*self.frame.size.width, 0, self.frame.size.width, itemH*6)];
    [self.scrollView addSubview:self.rightCalendarItem];
    //创建日期
    [self createCurrentDate:[NSDate date]];
}

-(void)screenRotation
{
    itemW   = self.frame.size.width / 7;
    itemH   = 40.0;
    if (MainR.size.width<375) {
        self.scrollView.frame = CGRectMake(0, 45+itemH, self.frame.size.width, itemH*6);
    }
    else
    {
        self.scrollView.frame = CGRectMake(0, 75+itemH, self.frame.size.width, itemH*6);
    }
    self.scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
    self.scrollView.contentSize = CGSizeMake(3 * self.frame.size.width, itemH*6);
    //self.scrollView.backgroundColor = [UIColor orangeColor];

    self.leftCalendarItem.frame=CGRectMake(0, 0, self.frame.size.width, itemH*6);
    self.centerCalendarItem.frame =CGRectMake(self.frame.size.width, 0, self.frame.size.width, itemH*6);
    self.rightCalendarItem.frame=CGRectMake(2*self.frame.size.width, 0, self.frame.size.width, itemH*6);
    
    [self.centerCalendarItem screenRotation];
    [self.leftCalendarItem screenRotation];
    [self.rightCalendarItem screenRotation];
    
    //横线&&竖线
    for (int i=0; i<_lineArray_v.count; i++) {
        UILabel *line_v = _lineArray_v[i];
        if (MainR.size.width<375) {
            line_v.frame = CGRectMake(i*itemW, 45, 1, itemH*7);
        }
        else
        {
            line_v.frame = CGRectMake(i*itemW, 75, 1, itemH*7);
        }
    }
    
    for (int i=0; i<_lineArray_h.count; i++) {
        UILabel *line_h = _lineArray_h[i];
        if (MainR.size.width<375) {
            line_h.frame = CGRectMake(0, 45+i*itemH, self.frame.size.width, 1);
        }
        else
        {
            line_h.frame = CGRectMake(0, 75+i*itemH, self.frame.size.width, 1);
        }
    }
    
    //日期
    _dateBackView.center = CGPointMake(MainR.size.width/2, 15);
    //星期
    if (MainR.size.width<375)
    {
        _weekBg.frame = CGRectMake(0, 45, itemW*7, itemH);
    }
    else
    {
        _weekBg.frame = CGRectMake(0, 75, itemW*7, itemH);
    }
    for (int i = 0; i < _weeksArray.count; i++)
    {
        UILabel *week = _weeksArray[i];
        week.frame = CGRectMake(itemW*i, 0, itemW, itemH);
    }
    
    _datePicker.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height);
    [_datePicker screenRotation];
}
#pragma mark -- datePickerView
//日期点击加载日期选择框
-(void)dateSelected
{
    MyDatePicker *datePicker = [[MyDatePicker alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, MainR.size.height)];
    _datePicker = datePicker;
    [datePicker showInView:self.window.rootViewController.view animated:YES];
    
    __weak typeof (*&self)weakSelf = self;
    _datePicker.dateSelectBlock = ^(NSInteger year,NSInteger month)
    {
        _year = year;
        _month = month;
        [weakSelf createNewCalendar];
        //更新选择的日期显示
        [weakSelf updateDateBtnTitle];
        
    };
}

-(void)updateDateBtnTitle
{
    NSString *date = [NSString stringWithFormat:@"%ld年  %02ld月",(long)_year,(long)_month];
    [_dateSelectBtn setTitle:date forState:UIControlStateNormal];
}
//根据选定的日期更新日历
-(void)createNewCalendar
{
    if (!_centerCalendarItem) {
        self.centerCalendarItem.frame =CGRectMake(self.frame.size.width, 0, self.frame.size.width, itemH*6);
        
        [self addSubview:_centerCalendarItem];
    }
    
    _centerCalendarItem.currentYear = _year;
    _centerCalendarItem.currentMonth = _month;
    _centerCalendarItem.currentDay = 1;
     NSLog(@"year:%ld,month:%ld",(long)_year,(long)_month);
    _centerCalendarItem.delegate = self;
    
    NSString *dateStr = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)_centerCalendarItem.currentYear,(long)_centerCalendarItem.currentMonth,(long)_centerCalendarItem.currentDay];
    if (!dateFormattor) {
        dateFormattor = [[NSDateFormatter alloc] init];
    }
    dateFormattor.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [dateFormattor dateFromString:dateStr];
    [self createCurrentDate:date];
    
}

#pragma mark 加载数据
- (void)createCurrentDate:(NSDate *)date
{
    if (!dateFormattor) {
        dateFormattor = [[NSDateFormatter alloc] init];
    }
    [dateFormattor setDateFormat:@"yyyy年  MM月"];
    [self.dateSelectBtn setTitle:[dateFormattor stringFromDate:date] forState:UIControlStateNormal];
    // 三个item
    self.centerCalendarItem.date = date;
    // NSLog(@"date:%@",date);
    self.leftCalendarItem.date = [self.centerCalendarItem previousMonthDate];
    self.rightCalendarItem.date = [self.centerCalendarItem nextMonthDate];
    
}

#pragma mark -- scrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_scrollView == scrollView) {
        [self reloadCalendarItems];
    }
    
}
// 重新加载日历items的数据
- (void)reloadCalendarItems {
    
    CGPoint offset = self.scrollView.contentOffset;

    if (offset.x == self.scrollView.frame.size.width) { //防止滑动一点点并不切换scrollview的视图
        return;
    }else if (offset.x > self.frame.size.width) {
        [self nextMonthDateClick];//下个月
    }else  if(offset.x < self.frame.size.width){
        [self previousMonthDateClick];//上个月
    }
    self.scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
}


#pragma mark - SEL

// 跳到上一个月
- (void)previousMonthDateClick {
    
    //NSLog(@"previouMonth:%@",[self.centerCalendarItem previousMonthDate]);
    [self createCurrentDate:[self.centerCalendarItem previousMonthDate]];
}

// 跳到下一个月
- (void)nextMonthDateClick {
    [self createCurrentDate:[self.centerCalendarItem nextMonthDate]];
}
#pragma mark 计算日期
- (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

- (NSDate*)nextMonth:(NSDate *)date{
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

- (NSDate *)lastYear:(NSDate *)date{
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

- (NSDate*)nextYear:(NSDate *)date{
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

#pragma mark action
- (void)seletedOneDay:(NSInteger)day withMonth:(NSInteger)month withYear:(NSInteger)year withDayMeetingArray:(NSArray *)dayMeetingArray
{
    NSLog(@"selectedDate->year:%ld,month:%02ld day:%02ld",(long)year,(long)month,(long)day);

    [self.delegate seletedOneDay:day withMonth:month withYear:year withDayMeetingArray:dayMeetingArray];
}

- (void)monthOnclick:(NSInteger)lastOrNext
{
    if (lastOrNext) {
        
    }else{
        
    }
    [self.delegate monthOnclick:lastOrNext];
}

- (void)yearOnclick:(NSInteger)lastOrNext
{
    NSDate *date ;
    if (lastOrNext) {
        [self createCurrentDate: [self nextYear:date]];
    }else{
        [self createCurrentDate: [self lastYear:date]];
    }
    [self.delegate yearOnclick:lastOrNext];
}


@end
