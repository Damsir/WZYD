//
//  MeetingViewController.m
//  XAYD
//
//  Created by dingru Wu on 15/8/3.
//  Copyright (c) 2015年 dist. All rights reserved.
//

#import "MeetingViewController.h"
#import "SHDayMDetaiController.h"
#import "SHMyMeetingModel.h"
#import "AFNetworking.h"
#import "SHMeetingModel.h"
#import "Global.h"
#import "DamCalendarView.h"
#import "MeetingModel.h"
#import "MeetingDetailController.h"
#import "AddMeetingViewController.h"
#import "MBProgressHUD+MJ.h"

static NSDateFormatter *dateFormattor;

@interface MeetingViewController ()<UINavigationControllerDelegate,DamCalendarItemDelegate>


@property (nonatomic, strong)  DamCalendarView *calendarView;

//存放所有数据模型
@property (nonatomic,strong) NSMutableArray *meetingData;
//存放我的数据模型
@property (nonatomic,strong) NSArray *myDatas;

@property (nonatomic, assign, getter = isJump) BOOL jump;

@property (nonatomic,strong) SHMyMeetingModel *meetingDetail;

@property (nonatomic,strong) NSString *state;
@property (nonatomic,strong) NSString *addMeetingDate;
@property (nonatomic,strong) NSString *startDate;


@property (nonatomic,assign)CGFloat wid;
@end

@implementation MeetingViewController


- (NSMutableArray *)subContentL
{
    if (_subContentL == nil) {
        _subContentL =[NSMutableArray array];
    }
    return _subContentL;
    
}
- (NSMutableArray *)subContentI
{
    if (_subContentI == nil) {
        _subContentI =[NSMutableArray array];
    }
    return _subContentI;
    
}
- (NSMutableArray *)subContentW

{
    if (_subContentW == nil) {
        _subContentW =[NSMutableArray array];
    }
    return _subContentW;
    
}

- (NSArray *)myDatas
{
    if (_myDatas == nil) {
        _myDatas = [NSArray array];
    }
    return _myDatas;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
   // self.title=@"日程";
    [self initNavigationBarTitle:@"日程"];
    
    static BOOL isFirst = YES;
    if (isFirst)
    {
        //加载提示框
        [MBProgressHUD showMessage:@"日程加载中" toView:self.view];
        //[MBProgressHUD showMessage:@"" toView:self.view];
    }

    [self loadMyDataAndInitCalendarView];
    
    
//    UIButton *addBtn = [self createButtonWithTitle:@"添加日程" andFrame:CGRectMake(0, 0, 70, 30) Tag:101];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加日程" style:UIBarButtonItemStylePlain target:self action:@selector(addMeeting)];
    
    
    self.view.backgroundColor =[UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1];
    
    
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

// 创建日历
-(void)createCalendar
{
    if (!_calendarView)
    {
        CGFloat itemH = 40.0;
        //初始化一个我的值班日历
        if (MainR.size.width<375)
        {
            _calendarView = [[DamCalendarView alloc] initWithFrame:CGRectMake(5, 15, MainR.size.width-10, itemH*7+45) withMeetingData:_meetingData];
        }
        else
        {
            _calendarView = [[DamCalendarView alloc] initWithFrame:CGRectMake(5, 45, MainR.size.width-10, itemH*7+75) withMeetingData:_meetingData];
        }
        //_calendarView.meetingData = _meetingData;
        _calendarView.delegate = self;
        [self.view addSubview:_calendarView];
    }
}

// 加载会议数据
- (void)loadMyDataAndInitCalendarView
{
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
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];

    NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/calendar/CalendarList.ashx"];
    NSDictionary *paremeters = @{@"type":@"event",@"start":_startDate,@"end":@"",@"uid":[Global userId],@"deviceNumber":[Global deviceUUID],@"username":[Global userName]};
   
    // 发送get请求
    [mgr GET:url parameters:paremeters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *JsonDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
         for (NSDictionary *subDict in [JsonDic objectForKey:@"result"])
         {
//             MeetingModel *model = [[MeetingModel alloc] init];
//             [model setValuesForKeysWithDictionary:subDict];
             MeetingModel *model = [[MeetingModel alloc] initWithDictionary:subDict];

             [_meetingData addObject:model];
         }
         
//         if (!_calendarView)
//         {
             CGFloat itemH = 40.0;
             //初始化一个我的值班日历
             if (MainR.size.width<375)
             {
                 _calendarView = [[DamCalendarView alloc] initWithFrame:CGRectMake(5, 15, MainR.size.width-10, itemH*7+45) withMeetingData:_meetingData];
             }
             else
             {
                 _calendarView = [[DamCalendarView alloc] initWithFrame:CGRectMake(5, 45, MainR.size.width-10, itemH*7+75) withMeetingData:_meetingData];
             }
             //_calendarView.meetingData = _meetingData;
            //[_calendarView loadCalendarMeetingData:_meetingData];
             _calendarView.delegate = self;
             [self.view addSubview:_calendarView];
//         }
         //加载提示框
         [MBProgressHUD hideHUDForView:self.view animated:NO];


     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if (!_calendarView)
         {
             CGFloat itemH = 40.0;
             //初始化一个我的值班日历
             if (MainR.size.width<375)
             {
                 _calendarView = [[DamCalendarView alloc] initWithFrame:CGRectMake(5, 15, MainR.size.width-10, itemH*7+45) withMeetingData:_meetingData];
             }
             else
             {
                 _calendarView = [[DamCalendarView alloc] initWithFrame:CGRectMake(5, 45, MainR.size.width-10, itemH*7+75) withMeetingData:_meetingData];
             }
             //_calendarView.meetingData = _meetingData;
             _calendarView.delegate = self;
             [self.view addSubview:_calendarView];
         }
         //加载提示框
         [MBProgressHUD hideHUDForView:self.view animated:NO];
         
     }];
}

#pragma mark -- 添加会议
-(void)addMeeting
{
    AddMeetingViewController *addVC = [[AddMeetingViewController alloc] init];
    addVC.addMeetingSuccessBlock = ^(BOOL isSuccess)
    {
        if (isSuccess) {
            [MBProgressHUD showSuccess:@"添加成功"];
            //[MBProgressHUD showMessage:@""];
            if (_calendarView) {
                [_calendarView removeFromSuperview];
            }
            //提前加载数据
            [self loadMyDataAndInitCalendarView];
        }
    };
    [self.navigationController pushViewController:addVC animated:YES];
}


#pragma mark -- 日期选择点击方法 delegateMethods
- (void)seletedOneDay:(NSInteger)day withMonth:(NSInteger)month withYear:(NSInteger)year withDayMeetingArray:(NSArray *)dayMeetingArray
{
    //NSLog(@"selectDayMeetingArr_controller::%@",dayMeetingArray);
    //NSLog(@"%ld-%ld-%ld",(long)year,(long)month,(long)day);
    
    if (dayMeetingArray.count)
    {
        MeetingDetailController *meetingDetailVC = [[MeetingDetailController alloc] init];
        meetingDetailVC.hidesBottomBarWhenPushed = YES;
        meetingDetailVC.meetingArray = [NSMutableArray arrayWithArray:dayMeetingArray];
        
        [self.navigationController pushViewController:meetingDetailVC animated:YES];
        // 编辑回调
        meetingDetailVC.editMeetingSuccessBlock = ^(BOOL isSuccess)
        {
            if (isSuccess) {
                
                if (_calendarView) {
                    [_calendarView removeFromSuperview];
                }
                //提前加载数据
                [self loadMyDataAndInitCalendarView];
            }
        };
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
