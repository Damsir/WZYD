//
//  BaseMessageVC.m
//  XAYD
//
//  Created by dingru Wu on 16/7/19.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "MeetingBaseVC.h"
#import "BaseMessageCell.h"
#import "AFNetworking.h"
#import "Global.h"
#import "MeetingInfoModel.h"
#import "MJExtension.h"
#import "MeetingBaseCell.h"
#import "FileViewController.h"
#import "MeetingSummaryCell.h"


@interface MeetingBaseVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic,strong)UITableView *baseTableView;
@property(nonatomic,strong) NSArray *infoArray;
@property(nonatomic,strong) NSMutableArray *markArray;//标记数组(分组收放)
@property(nonatomic,strong) NSMutableArray *groupImgArray;//分组图标
@property(nonatomic,strong) NSMutableArray *detailArray_out;//详细信息
@property(nonatomic,strong) NSMutableArray *presentPersonArr;//出席人
@property(nonatomic,strong) NSMutableArray *liexiPersonArr;//列席人
@property(nonatomic,strong) MeetingInfoModel *infoModel;//数据模型
@property(nonatomic,strong) NSString *present;//列席所有人员
@property(nonatomic,strong) NSString *liexi;//出席所有人员

@end

@implementation MeetingBaseVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.nav.navigationBar.hidden = NO;
//
//    self.view.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height-114);
//    _baseTableView.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height-114);
//    [_baseTableView reloadData];

}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor =[UIColor whiteColor];
    
    [self loadData];
    [self createTableView];
}
//屏幕旋转改变视图的Frame
-(void)screenRotation
{
    _baseTableView.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height-114);
    
    [_baseTableView reloadData];
    
}

- (void)transFromMeetingId:(NSString *)meetingId
{
    self.meetingId = meetingId;
    
}
-(void)createTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, MainR.size.height-114) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    _baseTableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    [tableView registerNib:[UINib nibWithNibName:@"BaseMessageCell" bundle:nil] forCellReuseIdentifier:@"BaseMessageCell"];
    [tableView registerNib:[UINib nibWithNibName:@"MeetingBaseCell" bundle:nil] forCellReuseIdentifier:@"MeetingBaseCell"];
    [tableView registerNib:[UINib nibWithNibName:@"MeetingSummaryCell" bundle:nil] forCellReuseIdentifier:@"MeetingSummaryCell"];

}


-(void)loadData
{
    _infoArray = @[@"名称",@"编号",@"地址",@"时间",@"类别",@"会议纪要",@"主持人"];
    _markArray = [NSMutableArray array];
    for (int i=0; i<4; i++) {
        NSString *mark = @"0";
        [_markArray addObject:mark];
    }
    
    _groupImgArray = [NSMutableArray arrayWithObjects:@"xiangshang",@"xiangshang",@"xiangshang",@"xiangshang", nil];
    
    _presentPersonArr = [NSMutableArray array];//出席人
    _liexiPersonArr = [NSMutableArray array];//列席人
    _detailArray_out = [NSMutableArray array];
    
    //请求会议详情数据
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
//    type=smartplan&action=meetingdetail&meetingId=1
    
    NSDictionary *params = @{@"type":@"smartplan",@"action":@"meetingdetail",@"meetingId":_meetingId};
    //NSString *url = @"http://58.246.138.178:8040/HAYDService/ServiceProvider.ashx";
    // 发送请求
    [manager POST:[Global serverAddress] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        NSDictionary *JsonDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
       // NSLog(@"responseObject_base:%@",JsonDic);
        //  请求成功的时候调用
        if ([[JsonDic objectForKey:@"success"] isEqualToString:@"true"])
        {
            
            _infoModel = [[MeetingInfoModel alloc] mj_setKeyValues:operation.responseString];
            //NSLog(@"model:%@",[infoModel.result[0] meetingName]);
            
            //将数据加入数组(外部数据)
            [_detailArray_out addObject:[_infoModel.result[0] meetingName]];
            [_detailArray_out addObject:[_infoModel.result[0] meetingId]];
            [_detailArray_out addObject:[_infoModel.result[0] meetingAddress]];
            [_detailArray_out addObject:[_infoModel.result[0] meetingTime]];
            [_detailArray_out addObject:[_infoModel.result[0] meetingType]];
            [_detailArray_out addObject:[_infoModel.result[0] meetingSummary]];
            [_detailArray_out addObject:[_infoModel.result[0] HostUserName]];
            //参会人员(出席人,列席人,主持人)
            for (int i=0; i<[_infoModel.result[0] personList].count; i++)
            {
                NSString *personType = [[_infoModel.result[0] personList][i] personType] ;
                //NSLog(@"type:%@",personType);
                if ([personType isEqualToString:@"出席人"])
                {
                    [_presentPersonArr addObject:[[_infoModel.result[0] personList][i] personName]];
                }
                else if ([personType isEqualToString:@"列席人"])
                {
                    [_liexiPersonArr addObject:[[_infoModel.result[0] personList][i] personName]];
                }
            }
            if (_liexiPersonArr.count)
            {
                _liexi = [_liexiPersonArr componentsJoinedByString:@"  "];
            }
            if (_presentPersonArr.count)
            {
                _present = [_liexiPersonArr componentsJoinedByString:@"  "];
            }
            
            [_baseTableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];
    
   // [self createTableView];
}



#pragma -- tableView代理

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *mark = [_markArray objectAtIndex:section];
    
    if (section == 0)
    {
        return _infoArray.count;
    }
    else if (section == 1 && [mark isEqualToString:@"1"])
    {
        if (_presentPersonArr.count) {
            return 1;
        }
        else return 0;
    }
    else if (section == 2 && [mark isEqualToString:@"1"])
    {
        if (_liexiPersonArr.count) {
            return 1;
        }
        else return 0;
    }
    else if (section == 3 && [mark isEqualToString:@"1"])
    {
        if (![[_infoModel.result[0] meetingContent] isEqualToString:@""]) {
            return 1;
        }
        else return 0;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        
        BaseMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaseMessageCell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.title.text = _infoArray[indexPath.row];
        
        //安全性判断
        if (_detailArray_out.count > indexPath.row)
        {
            if (indexPath.row == 5)
            {
                MeetingSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeetingSummaryCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.title.text = _infoArray[indexPath.row];
                cell.detailLabel.text = _detailArray_out[indexPath.row];
                cell.imageV.image = [UIImage imageNamed:@"huixingz.png"];
                UIView *line =[[UIView alloc] initWithFrame:CGRectMake(15, 43, MainR.size.width, 1)];
                line.backgroundColor = GRAYCOLOR;
                [cell.contentView addSubview:line];
                return cell;
                
//                //先移除原先的contentView再添加
//                for (UIView *view in cell.contentView.subviews) {
//                    [view removeFromSuperview];
//                }
//                
//                UILabel *titleLable =[[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 44)];
//                titleLable.text = _infoArray[indexPath.row];
//                [cell.contentView addSubview:titleLable];
//                UIImageView *imageView =[[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.size.width-40, 10, 22, 22)];
//                imageView.image = [UIImage imageNamed:@"huixingz.png"];
//                imageView.userInteractionEnabled = YES;
//                [cell.contentView addSubview:imageView];
            }
            else
            {
                cell.detailTitle.text = _detailArray_out[indexPath.row];
            }
        }
        
        UIView *line =[[UIView alloc] initWithFrame:CGRectMake(15, 43, MainR.size.width, 1)];
        line.backgroundColor = GRAYCOLOR;
        [cell.contentView addSubview:line];
        return cell;
    }
    else 
    {
        MeetingBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeetingBaseCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.text.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        if (indexPath.section == 1)
        {
            /**
             *  注意:table的代理执行顺序是先cell的高度,然后cell的内容,所以这个地方数据拼接应该在数据请求完成时去拼接
            */
//            if (_presentPersonArr.count)
//            {
//                //拼接数组里的所以字符串(元素)
//                _present = [_presentPersonArr componentsJoinedByString:@"  "];
                cell.text.text = _present;
                //cell.textLabel.text=@"健康会尽快发货时来电话覅是打发hi第三方is冯绍峰的尽快发货电视剧福建省地方肯定是分开后覅后覅而非爱疯hi呃回复的是覅u不覅u 和覅里的水打卡机圣诞节卡萨尽快发你家附近空我都是的撒加发送健康方式围殴我前几of刷卡机请问一如何无穷日撒可富叫撒健康妇女预期而起舞吴人会去玩而且一个人去";
                
//            }
            
        }
        else if (indexPath.section == 2)
        {

            cell.text.text = _liexi;

        }
        else if (indexPath.section == 3)
        {
            
            cell.text.text = [_infoModel.result[0] meetingContent];
        }
        UIView *line =[[UIView alloc] initWithFrame:CGRectMake(15, 0, MainR.size.width, 1)];
        line.backgroundColor = GRAYCOLOR;
        [cell.contentView addSubview:line];
        
        return cell;
    }
    
//    return cell;
}

// cell点击方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 5)
    {
        NSString *meetingSummary = _detailArray_out[indexPath.row];
     
        FileViewController *fvc = [[FileViewController alloc]init];
        MeetingResultModel *modelInfo =self.infoModel.result[indexPath.section];
        NSString *meetingId = modelInfo.meetingId;
        NSString *fileId = [NSString stringWithFormat:@"%@_%@",modelInfo.createUserId,modelInfo.meetingId];
     
        NSArray *arr=[meetingSummary componentsSeparatedByString:@"."];
        if (arr.count > 1)
        {
//            NSString *urllll=@"http://192.168.2.221/server/ServiceProvider.ashx";
            NSString *str =[arr lastObject];
            NSString *ext =[@"." stringByAppendingString:str];
            NSString *downloadUrl = [NSString stringWithFormat:@"%@?type=smartplan&action=getMeetingSummary&meetingId=%@",[Global serviceUrl],meetingId];
            [fvc openFile:fileId url:downloadUrl ext:ext];
            //[[UIApplication sharedApplication].keyWindow.rootViewController  presentViewController: fvc animated: YES completion:nil];
            //[self.nav pushViewController:fvc animated:YES];
            if([[[UIDevice currentDevice] systemVersion] floatValue]<8.0)
            {
               //self.nav.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:nil];
            
                [self.nav pushViewController:fvc animated:YES];
                
            }
            else
            {
                //[self presentViewController:fvc animated:YES completion:nil];
                //[self.view.window.rootViewController presentViewController:fvc animated:YES completion:nil];
                //[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:fvc animated:YES completion:nil];
                id<UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
                [appDelegate.window.rootViewController presentViewController:fvc animated:YES completion:nil];
            }
        
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"没有会议纪要!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            
        }
    }
}

//头部视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] init];
    headView.tag = section;
    headView.backgroundColor = GRAYCOLOR_LIGHT;
    UIView *backV = [[UIView alloc] init];
    backV.backgroundColor = [UIColor whiteColor];
    backV.frame = CGRectMake(0, 0, MainR.size.width, 45);
    [headView addSubview:backV];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, MainR.size.width, 45)];
    if (section == 1)
    {
        lab.text = @"出席人";
    }
    else if (section == 2)
    {
        lab.text = @"列席人";
    }
    else if (section == 3)
    {
        lab.text = @"会议简介";
    }
    [headView addSubview:lab];
    UIButton *groupBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    groupBtn.frame = CGRectMake(CGRectGetMaxX(backV.frame)-35, 30/2.0, 15, 15);
    [groupBtn setImage:[UIImage imageNamed:_groupImgArray[section]] forState:UIControlStateNormal];
    groupBtn.enabled = NO;
    groupBtn.tag = section+1000;
    [headView addSubview:groupBtn];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openOrCloseHeader:)];
    [headView addGestureRecognizer:tap];
    return headView;
}
//打开关闭分组
-(void)openOrCloseHeader:(UITapGestureRecognizer *)tap
{
    UIView *tapView = tap.view;
    NSString *mark = _markArray[tapView.tag];
   
    if ([mark isEqualToString:@"0"]) {
        [_markArray replaceObjectAtIndex:tapView.tag withObject:@"1"];
        [UIView animateWithDuration:0.5 animations:^{
            //            [btn setImage:[UIImage imageNamed:@"zhankai"] forState:UIControlStateNormal];
            [_groupImgArray replaceObjectAtIndex:tapView.tag withObject:@"zhankai"];
            
        }];
        
    }
    else
    {
        [_markArray replaceObjectAtIndex:tapView.tag withObject:@"0"];
        [UIView animateWithDuration:0.5 animations:^{
            //[btn setImage:[UIImage imageNamed:@"zhankai"] forState:UIControlStateNormal];
            [_groupImgArray replaceObjectAtIndex:tapView.tag withObject:@"xiangshang"];

        }];
        
    }
    [_baseTableView reloadData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
       return [self returnCellHeight:_present];
       //return [self returnCellHeight:@"健康会尽快发货时来电话覅是打发hi第三方is冯绍峰的尽快发货电视剧福建省地方肯定是分开后覅后覅而非爱疯hi呃回复的是覅u不覅u 和覅里的水打卡机圣诞节卡萨尽快发你家附近空我都是的撒加发送健康方式围殴我前几of刷卡机请问一如何无穷日撒可富叫撒健康妇女预期而起舞吴人会去玩而且一个人去"];
        //NSLog(@"heght:%f",[self returnCellHeight:_present]);
    }
    else if (indexPath.section == 2)
    {
       return [self returnCellHeight:_liexi];
    }
    else if (indexPath.section == 3)
    {
       return [self returnCellHeight:[_infoModel.result[0] meetingContent]];
    }
    else
    {
        return 44;
    }
    
}
//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section != 0)
//    {
//        return 90.0;
//    }
//    return 44.0;
//}

-(CGFloat)returnCellHeight:(NSString *)string
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(MainR.size.width-40,MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]} context:nil];
    return rect.size.height + 20.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.0;
    }
    return 45.0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

-(void)layoutSubViews
{
//    self.view.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height-114);
//    _baseTableView.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height-114);
//    [_baseTableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
