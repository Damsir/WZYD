//
//  SHSiteList.m
//  distmeeting
//
//  Created by songdan Ye on 15/10/28.
//  Copyright (c) 2015年 dist. All rights reserved.
//

#import "SHSiteList.h"
#import "SHSiteModel.h"
#import "SHSiteCell.h"
#define POPLISTVIEW_SCREENINSET 40.
#define POPLISTVIEW_HEADER_HEIGHT 50.
#define RADIUS 5.
@interface SHSiteList ()

@property (nonatomic,strong)UIButton *confirm;
@property (nonatomic,strong)UIButton *cancel;
@property (nonatomic,strong)UIView *bView;


- (void)fadeIn;
- (void)fadeOut;
@end
@implementation SHSiteList


- (NSArray *)sites
{
    if (_sites == nil) {
        _sites =[NSMutableArray array];
            }
    
    return _sites ;
    
}



- (id)initWithTitle:(NSString *)aTitle options:(NSMutableArray *)aOptions
{
        
    _sites =aOptions;
    CGRect rect =MainR;
    if (self = [super initWithFrame:rect])
    {
         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//        _title = aTitle ;
        
        UIView *bView=[[UIView alloc]initWithFrame:CGRectMake(10, 100, MainR.size.width-20, MainR.size.height-210)];
        if (MainR.size.height==736) {
            bView.frame=CGRectMake(60-10, 100, MainR.size.width-59-60, MainR.size.height-279-120);
        }
        if(MainR.size.height==480)
        {
            bView.frame=CGRectMake(10, 100, MainR.size.width-20, MainR.size.height-130);
            
        }
        if(MainR.size.width>414)
        {
        bView.frame=CGRectMake(150, 220, MainR.size.width-300, MainR.size.height-440-64);
        
        }
        
        bView.backgroundColor =[UIColor whiteColor];
        bView.layer.cornerRadius =6;
        bView.layer.masksToBounds=YES;
        _bView = bView;
        [self addSubview:_bView];
        
        UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, bView.frame.size.width-20, 44)];
        [nameLabel setTextColor:[UIColor colorWithRed:15.0/255.0 green:111/255.0 blue:160.0/255.0 alpha:1]];
        [nameLabel setText:@"会议室列表"];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setFont:[UIFont systemFontOfSize:22]];
        [_bView addSubview:nameLabel];

        UIImageView *line =[[UIImageView alloc] initWithFrame:CGRectMake(0, 55, bView.frame.size.width, 0.5)];
        
        line.backgroundColor =[UIColor lightGrayColor];
        [_bView addSubview:line];

      
        CGFloat tableViewW=200;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(bView.frame.origin.x,60, bView.frame.size.width-40,  bView.frame.size.height-60)];
        if (MainR.size.height==736) {
            _tableView.frame =CGRectMake(bView.frame.origin.x-40,60, bView.frame.size.width-40,  bView.frame.size.height-60);
        }
        if (MainR.size.width>414) {
            _tableView.frame =CGRectMake(bView.frame.origin.x-bView.frame.origin.x/2.0,60, bView.frame.size.width-bView.frame.origin.x,  bView.frame.size.height-60);
        }
//        _tableView.separatorColor = [UIColor colorWithWhite:0 alpha:.2];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        
        [_bView addSubview:_tableView];
   
    }
    return self;
}

#pragma mark - Private Methods
- (void)fadeIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}
- (void)fadeOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - Instance Methods
- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    [aView addSubview:self];
    if (animated) {
        [self fadeIn];
    }
}

#pragma mark - Tableview datasource & delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return   [_sites count];
    
}

#pragma mark -tabelViewDelge代理方法

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHSiteModel *model =nil;
    SHSiteCell *cell =[SHSiteCell cellWithTableView:tableView];
    model=[_sites objectAtIndex:indexPath.row];
    
    UIView *line =[[UIView alloc] initWithFrame:CGRectMake(32, 43, _tableView.frame.size.width, 1)];
    line.backgroundColor =RGB(238.0, 238.0, 238.0);
    [cell .contentView addSubview:line];
    
    [cell setModel:model];

    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(siteList:didSelectedIndex:)]) {
                
            [self.delegate siteList:self didSelectedIndex: indexPath.row];
        
        
       [self fadeOut];
        
    }
 
}
#pragma mark - TouchTouchTouch
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // tell the delegate the cancellation
    if (self.delegate && [self.delegate respondsToSelector:@selector(siteListViewDidCancel)]) {
        [self.delegate siteListViewDidCancel];
    }
    
    // dismiss self
    [self fadeOut];
}


@end
