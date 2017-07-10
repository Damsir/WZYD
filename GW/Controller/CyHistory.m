//
//  CyHistory.m
//  XAYD
//
//  Created by songdan Ye on 16/5/24.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "CyHistory.h"

#import "PTreeHeaderFooterView.h"
#import "AFNetworking.h"
#import "SPDetailModel.h"
#import "Global.h"
#import "MaterialModel.h"
#import "MBProgressHUD+MJ.h"
#import "materialListCell.h"
#import "MaterialItems.h"
#import "FileViewController.h"
#import "CYQYModel.h"
#import "MBProgressHUD+MJ.h"
//历史记录各条模型

#import "CQhistoryModel.h"
//历史记录所有模型
#import "CYQYAllModel.h"
#import "FileTableCell.h"


@interface CyHistory ()<UIScrollViewDelegate,PTreeHeaderFooterViewDelegate>

@property(nonatomic,strong) NSString *path;
@property(nonatomic,strong) NSString *fileName;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) NSString *remark;
@property(nonatomic,strong) NSMutableArray *remarkArray;
@property(nonatomic,assign) int count;//备注条数

@end

@implementation CyHistory

-(void)loadData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // 创建一个参数字典
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@"smartplan" forKey:@"type"];
    [params setObject:@"forwardhistory" forKey:@"action"];
    if ([_dataType isEqualToString:@"zbgwlist"]||[_dataType isEqualToString:@"ybgwlist"])
    {
        NSString *str=_model.ProjectId;
        // params[@"sourceId"]=str;
        [params setObject:str forKey:@"sourceId"];
    }else
    {
        
        //params[@"sourceId"]=_cqModel.owner;
        [params setObject:_cqModel.owner forKey:@"sourceId"];

       
    }
   //为固定值
    params[@"sourceType"]=@"1";
    //0传阅,1签阅历史
    params[@"forwardType"]=self.forwardType;
    self.datasource =[NSArray array];
    
    NSMutableString *requestAddress = [NSMutableString stringWithString:[Global serverAddress]];
    [requestAddress appendString:@"?"];
    
    if (nil!=params) {
        for (NSString *key in params.keyEnumerator) {
            NSString *val = [params objectForKey:key];
            [requestAddress appendFormat:@"&%@=%@",key,val];
        }
    }
    
    NSLog(@"传阅签阅记录%@",requestAddress);
    [manager POST:[Global serverAddress] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        if ([[dict objectForKey:@"success"] isEqualToString:@"true"])
        {
            NSArray *result = [dict objectForKey:@"result"];
            //没有数据
            if(result.count == 0)
            {
                
                if( [self.forwardType isEqualToString:@"0"])
                {
                    [MBProgressHUD showSuccess:@"暂时没有传阅记录"];
                }else
                {
                    [MBProgressHUD showSuccess:@"暂时没有签阅记录"];
                    
                }
            }
            else
            {
                [dict writeToFile:_fileName atomically:YES];
                //读文件
                NSDictionary *plistDic = [NSDictionary dictionaryWithContentsOfFile:_fileName];
                NSArray *result = [plistDic objectForKey:@"result"];
                NSLog(@"result::%@",result);
                _dataArray = [NSMutableArray array];
                [_dataArray addObjectsFromArray:result];
                
                // 备注内容
                _remarkArray = [NSMutableArray array];
                _count = 0;
                for (int i=0; i<_dataArray.count; i++)
                {
                    NSDictionary *remarkDic = [_dataArray objectAtIndex:i];
                    NSString *remark = remarkDic[@"remark"];
                    if (![remark isEqualToString:@""]&&remark.length!=0)
                    {
                        _remark =[NSString stringWithFormat:@"备注(%@): %@",[remarkDic valueForKey:@"historydiscrption"],remark];
                        [_remarkArray addObject:_remark];
                        [_remarkArray addObject:@"你师弟啊舒服hi回复ihfieuwfhuie"];
                    }
                }
                _count = _remarkArray.count;
                
            }
            NSLog(@"count::%d",_count);
            [_tableView reloadData];
        
        }
        else
        {
            if( [self.forwardType isEqualToString:@"0"])
            {
                [MBProgressHUD showSuccess:@"暂时没有传阅记录"];
            }else
            {
                [MBProgressHUD showSuccess:@"暂时没有签阅记录"];
                
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    self.nav.navigationBar.hidden = NO;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //1. 创建一个plist文件
    NSArray *pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[pathArray objectAtIndex:0];
    _path = path;
    NSLog(@"path = %@",path);
    NSString *fileName=[path stringByAppendingPathComponent:@"record.plist"];
    _fileName = fileName;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:fileName contents:nil attributes:nil];
    
    [self loadData];
    
    if([_forwardType isEqualToString:@"0"])
    {
        self.navigationItem.title = @"传阅记录";
    }
    else
    {
        self.navigationItem.title = @"签阅记录";
    }
    
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, MainR.size.height-15) style:UITableViewStylePlain];
    self.tableView.delegate= self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FileTableCell" bundle:nil] forCellReuseIdentifier:@"FileTableCell"];
    self.tableView.sectionHeaderHeight = 50;
    
    [self.view addSubview:_tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    
    
}
//屏幕旋转结束执行的方法
- (void)screenRotation
{
    self.tableView.frame=CGRectMake(0, 0, MainR.size.width, MainR.size.height-15);
    [self.tableView reloadData];
    
}
#pragma mark - Tableview datasource & delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _dataArray.count;
}

#pragma mark -tabelViewDelge代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //创建自定制cell
    FileTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FileTableCell"];
    cell.contentLabel.text = [[_dataArray objectAtIndex:indexPath.row] valueForKey:@"historydiscrption"];
    // 备注内容
//    NSDictionary *remarkDic = [_dataArray objectAtIndex:indexPath.row];
//    NSString *remark = remarkDic[@"remark"];
//    if (![remark isEqualToString:@""]&&remark.length!=0)
//    {
//        NSString *str=[NSString stringWithFormat:@"备注: %@",remark];
//        NSMutableAttributedString *mstr = [[NSMutableAttributedString alloc]initWithString:str];
//        //设置：在0-3个单位长度内的内容显示成蓝色
//        [mstr addAttribute:NSForegroundColorAttributeName value:RGB(34, 152, 239) range:NSMakeRange(0, 3)];
//        [mstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, 3)];
//        
//        cell.remarkLabel.attributedText = mstr;
//        
//    }
    //区别文件夹和文件
    NSDictionary *dic = [_dataArray objectAtIndex:indexPath.row];
    if([dic valueForKey:@"files"]) {
        cell.icon.image = [UIImage imageNamed:@"传阅"];
    }
    else
    {
        cell.icon.image = [UIImage imageNamed:@"阅读量"];
    }

    [cell setIndentationLevel:[[[_dataArray objectAtIndex:indexPath.row] valueForKey:@"level"] intValue]];
    cell.indentationWidth = 25;
    float indentPoints = cell.indentationLevel * cell.indentationWidth;
    
    cell.contentView.frame = CGRectMake(indentPoints,cell.contentView.frame.origin.y,cell.contentView.frame.size.width - indentPoints,cell.contentView.frame.size.height);
    
   // NSLog(@"indentationLevel=%ld",(long)cell.indentationLevel);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"section=%ld,row=%ld",(long)indexPath.section,(long)indexPath.row);
    
    NSDictionary *dic = [_dataArray objectAtIndex:indexPath.row];
    if([dic valueForKey:@"files"])
    {
        NSArray *array = [dic valueForKey:@"files"];
        
        BOOL isAlreadyInserted = NO;
        
        for(NSDictionary *dInner in array)
        {
            NSInteger index=[_dataArray indexOfObjectIdenticalTo:dInner];
            //NSLog(@"index = %ld",(long)index);
            isAlreadyInserted = (index>0 && index!=NSIntegerMax);
            if(isAlreadyInserted) break;
        }
        
        if(isAlreadyInserted)
        {
            [self miniMizeThisRows:array];
        }
        else
        {
            NSUInteger count = indexPath.row+1;
            NSMutableArray *cellArr = [NSMutableArray array];
            for(NSDictionary *inDic in array)
            {
                [cellArr addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                [_dataArray insertObject:inDic atIndex:count++];
            }
            [tableView insertRowsAtIndexPaths:cellArr withRowAnimation:UITableViewRowAnimationBottom];
        }
        
    }
    else
    {
        NSString *str=[dic valueForKey:@"historydiscrption"];
        NSLog(@"str = %@",str);
    }
    [_tableView reloadData];
}

-(void)miniMizeThisRows:(NSArray*)arr
{
    
    for(NSDictionary *inDic in arr )
    {
        NSUInteger indexToRemove = [_dataArray indexOfObjectIdenticalTo:inDic];
        NSArray *inarr=[inDic valueForKey:@"files"];
        
        if(inarr && [inarr count]>0)
        {
            [self miniMizeThisRows:inarr];
        }
        
        if([_dataArray indexOfObjectIdenticalTo:inDic]!=NSNotFound)
        {
            [_dataArray removeObjectIdenticalTo:inDic];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexToRemove inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSMutableArray *heightArray = [NSMutableArray array];
    [heightArray addObject:@"0"];
    for (int i=0; i<_remarkArray.count; i++)
    {
        CGFloat height = [self returnCellHeight:_remarkArray[i]];
        NSString *H = [NSString stringWithFormat:@"%f",height];
        [heightArray addObject:H];
    }
    
    UIView *alView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, MainR.size.width, 40)];
    if (_dataArray.count)
    {
        NSDictionary *dic = [_dataArray objectAtIndex:section];
        NSString *remark = dic[@"remark"];
        for (int i=0; i<_remarkArray.count; i++)
        {
            CGFloat height = [self returnCellHeight:_remarkArray[section]];
            float H = [heightArray[i] floatValue];
            UILabel *adv =[[UILabel alloc] initWithFrame:CGRectMake(15, H*i, MainR.size.width-30, height)];
            //adv.backgroundColor = [UIColor purpleColor];
            adv.numberOfLines = 0;
            [adv setFont:[UIFont systemFontOfSize:15]];
            [adv setTextColor:[UIColor blackColor]];
            if (![remark isEqualToString:@""]&&remark.length!=0)
            {
                NSString *str =[NSString stringWithFormat:@"备注%d (%@): %@",i+1,[dic valueForKey:@"historydiscrption"],remark];
                NSMutableAttributedString *mstr = [[NSMutableAttributedString alloc]initWithString:str];
                //设置：在0-3个单位长度内的内容显示成蓝色
                [mstr addAttribute:NSForegroundColorAttributeName value:RGB(34, 152, 239) range:NSMakeRange(0, 3)];
                [mstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 3)];
                
                adv.attributedText = mstr;
                
            }
            
            alView.backgroundColor =RGB(240, 240, 240);
            //alView.backgroundColor = [UIColor orangeColor];
            [alView addSubview:adv];
        }
        
    }
    
    return alView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSDictionary *dic = [_dataArray objectAtIndex:section];
    NSString *remark = dic[@"remark"];
    if (![remark isEqualToString:@""] && remark.length!=0)
    {
        return _count * [self returnCellHeight:_remarkArray[section]];
    }
    else
    {
        return 0.0;
    }
}
-(CGFloat)returnCellHeight:(NSString *)string
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(MainR.size.width-30,MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    
    NSLog(@"foot_H::%lf",rect.size.height + 10.0);
    return rect.size.height + 10.0;
}

#pragma mark-PTreeHeaderFooterView代理方法

- (void)clickHeaderView
{
    [self.tableView reloadData];
    
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
