//
//  MeetingDetailVC.m
//  XAYD
//
//  Created by songdan Ye on 16/5/12.
//  Copyright © 2016年 dist. All rights reserved.
//


#import "MeetingDetailVC.h"
#import "SHMeetingModel.h"
#import "AFNetworking.h"
#import "SHMembers.h"
#import "MBProgressHUD+MJ.h"
#import "NSString+Extension.h"
#define TextFont [UIFont systemFontOfSize:15]


@interface MeetingDetailVC ()


@property (nonatomic,strong)NSArray * members;
@property (nonatomic,strong)NSString *htmlStr;
@end

@implementation MeetingDetailVC



-(void)loadData{
    
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];

    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    // 创建一个参数字典
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"MeetingId"] =_mDatas.meetingId ;
    // 发送get请求
//    [mgr GET:@"http://58.246.138.178:8081/DistMobile/mobileMeeting!getMeetingMembersIOS.action" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) { // 请求成功的时候调用
    NSString *url = [NSString stringWithFormat:@"%@/DistMobile/mobileMeeting!getMeetingMembersIOS.action",DistMUrl];
    
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) { // 请求成功的时候调用

        [MBProgressHUD hideHUDForView:self.view];
        [self setItemHide:NO];
        NSMutableArray *array =[NSMutableArray array];
        for (NSDictionary *subDict in responseObject) {
            //创建数据模型对象
            SHMembers *model = [[SHMembers alloc] init];
            [model initWithDict:subDict];
            //添加到数组中
            [array addObject:model];
            
        }
        
        _members = array;
//        self.dataM =_membersD;

        [self setVales];
        
        
    }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         
         [MBProgressHUD showError:@"网络繁忙,请稍后再试!!!" toView:SHKeyWindow];
         
     }];
}

- (void)downloadwithURLString:(NSString *)urlStr
{
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLRequest *requst = [NSURLRequest requestWithURL:url];
    
    NSURLResponse *response = nil;
   
    NSError *error = nil;
    
    
    NSData *data =  [NSURLConnection sendSynchronousRequest:requst returningResponse:&response error:&error];
    
    if (error == nil) { //下载成功
        NSLog(@"resopnse = %@", response);
        
        NSString *htmlStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        _htmlStr= htmlStr;
        NSLog(@"htmlStr = %@", htmlStr);
    }
    else
    {
        NSLog(@"error = %@", error);
    }
    
    
    

}



- (void)setMDatas:(SHMeetingModel *)mDatas
{
    
    _mDatas =mDatas;
    
}

- (void)setVales
{
    
    NSString *memebers = @"";
    for (SHMembers *member in _members) {
        if (memebers.length ==0) {
            memebers = [memebers stringByAppendingString:member.name];
        }
        else
        {
            memebers = [memebers stringByAppendingString:[NSString stringWithFormat:@",%@",member.name]];
            
            
        }
    }
    self.mTitle.text = self.mDatas.meetingtitle;
    self.time.text =self.mDatas.starttime;
    self.location.text =self.mDatas.meetingplace;
    self.outline.text = self.mDatas.meetingtitle;
   self.liepersonnel.text= memebers;
    
    self.chupersonnel.text =memebers;
    self.subjectToptic.text =_mDatas.meetingintroduce;
    CGFloat w = self.outline.frame.size.width-10;
    CGSize maxSize = CGSizeMake(w, MAXFLOAT);
    //出席人员
    CGSize contextSize = [self.mDatas.meetingtitle sizeWithFont:TextFont maxSize:maxSize];
    CGFloat contextH = contextSize.height;
    //会议简介
    CGSize contextSize1 = [memebers sizeWithFont:TextFont maxSize:maxSize];
    CGFloat contextH1 = contextSize1.height;
    //列席人员
    CGSize contextSize2 = [memebers sizeWithFont:TextFont maxSize:maxSize];
    CGFloat contextH2= contextSize2.height;
    
    NSLog(@"%f",CGRectGetMaxY(self.outline.frame));
    self.scrollViewB.contentSize =CGSizeMake(MainR.size.width, CGRectGetMaxY(self.location.frame)+contextH+contextH1+contextH2+18*4);
    
    
    self.backView.frame = CGRectMake(0, 0, MainR.size.width,CGRectGetMaxY(self.location.frame)+contextH+contextH1+contextH2+18*4) ;

}

- (void)viewDidAppear:(BOOL)animated
{

    [super viewDidAppear:animated];
    

}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self setItemHide:YES];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {

    }
    return self;
}


-(void)setItemHide:(BOOL)hiden
{
    
    
    self.mTitleT.hidden = hiden;
    self.timeT.hidden  = hiden;
    self.locationT.hidden = hiden;
    self.outlineT.hidden = hiden;
    self.chuxiT.hidden= hiden;
    self.liexiT.hidden= hiden;
    self.subTopicT.hidden= hiden;
    self.mTitle.hidden = hiden;
    self.time.hidden = hiden;
    self.location.hidden = hiden;
    self.outline.hidden = hiden;
    self.liepersonnel.hidden = hiden;
    self.chupersonnel.hidden = hiden;
    self.subjectToptic.hidden = hiden;


}



- (void)viewDidLoad {
    [super viewDidLoad];
 
    if (_members==nil) {
        _members =[NSArray array];

    }
    //加载数据
    [self loadData];
    
    
}


//
-(BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return NO;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
