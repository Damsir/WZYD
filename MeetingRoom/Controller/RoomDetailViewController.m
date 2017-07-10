//
//  RoomDetailViewController.m
//  WZYD
//
//  Created by 吴定如 on 16/11/17.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "RoomDetailViewController.h"
#import "BaseMessageCell.h"
#import "MeetingRoomModel.h"

@interface RoomDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *markArray;//标记数组(分组收放)
@property(nonatomic,strong) NSMutableArray *groupImgArray;//分组图标
@property(nonatomic,strong) NSArray *titleArray;
@property(nonatomic,strong) NSMutableArray *detailArray;

@end

@implementation RoomDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.navigationItem.title = @"会议室详情";
    [self initNavigationBarTitle:@"会议室详情"];
    
    [self loadMeetingData];
    [self createTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}
//屏幕旋转结束执行的方法
- (void)screenRotation
{
    _tableView.frame=CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [_tableView reloadData];
}

-(void)loadMeetingData
{
    _markArray = [NSMutableArray array];
    _groupImgArray = [NSMutableArray array];
    for (int i=0; i<_meetingArray.count; i++)
    {
        NSString *mark = @"1";
        NSString *image = @"xiangshang";
        [_groupImgArray addObject:image];
        [_markArray addObject:mark];
    }
    
    _titleArray = @[@"会议室",@"申请人",@"开始时间",@"结束时间",@"使用原因",@"申请时间"];
    _detailArray = [NSMutableArray array];
    for (MeetingRoomModel *model in _meetingArray)
    {
        NSArray *array = @[model.roomName,model.proposer,model.timeStart,model.timeEnd,model.purpose,model.timeApply];
        [_detailArray addObject:array];
    }
    
}

-(void)createTableView
{
    UITableView *tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    tableView.delegate= self;
    tableView.dataSource=self;
    tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:@"BaseMessageCell" bundle:nil] forCellReuseIdentifier:@"BaseMessageCell"];
    _tableView = tableView;
    
    [self.view addSubview:tableView];
}

#pragma -- tableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _meetingArray.count;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *mark = [_markArray objectAtIndex:section];
    
    if ([mark isEqualToString:@"1"])
    {
        return 6;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaseMessageCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.title.text = _titleArray[indexPath.row];
    cell.detailTitle.text = _detailArray[indexPath.section][indexPath.row];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = [self GetCellHeightWithContent:_detailArray[indexPath.section][indexPath.row]];
    if (cellHeight >= 44.0)
    {
        return cellHeight;
    }
    
    return 44.0;
}

-(CGFloat)GetCellHeightWithContent:(NSString *)content
{
    CGRect rect = [content boundingRectWithSize:CGSizeMake(MainR.size.width-180, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]} context:nil];
    return rect.size.height + 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == _meetingArray.count-1)
    {
        return 0.0;
    }
    return 0.0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return [_meetingArray[section] proposer];
}

//头部视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] init];
    headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
    headView.tag = section;
    headView.backgroundColor = GRAYCOLOR_LIGHT;
    
    UIView *line_t =[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    line_t.backgroundColor = GRAYCOLOR_MIDDLE;
    [headView addSubview:line_t];
    
    UIView *line =[[UIView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, 1)];
    line.backgroundColor = GRAYCOLOR_MIDDLE;
    [headView addSubview:line];
    
    UIImageView *headImage = [[UIImageView alloc] init];
    headImage.frame = CGRectMake(15, 15/2.0, 30, 30);
    headImage.image = [UIImage imageNamed:@"user"];
    [headView addSubview:headImage];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImage.frame)+10, 0, MainR.size.width-90, 45)];
    lab.font = [UIFont boldSystemFontOfSize:16.0];
    lab.textColor = BLUECOLOR;
    [headView addSubview:lab];
    
    UIButton *groupBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    groupBtn.frame = CGRectMake(CGRectGetMaxX(headView.frame)-35, 30/2.0, 15, 15);
    groupBtn.enabled = NO;
    groupBtn.tag = section+1000;
    [headView addSubview:groupBtn];
    
    lab.text = [_meetingArray[section] proposer];
    [groupBtn setImage:[UIImage imageNamed:_groupImgArray[section]] forState:UIControlStateNormal];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openOrCloseHeader:)];
    [headView addGestureRecognizer:tap];
    return headView;
}

//打开关闭分组
-(void)openOrCloseHeader:(UITapGestureRecognizer *)tap
{
    UIView *tapView = tap.view;
    
    //UIButton *btn = (UIButton *)[tapView viewWithTag:tapView.tag+1000];
    //NSLog(@"tag: %ld, %@",(long)btn.tag,btn);
    NSString *mark = _markArray[tapView.tag];
    
    if ([mark isEqualToString:@"0"]) {
        [_markArray replaceObjectAtIndex:tapView.tag withObject:@"1"];
        [UIView animateWithDuration:0.5 animations:^{
            //            [btn setImage:[UIImage imageNamed:@"zhankai"] forState:UIControlStateNormal];
            [_groupImgArray replaceObjectAtIndex:tapView.tag withObject:@"xiangshang"];
        }];
    }
    else
    {
        [_markArray replaceObjectAtIndex:tapView.tag withObject:@"0"];
        [UIView animateWithDuration:0.5 animations:^{
            //[btn setImage:[UIImage imageNamed:@"zhankai"] forState:UIControlStateNormal];
            [_groupImgArray replaceObjectAtIndex:tapView.tag withObject:@"zhankai"];
        }];
    }
    
    [_tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end