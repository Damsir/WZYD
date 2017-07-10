//
//  TransFormStyleVC.m
//  XAYD
//
//  Created by songdan Ye on 16/6/3.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "TransFormStyleVC.h"

@interface TransFormStyleVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tabelV;

//记录选中的行号
@property (nonatomic,assign)NSInteger current;

@end

@implementation TransFormStyleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _current =-1;
    self.navigationItem.title = @"流转方式";
  
    [self createTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transformChanged) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    
    
}
//屏幕旋转结束执行的方法
- (void)transformChanged
{
    _tabelV.frame =CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [self.tabelV reloadData];
    
}
- (NSArray *)datasource
{
    if (_datasource == nil) {
        _datasource =[NSArray array];
        
          }
    return _datasource;
    
}


/**
 *  创建tableView
 */
- (void)createTableView
{
    UITableView *tabV =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    tabV.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabV.delegate = self;
    tabV.dataSource = self;
    
    _tabelV = tabV;
    self.tabelV.backgroundColor =RGB(250, 250, 250);
    [self.view addSubview:_tabelV];
    
}

#pragma -mark  UITableViewDataSource,UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden =@"cell";
    UITableViewCell *cell ;
    if (cell ==nil) {
        cell =[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    //cell左侧label
    UILabel *leftLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 9, 200, 30)];
    leftLabel.font=[UIFont systemFontOfSize:17];
    leftLabel.textColor=[UIColor blackColor];
    [cell.contentView addSubview:leftLabel];
    
    //设置数据
    leftLabel.text = _datasource[indexPath.row];
    
    cell.contentView.backgroundColor =[UIColor colorWithRed:253.0/255.0 green:253.0/255.0 blue:253.0/255.0 alpha:1];
    
//    CGFloat y=0;
//    if (indexPath.section==0) {
//        y = 99;
////        jtY = (100-20)*0.5;
//    }
//    else
//    {
//        y= 49;
////        jtY = (50-20)*0.5;
//        
//    }
    UIView *line =[[UIView alloc] initWithFrame:CGRectMake(0, 43, MainR.size.width, 1)];
    line.backgroundColor =RGB(238.0, 238.0, 238.0);
    [cell.contentView addSubview:line];
    if (indexPath.section == 0 &&indexPath.row==0) {
        UIView *line =[[UIView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, 1)];
        line.backgroundColor =RGB(238.0, 238.0, 238.0);
        [cell.contentView addSubview:line];
    }
    
       return cell;
}


//选中某行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    _current = indexPath.row;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *array = [tableView visibleCells];
    for (UITableViewCell *cell in array) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


//将要消失时发通知
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    NSDictionary *dict =[NSDictionary dictionary];
    NSString *cu =[NSString stringWithFormat:@"%ld",(long)_current];
    dict= @{@"selected":cu};
   [[NSNotificationCenter defaultCenter] postNotificationName:@"TransfStyle" object:nil userInfo:dict];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
