//
//  MeetingDetailController.m
//  HAYD
//
//  Created by 吴定如 on 16/8/29.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "MeetingDetailController.h"
#import "MeetingDetailCell.h"
#import "MeetingInfoVC.h"
#import "MeetingModel.h"
#import "MeetingInfomationVC.h"
#import "EditMeetingViewController.h"

@interface MeetingDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,assign) NSInteger selectedIndex;
@property(nonatomic,strong) UILabel *tip;

@end

@implementation MeetingDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    //self.title = @"日程列表";
    [self initNavigationBarTitle:@"日程列表"];
    
    [self createMeetingTableView];
    //屏幕旋转通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIDeviceOrientationDidChangeNotification object:nil];
}
//屏幕旋转改变视图的Frame
-(void)screenRotation:(NSNotification *)noti
{
    _tip.center = CGPointMake(SCREEN_WIDTH/2.0, (SCREEN_HEIGHT-64)/2.0);
    _meetingTableView.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height-64);
}
-(void)createMeetingTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, MainR.size.height-64) style:UITableViewStylePlain];
    [tableView registerNib:[UINib nibWithNibName:@"MeetingDetailCell" bundle:nil] forCellReuseIdentifier:@"MeetingDetailCell"];
    //tableView.tableFooterView = [[UIView alloc] init];
    //tableView.backgroundColor = [UIColor orangeColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.estimatedRowHeight = 70;
    _meetingTableView = tableView;
    
    
    [self.view addSubview:tableView];
}

#pragma mark - - tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _meetingArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MeetingDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeetingDetailCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //cell.backgroundColor = [UIColor orangeColor];
    [cell setMeetingDetailCell:_meetingArray[indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    MeetingInfoVC *infoVC = [[MeetingInfoVC alloc] init];
//    MeetingModel *model = _meetingArray[indexPath.row];
//    NSLog(@"model.MEETINGID:%@",model.meetingId);
//    infoVC.meetingId = model.meetingId;
//    [self.navigationController pushViewController:infoVC animated:YES];
    
//    MeetingInfomationVC *infoVC = [[MeetingInfomationVC alloc] init];
//    MeetingModel *model = _meetingArray[indexPath.row];
//    NSLog(@"model.MEETINGID:%@",model.meetingId);
//    infoVC.meetingId = model.meetingId;
//    [self.navigationController pushViewController:infoVC animated:YES];
    
    EditMeetingViewController *editVC = [[EditMeetingViewController alloc] init];
    editVC.model = _meetingArray[indexPath.row];
    _selectedIndex = indexPath.row;
    // 编辑回调
    editVC.editSuccessBlock = ^(BOOL isSuccess,MeetingModel *model)
    {
        if (isSuccess)
        {
            [_meetingArray replaceObjectAtIndex:_selectedIndex withObject:model];
            [_meetingTableView reloadData];
            // 编辑成功回调
            if (_editMeetingSuccessBlock) {
                _editMeetingSuccessBlock(YES);
            }
        }
    };
    editVC.deleteSuccessBlock = ^(BOOL isSuccess)
    {
        if (isSuccess)
        {
            [_meetingArray removeObjectAtIndex:_selectedIndex];
            [_meetingTableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationLeft];
            // 没有日程情况
            if (!_meetingArray.count) {
                UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
                tip.center = CGPointMake(SCREEN_WIDTH/2.0, (SCREEN_HEIGHT-64)/2.0);
                tip.text = @"今天没有日程内容!";
                tip.textAlignment = NSTextAlignmentCenter;
                tip.textColor = BLUECOLOR;
                _tip = tip;
                [self.view addSubview:tip];
            }
            // 编辑成功回调
            if (_editMeetingSuccessBlock) {
                _editMeetingSuccessBlock(YES);
            }
        }
    };
    
    [self.navigationController pushViewController:editVC animated:YES];
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
