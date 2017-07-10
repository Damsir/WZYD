//
//  MeetingRoomViewController.m
//  WZYD
//
//  Created by 吴定如 on 16/11/17.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "MeetingRoomViewController.h"
#import "AFNetworking.h"
#import "Global.h"
#import "MeetingCalendarView.h"
#import "MeetingRoomModel.h"
#import "RoomDetailViewController.h"
#import "MBProgressHUD+MJ.h"

static NSDateFormatter *dateFormattor;

@interface MeetingRoomViewController ()<UINavigationControllerDelegate,DamCalendarItemDelegate>


@property (nonatomic, strong)  MeetingCalendarView *calendarView;

// 存放所有会议数据
@property (nonatomic,strong) NSMutableArray *meetingData;
// 会议起止时间
@property (nonatomic,strong) NSString *startDate;

@end

@implementation MeetingRoomViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   // [self loadMyDataAndInitCalendarView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //self.title=@"会议安排";
    [self initNavigationBarTitle:@"会议安排"];
    
    [self loadMyDataAndInitCalendarView];
    
    //监听屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)screenRotation
{
    CGFloat itemH = 40.0;
    if (MainR.size.width<375) {
        _calendarView.frame = CGRectMake(5, 15, MainR.size.width-10, itemH*7+45);
    }
    else
    {
        _calendarView.frame = CGRectMake(5, 45, MainR.size.width-10, itemH*7+75);
    }
    [_calendarView screenRotation];
}

// 加载会议数据
- (void)loadMyDataAndInitCalendarView
{
    // 会议起止时间
    if (!dateFormattor)
    {
        dateFormattor = [[NSDateFormatter alloc] init];
    }
    [dateFormattor setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate date];
    NSString *startDate = [dateFormattor stringFromDate:date];
    _startDate = startDate;
    //会议数组
    _meetingData = [NSMutableArray array];
    
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];

    NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/meeting/meetingList.ashx"];
    NSDictionary *paremeters = @{@"type":@"search",@"roomName":@"",@"proposer":@"",@"start":_startDate,@"end":@""};
    
    // 发送会议室数据请求
    [manager POST:url parameters:paremeters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //加载提示框
         [MBProgressHUD hideHUDForView:self.view animated:NO];
         
         if ([[responseObject objectForKey:@"success"] isEqual:@1])
         {
             for (NSDictionary *dict in [responseObject objectForKey:@"result"])
             {
                 MeetingRoomModel *model = [[MeetingRoomModel alloc] initWithDictionary:dict];
                 
                 [_meetingData addObject:model];
             }
         }
         else
         {
             [MBProgressHUD showError:@"会议加载失败"];
         }
         
         if (!_calendarView)
         {
             CGFloat itemH = 40.0;
             //初始化一个我的值班日历
             if (MainR.size.width<375)
             {
                 _calendarView = [[MeetingCalendarView alloc] initWithFrame:CGRectMake(5, 15, MainR.size.width-10, itemH*7+45) withMeetingData:_meetingData];
             }
             else
             {
                 _calendarView = [[MeetingCalendarView alloc] initWithFrame:CGRectMake(5, 45, MainR.size.width-10, itemH*7+75) withMeetingData:_meetingData];
             }
             
             _calendarView.delegate = self;
             [self.view addSubview:_calendarView];
             
         }
         
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         //加载提示框
         [MBProgressHUD hideHUDForView:self.view animated:NO];
         [MBProgressHUD showError:@"会议加载失败"];
         if (!_calendarView)
         {
             CGFloat itemH = 40.0;
             //初始化一个我的值班日历
             if (MainR.size.width<375)
             {
                 _calendarView = [[MeetingCalendarView alloc] initWithFrame:CGRectMake(5, 15, MainR.size.width-10, itemH*7+45) withMeetingData:_meetingData];
             }
             else
             {
                 _calendarView = [[MeetingCalendarView alloc] initWithFrame:CGRectMake(5, 45, MainR.size.width-10, itemH*7+75) withMeetingData:_meetingData];
             }
             
             _calendarView.delegate = self;
             [self.view addSubview:_calendarView];
             
         }
         
     }];
}


#pragma mark -- 日期选择点击方法 delegateMethods
- (void)seletedOneDay:(NSInteger)day withMonth:(NSInteger)month withYear:(NSInteger)year withDayMeetingArray:(NSArray *)dayMeetingArray
{
    //NSLog(@"selectDayMeetingArr_controller::%@",dayMeetingArray);
    //NSLog(@"%ld-%ld-%ld",(long)year,(long)month,(long)day);
    
    if (dayMeetingArray.count)
    {
        RoomDetailViewController *meetingDetailVC = [[RoomDetailViewController alloc] init];
        meetingDetailVC.hidesBottomBarWhenPushed = YES;
        meetingDetailVC.meetingArray = [NSMutableArray arrayWithArray:dayMeetingArray];
        [self.navigationController pushViewController:meetingDetailVC animated:YES];
    
    }
    
}

// customButton
-(UIButton *)createButtonWithTitle:(NSString *)title andFrame:(CGRect)frame Tag:(NSInteger)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = BLUECOLOR;
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    button.layer.cornerRadius = 2;
    button.clipsToBounds = YES;
    // 按钮对齐方式设置
    button.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    button.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    button.titleLabel.font = [UIFont systemFontOfSize:14.5];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.tag = tag;
    
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [button addTarget:self action:@selector(addMeeting) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

@end
