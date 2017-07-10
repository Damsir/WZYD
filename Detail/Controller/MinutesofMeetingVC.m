//
//  MinutesofMeetingVC.m
//  XAYD
//
//  Created by songdan Ye on 16/5/16.
//  Copyright © 2016年 dist. All rights reserved.
//会议纪要

#import "MinutesofMeetingVC.h"
#import "SHMeetingModel.h"
@interface MinutesofMeetingVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UILabel *label1;
@property (nonatomic,strong)UILabel *label2;
@property (nonatomic,strong)UILabel *label3;
@property (nonatomic,strong)UIView *topView;




@end

@implementation MinutesofMeetingVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height-64-MENUHEIHT);
    self.view.backgroundColor =RGB(238.0, 238.0, 238.0);
    [self createTopTipView];
    [self createTableView];
}

//创建顶部提示视图
- (void)createTopTipView
{
    UIView *topView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, 44)];
    [topView setBackgroundColor:RGB(250, 250, 250)];
        UILabel *label1 =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width/3.0, 44)];
    for (int i=0; i<=3; i++) {
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(i*MainR.size.width/3.0, 0, 1, 44)];
        line.backgroundColor=RGB(238.0, 238.0, 238.0);
        [topView addSubview:line];
    }
    [label1 setText:@"议题名称"];
    [label1 setFont:[UIFont systemFontOfSize:17]];
    [label1 setTextColor:[UIColor blackColor]];
    [label1 setTextAlignment:NSTextAlignmentCenter];
    _label1= label1;
    [topView addSubview:_label1];
    
    [self.view addSubview:topView];
    UILabel *label2 =[[UILabel alloc] initWithFrame:CGRectMake(MainR.size.width/3.0, 0, MainR.size.width/3.0, 44)];
    [label2 setText:@"议题类别"];
    [label2 setFont:[UIFont systemFontOfSize:17]];
    [label2 setTextColor:[UIColor blackColor]];
    [label2 setTextAlignment:NSTextAlignmentCenter];

    _label2 = label2;
    [topView addSubview:_label2];
    
    UILabel *label3 =[[UILabel alloc] initWithFrame:CGRectMake(MainR.size.width*2/3.0, 0, MainR.size.width/3.0, 44)];
    [label3 setText:@"办理状态"];
    [label3 setFont:[UIFont systemFontOfSize:17]];
    [label3 setTextColor:[UIColor blackColor]];
    [label3 setTextAlignment:NSTextAlignmentCenter];

    _label3 =label3;
    [topView addSubview:_label3];
    
    _topView =topView;
    [self.view addSubview:_topView];
    



}
//创建tabelView
- (void)createTableView
{

    UITableView *tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 40, MainR.size.width, self.view.frame.size.height-44) style:UITableViewStylePlain];
    tableView.delegate =self;
    tableView.dataSource = self;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _formTabelV = tableView;
    [self.view addSubview:_formTabelV];


}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 20;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    for (int i=0; i<=3; i++) {
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(i*MainR.size.width/3.0, 0, 1, 44)];
        line.backgroundColor=RGB(238.0, 238.0, 238.0);
        [cell.contentView addSubview:line];
    }
    
    
    //cell左侧label
    UILabel *leftLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,0, MainR.size.width/3.0, 44)];
    leftLabel.font=[UIFont systemFontOfSize:15];
    leftLabel.textColor=[UIColor redColor];
    [leftLabel setTextAlignment:NSTextAlignmentCenter];
    
    [cell.contentView addSubview:leftLabel];
    //cell左侧label
    UILabel *midLabel=[[UILabel alloc]initWithFrame:CGRectMake(MainR.size.width/3.0,0, MainR.size.width/3.0, 44)];
    midLabel.font=[UIFont systemFontOfSize:15];
    midLabel.textColor=[UIColor darkGrayColor];
    [midLabel setTextAlignment:NSTextAlignmentCenter];

    
    [cell.contentView addSubview:midLabel]; //cell左侧label
    UILabel *rightLabel=[[UILabel alloc]initWithFrame:CGRectMake(MainR.size.width-MainR.size.width/3.0,0, MainR.size.width/3.0, 44)];
    rightLabel.font=[UIFont systemFontOfSize:15];
    rightLabel.textColor=[UIColor darkGrayColor];
    [rightLabel setTextAlignment:NSTextAlignmentCenter];

    
    [cell.contentView addSubview:rightLabel];
    
    [leftLabel setText:@"会议测试"];
    [midLabel setText:@"1号会议室"];
    [rightLabel setText:@"测试"];
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 43, MainR.size.width, 1)];
    line.backgroundColor=RGB(238.0, 238.0, 238.0);
    [cell.contentView addSubview:line];
    
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
