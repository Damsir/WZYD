//
//  DamCalendarItem.m
//  DamCalendar
//
//  Created by 吴定如 on 16/8/5.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "DamCalendarItem.h"
#import "MeetingModel.h"

@interface DamCalendarItem ()

{
    CGFloat itemW ;
    CGFloat itemH ;
}

@property(nonatomic,strong) UIButton *selectButton;//选择某一天
@property(nonatomic,strong) NSMutableArray *daysArray;//天数
@property(nonatomic,strong) NSMutableArray *dataArray;//数据源
@property(nonatomic,strong) NSMutableArray *meetingArray;//会议记录
@property(nonatomic,strong) NSMutableArray *selectDayMeetingArr;//当天会议数组
@property(nonatomic,assign) NSInteger todayButtonDate;//今天的日期


@end

@implementation DamCalendarItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadDataSource];
        _daysArray = [NSMutableArray arrayWithCapacity:42];
        for (int i = 0; i < 42; i++) {
            UIButton *button = [[UIButton alloc] init];
            [self addSubview:button];
            [_daysArray addObject:button];
        }
    }
    return self;
}
-(void)loadDataSource
{
    _selectDayMeetingArr = [NSMutableArray array];
    _meetingArray = [NSMutableArray array];
    _dataArray = [NSMutableArray arrayWithObjects:@"2016-08-08",@"2016-08-01",@"2016-08-16",@"2016-07-07",@"2016-09-09", nil];
}

#pragma mark - date

- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}


- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}

- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}


- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:2];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [components setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:components];
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}
//当前月份的天数
- (NSInteger)totaldaysInMonth:(NSDate *)date{
    
    NSRange daysInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInOfMonth.length;
}

- (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

- (NSDate *)nextMonth:(NSDate *)date{
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

- (NSDate *)nextYear:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

#pragma mark - createCalendarItem

- (void)setDate:(NSDate *)date{
    _date = date;
    [self createCalendarViewWith:date];
}

- (void)createCalendarViewWith:(NSDate *)date{
    
//    NSLog(@"meetingData_item:%@",_meetingData);
    if (_meetingArray.count) {
        //移除数组数据是不能用for..in..(线程错误)
        for (NSInteger i=_meetingArray.count-1; i>=0; i--)
        {
            UIImageView *imageV = _meetingArray[i];
            [imageV removeFromSuperview];
            [_meetingArray removeObjectAtIndex:i];
        }
    }
    itemW   = self.frame.size.width / 7;
    itemH   = self.frame.size.height / 6;
    
    //当前年月
    NSInteger year = [self year:date];
    NSInteger month  = [self month:date];
    if (_currentDateBlock) {
        _currentDateBlock(year,month);
    }
//    NSLog(@"当前日期item->year:%ld,month:%ld",(long)year,(long)month);
//    NSLog(@"current->year:%ld,month:%ld",(long)year,(long)month);
    
    //  3.日 (1-31)
    for (int i = 0; i < 42; i++) {
        
        CGFloat x = (i % 7) * itemW+1;
        CGFloat y = (i / 7) * itemH+1;
        UIButton *dayButton = _daysArray[i];
        //dayButton.backgroundColor = [UIColor orangeColor];
        dayButton.frame = CGRectMake(x, y, itemW-1, itemH-1);
        dayButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        dayButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [dayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [dayButton addTarget:self action:@selector(selectedDate:) forControlEvents:UIControlEventTouchUpInside];
        // 初始化状态
        [self setOriginStyle:dayButton];
        
        NSInteger daysInLastMonth = [self totaldaysInMonth:[self lastMonth:date]];
        NSInteger daysInThisMonth = [self totaldaysInMonth:date];
        NSInteger firstWeekday    = [self firstWeekdayInThisMonth:date];
        
        NSInteger day = 0;
        
        //        NSLog(@"selectMonth: %ld,nowMonth:%ld",(long)[self month:date],(long)[self month:[NSDate date]]);
        //        NSLog(@"selectYear:%ld,nowYear:%ld",(long)[self year:date],(long)[self year:[NSDate date]]);
        // 本月
        if ([self month:date] == [self month:[NSDate date]] && [self year:date] == [self year:[NSDate date]]) {
            
            
            NSInteger todayIndex = [self day:[NSDate date]] + firstWeekday - 1;
            if (i < todayIndex && i >= firstWeekday) {
                //  本月 当天之前 不可选
                //                [self setStyleBeforeToday:dayButton];
                
            }else if(i == todayIndex){
                //  当天  变色
                [self setStyleToday:dayButton];
            }
        }
        //不是当月取消选中
        else
        {
            [self setCancleStyleToday:dayButton];
        }
        
        //判断是当月(视图中显示的月份)还是其他月份(上下月)
        if (i < firstWeekday)
        {
            day = daysInLastMonth - firstWeekday + i + 1;
            [dayButton setTitle:[NSString stringWithFormat:@"%ld", (long)day] forState:UIControlStateNormal];
            [self setStyleBeyondThisMonth:dayButton];
            
        }
        else if (i > firstWeekday + daysInThisMonth - 1)
        {
            day = i + 1 - firstWeekday - daysInThisMonth;
            [dayButton setTitle:[NSString stringWithFormat:@"%ld", (long)day] forState:UIControlStateNormal];
            [self setStyleBeyondThisMonth:dayButton];
            
        }
        else
        {
            day = i - firstWeekday + 1;
            [dayButton setTitle:[NSString stringWithFormat:@"%ld", (long)day] forState:UIControlStateNormal];
            [self setStyleThisMonth:dayButton];
            // 选择的日期 高亮
            if ([self year:date] == self.currentYear && [self month:date] == self.currentMonth && day == self.currentDay && dayButton.enabled == YES)
            {
                _selectButton = dayButton;
                //[self setStyleSeletedToday:dayButton];
            }
        }
        
    }
}


#pragma mark - output date
//初始状态
-(void)setOriginStyle:(UIButton *)dayBtn
{
    dayBtn.enabled = YES;
    [self setCancleStyleToday:dayBtn];
    [dayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    dayBtn.backgroundColor = [UIColor whiteColor];
}

//选择某一天
-(void)selectedDate:(UIButton *)dayBtn
{
    //每次进来先移除原先数组的会议数据,否则数据叠加
    [_selectDayMeetingArr removeAllObjects];
    
    [self setCancleStyleToday:_selectButton];
    _selectButton = dayBtn;
    [self setStyleSeletedToday:dayBtn];
    
    NSInteger day = 0;
    if ([[dayBtn titleForState:UIControlStateNormal] isEqualToString:@"今天"])
    {
        day = _todayButtonDate;
    }
    else
    {
        day = [[dayBtn titleForState:UIControlStateNormal] integerValue];
    }
    
    _selectedDay = day;
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.date];
    _selectedMonth = [comp month];
    _selectedYear = [comp year];
    
    NSString *dateString = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)_selectedYear,(long)_selectedMonth,(long)_selectedDay];
    // NSLog(@"dateString::%@",dateString);
    for (int i=0; i<_meetingData.count; i++)
    {
        MeetingModel *model = _meetingData[i];
        NSString *meetingTime = model.start;
        meetingTime = [meetingTime substringToIndex:10];
        
        if ([dateString isEqualToString:meetingTime])
        {
            //将选择的当天会议数据存储起来
            [_selectDayMeetingArr addObject:model];
           // NSLog(@"selectDayMeetingArr::%@",_selectDayMeetingArr);

        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(seletedOneDay: withMonth: withYear: withDayMeetingArray:)])
    {
        [self.delegate seletedOneDay:day withMonth:[comp month] withYear:[comp year] withDayMeetingArray:_selectDayMeetingArr];
    }
    
    
    
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否添加会议" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    //[alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    }
    else if (buttonIndex == 1)
    {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_selectButton.frame)-itemW/5, 20, itemW/5, 20)];
        imageV.image = [UIImage imageNamed:@"calendar_bg_tag"];
        [_selectButton addSubview:imageV];
        //添加会议
        [_meetingArray addObject:imageV];
        NSInteger year = [self year:_date];
        NSInteger month = [self month:_date];
        NSInteger day = [[_selectButton titleForState:UIControlStateNormal] integerValue];
        NSString *dateString = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)year,(long)month,(long)day];
        [_dataArray addObject:dateString];
    }
}

#pragma mark - date button style
//本月之后，不可选日期
- (void)setStyleBeyondThisMonth:(UIButton *)btn
{
    btn.enabled = NO;
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}
//本月之前，不可选日期
- (void)setStyleBeforeToday:(UIButton *)btn
{
    btn.enabled = NO;
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}
//今天
- (void)setStyleToday:(UIButton *)btn
{
    btn.enabled = YES;
    _selectButton = btn;
    [self setCancleStyleToday:_selectButton];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //btn.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    btn.backgroundColor = BLUECOLOR;

}
//今天 选择的日期 -- 背景颜色和字体颜色改变
- (void)setStyleSeletedToday:(UIButton *)btn
{
    btn.enabled = YES;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    //btn.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    btn.backgroundColor = BLUECOLOR;
}
//取消 选择
- (void)setCancleStyleToday:(UIButton *)btn
{
    btn.enabled = YES;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [btn setBackgroundColor:[UIColor whiteColor]];
}
//当月日期
- (void)setStyleThisMonth:(UIButton *)btn
{
    btn.enabled = YES;
    //[btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    NSInteger year = [self year:_date];
    NSInteger month = [self month:_date];
    
    // 如果是今天 设置&&保存今天的日期
    if ([self month:_date] == [self month:[NSDate date]] && [self year:_date] == [self year:[NSDate date]])
    {
        NSInteger todayIndex = [self day:[NSDate date]];
        if (todayIndex == [[btn titleForState:UIControlStateNormal] integerValue])
        {
            [btn setTitle:@"今天" forState:UIControlStateNormal];
            //将今天的日期保存起来
            _todayButtonDate = todayIndex;
        }
    }
    
    NSInteger day = 0;
    if ([[btn titleForState:UIControlStateNormal] isEqualToString:@"今天"])
    {
        day = _todayButtonDate;
    }
    else
    {
        day = [[btn titleForState:UIControlStateNormal] integerValue];
    }
   // NSLog(@"year:%ld month:%ld day::%ld",(long)year,(long)month ,(long)day);
    
    NSString *dateString = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)year,(long)month,(long)day];
    // NSLog(@"dateString::%@",dateString);
    for (int i=0; i<_meetingData.count; i++)
    {
        MeetingModel *model = _meetingData[i];
        NSString *meetingTime = model.start;
        meetingTime = [meetingTime substringToIndex:10];
        
        if ([dateString isEqualToString:meetingTime])
        {
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(itemW-10, 30, 10, 10)];
            imageV.image = [UIImage imageNamed:@"calendar_bg_tag"];
            [btn addSubview:imageV];
            [_meetingArray addObject:imageV];
        
            
            
//            [btn setImage:[UIImage imageNamed:@"calendar_bg_tag"] forState:UIControlStateNormal];
//            if (MainR.size.width >= 768) {
//                CGFloat leftEdge_title = itemW/5;
//                CGFloat leftEdge_image = itemW*4/5;
//                //[dayBtn setImage:[UIImage imageNamed:@"calendar_bg_tag"] forState:UIControlStateNormal];
//                btn.imageEdgeInsets = UIEdgeInsetsMake(20, leftEdge_image, 0, 0);
//                btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, leftEdge_title);
//            }
//            else
//            {
//                CGFloat leftEdge_title = itemW/2;
//                CGFloat leftEdge_image = itemW*3/4;
//                if (MainR.size.width == 320) {
//                    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -leftEdge_title-6, 0, 0);
//                }else if (MainR.size.width == 375){
//                    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -leftEdge_title-4, 0, 0);
//                }else if (MainR.size.width == 414){
//                    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -leftEdge_title-1, 0, 0);
//                }else
//                {
//                    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -leftEdge_title+25, 0, 0);
//                }
//                // btn.titleEdgeInsets = UIEdgeInsetsMake(0, -leftEdge_title-2, 0, 0);
//                btn.imageEdgeInsets = UIEdgeInsetsMake(20, leftEdge_image, 0, 0);
//            }
            
            
        }
    }
}

- (void)lastYearBtnOnclick
{
    [self.delegate yearOnclick:0];
}

- (void)lastMonthBtnOnclick
{
    [self.delegate monthOnclick:0];
}

- (void)nextMonthBtnOnclick
{
    [self.delegate monthOnclick:1];
}

- (void)nextYearBtnOnclick
{
    [self.delegate yearOnclick:1];
}

#pragma mark - Public

// 获取date的下个月日期
- (NSDate *)nextMonthDate {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = 1;
    NSDate *nextMonthDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self.date options:NSCalendarMatchStrictly];
    return nextMonthDate;
}

// 获取date的上个月日期
- (NSDate *)previousMonthDate {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = -1;
    NSDate *previousMonthDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self.date options:NSCalendarMatchStrictly];
    return previousMonthDate;
}


-(void)screenRotation
{
    itemW   = self.frame.size.width / 7;
    itemH   = self.frame.size.height / 6;
    
    for (int i = 0; i < 42; i++)
    {
        CGFloat x = (i % 7) * itemW+1;
        CGFloat y = (i / 7) * itemH+1 ;
        UIButton *dayButton = _daysArray[i];
        dayButton.frame = CGRectMake(x, y, itemW-1, itemH-1);
    }
//    for (UIButton *dayBtn in _dutyArray) {
//        CGFloat leftEdge_title = itemW/5;
//        CGFloat leftEdge_image = itemW*4/5;
//        //[dayBtn setImage:[UIImage imageNamed:@"calendar_bg_tag"] forState:UIControlStateNormal];
//        dayBtn.imageEdgeInsets = UIEdgeInsetsMake(20, itemW/2, 0, 0);
//        dayBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//    }
    for (UIImageView *imageV in _meetingArray)
    {
        imageV.frame = CGRectMake(itemW-10, 30, 10, 10);
    }
   // NSLog(@"dutyArray_rotation:%@",_dutyArray);
}

@end
