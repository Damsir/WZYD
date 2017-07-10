//
//  SHAgencyVController.m
//  distmeeting
//
//  Created by songdan Ye on 15/10/26.
//  Copyright (c) 2015年 dist. All rights reserved.
//

#import "SHAgencyVController.h"
#import "SHMeetingModel.h"
#import "SHMembers.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "NSString+Extension.h"
#define TextFont [UIFont systemFontOfSize:15]


@interface SHAgencyVController ()
@property (nonatomic,assign )BOOL finish;
//参会人员模型
@property (nonatomic,strong) NSArray *membersD;

@property (weak, nonatomic) IBOutlet UIImageView *lineImage;

@end

@implementation SHAgencyVController



- (instancetype)init
{
    if ( self =[super init]) {
        
    }
    
    return self;
    
}



-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    
    
}


-(void)loadData{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 创建一个参数字典
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    _meetingId = _dataS.meetingId;
    params[@"MeetingId"] =_meetingId ;
    // 发送get请求
    NSString *url = [NSString stringWithFormat:@"%@/DistMobile/mobileMeeting!getMeetingMembersIOS.action",DistMUrl];

    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) { // 请求成功的时候调用
        [MBProgressHUD hideHUDForView:self.view];
        self.meetContext.hidden = NO;
        self.meetSite.hidden = NO;
        self.meetTime.hidden = NO;
        self.meetAgency.hidden = NO;
        self.meetMember.hidden = NO;
        self.lineImage.hidden = NO;
        NSMutableArray *array =[NSMutableArray array];
        for (NSDictionary *subDict in responseObject) {
            //创建数据模型对象
            SHMembers *model = [[SHMembers alloc] init];
            [model initWithDict:subDict];
            //添加到数组中
            [array addObject:model];
            
        }
        
        _membersD = array;
        self.dataM =_membersD;
        [self setVales];
        
        
    }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         
         [MBProgressHUD showError:@"网络繁忙,请稍后再试!!!"toView:self.view ];
         
     }];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBarController.tabBar setHidden:YES];

    [self loadData];
    self.view.backgroundColor =[UIColor whiteColor];
    
//    [MBProgressHUD showMessage:@"正在加载agency"];
    [MBProgressHUD showMessage:@"正在加载"];

    
    self.meetContext.hidden = YES;
    self.meetSite.hidden = YES;
    self.meetTime.hidden = YES;
    self.meetAgency.hidden = YES;
    self.meetMember.hidden = YES;
    self.lineImage.hidden = YES;
    
    
    UILabel *title =[[UILabel alloc] init];
    [title setTextColor:[UIColor blackColor]];
    [title setTextAlignment:NSTextAlignmentCenter];
    [ self.meetingtitle1 setTextColor:[UIColor blackColor]];
    _meetingtitle1 = title;
    self.meetingtitle1.adjustsFontSizeToFitWidth =YES;
    
    [self.view addSubview:_meetingtitle1];
    CGFloat titleH =CGRectGetMaxY( _meetingtitle1.frame);
    
    
    self.agencySView.frame = CGRectMake(0, 10, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.agencySView.bounces = NO;
    self.agencySView.alwaysBounceVertical = YES;
    self.agencySView.delegate = self;
    self.agencySView.backgroundColor =[UIColor whiteColor];
    
//    self.lineImage.frame =CGRectMake(5, self.agencySView.frame.origin.y-1, SCREEN_WIDTH-10, 1);
    
    
    
    self.navigationItem.title = self.dataS.meetingtitle;
    
    
}

- (void)setVales
{
    

    
//    _meetingtitle1.text = self.dataS.meetingtitle;
    self.meetingtitle1.textAlignment = NSTextAlignmentCenter;
    [self.meetingtitle1 setTextAlignment:NSTextAlignmentCenter];
    _meetingtitle1.numberOfLines = 1;
    [_meetingtitle1 sizeToFit];
    _meetingtitle1.frame =CGRectMake(0, 20, SCREEN_WIDTH, 44);
    
    _starttime.text =self.dataS.starttime;
    
    //会议内容
    
    _meetingintroduce1.text =self.dataS.meetingintroduce;
    _meetingintroduce1.numberOfLines = 0;
    CGSize maxSize = CGSizeMake(150, MAXFLOAT);
    
    //根据文本内容 计算frame
    CGSize contextSize = [self.dataS.meetingintroduce sizeWithFont:TextFont maxSize:maxSize];
    CGFloat contextH = contextSize.height;
    CGFloat contextFX =CGRectGetMaxX(_meetContext .frame);
    
    CGFloat contextFY =CGRectGetMinY(_meetContext.frame)+2;
//    _meetContext.frame.origin.y;
    
    _meetingintroduce1.frame = CGRectMake(contextFX-10, contextFY,SCREEN_WIDTH-contextFX, contextH);
    
    //会议地点
    
    _meetingSite.text =self.dataS.meetingplace;
    _meetingSite.numberOfLines = 0;
    _meetingSite.textAlignment = NSTextAlignmentLeft;
    CGSize siteSize = [_meetingSite.text sizeWithFont:TextFont maxSize:maxSize];
    
    CGFloat siteH = siteSize.height ;
    CGFloat siteFX =CGRectGetMaxX(_meetSite.frame);
    CGFloat siteFY=CGRectGetMinY(_meetSite.frame)+2;
//    _meetSite.frame.origin.y ;
    //    CGRectGetMinY(_meetSite.frame);
    _meetingSite.frame = CGRectMake(siteFX-10, siteFY, SCREEN_WIDTH-siteFX, siteH);
    
    
    NSString *memebers = @"";
    for (SHMembers *member in _dataM) {
        if (memebers.length ==0) {
            memebers = [memebers stringByAppendingString:member.name];
        }
        else
        {
            memebers = [memebers stringByAppendingString:[NSString stringWithFormat:@",%@",member.name]];
            
            
        }
    }
    
    _MeetingMembers.text = memebers;
    _MeetingMembers.numberOfLines = 0;
    _MeetingMembers.lineBreakMode =NSLineBreakByTruncatingHead;
    CGSize memberSize = [memebers sizeWithFont:TextFont maxSize:maxSize];
    CGFloat memberH = memberSize.height ;
    //    CGFloat memberFX =CGRectGetMaxX(_meetMember.frame);
    CGFloat memberFY=self.meetMember.frame.origin.y+self.meetMember.frame.size.height;
    
    
    _MeetingMembers.frame = CGRectMake(10, memberFY, self.view.frame.size.width-2*10, memberH/2.5);
    
    //会议议题
    _meetingintroduce.text = self.dataS.meetingtitle;
    _meetingintroduce.numberOfLines = 0;
    
    //根据文本内容 计算frame
    CGSize meetAgencySize = [self.dataS.meetingintroduce sizeWithFont:TextFont maxSize:maxSize];
    
    CGFloat meetingAgencyH = meetAgencySize.height;
    CGFloat meetingAgencyX =CGRectGetMaxX(_meetAgency.frame);
    CGFloat meetingAgencyFY=CGRectGetMinY(_meetAgency.frame)+2;
//    _meetAgency.frame.origin.y;
    
    _meetingintroduce.frame = CGRectMake(meetingAgencyX-10, meetingAgencyFY,SCREEN_WIDTH-meetingAgencyX, meetingAgencyH);
    
    
    //时间
    NSString  *ss = [self.dataS.starttime substringToIndex:16];
    NSString *ee =[self.dataS.endtime substringToIndex:16];
    ee=[ee substringFromIndex:11];
    _time.text = [NSString stringWithFormat:@"%@--%@",ss,ee];
    _time.numberOfLines = 0;
    _time.textAlignment = NSTextAlignmentLeft;
    CGSize timeSize = [_time.text sizeWithFont:TextFont maxSize:maxSize];
    CGFloat timeH = timeSize.height;
    CGFloat timeFX =CGRectGetMaxX(_meetTime.frame);
    CGFloat timeFY=CGRectGetMinY(_meetTime.frame)-3;
//    _meetTime.frame.origin.y;
    _time.frame = CGRectMake(timeFX-10, timeFY-5, SCREEN_WIDTH-timeFX, timeH);
    
    
    
    
        self.agencySView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(_MeetingMembers.frame)+200);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}



@end
