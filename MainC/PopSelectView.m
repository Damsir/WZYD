//
//  PopSelectView.m
//  XAYD
//
//  Created by songdan Ye on 16/1/4.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "PopSelectView.h"

@interface PopSelectView ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation PopSelectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)defaultSettings
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.borderColor = [UIColor colorWithRed:219/255.0 green:217/255.0 blue:216/255.0 alpha:1].CGColor;
    btn.layer.borderWidth = 0.5;
    btn.clipsToBounds = YES;
    btn.layer.masksToBounds = YES;
    btn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [btn addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(2, 0, self.frame.size.width-imgW - 5 - 2, self.frame.size.height)];
    _titleLabel.font = [UIFont systemFontOfSize:11];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.textColor = [UIColor darkGrayColor];
    [btn addSubview:_titleLabel];
    
    _arrow = [[UIImageView alloc]initWithFrame:CGRectMake(btn.frame.size.width - imgW - 2, (self.frame.size.height-imgH)/2.0, imgW, imgH)];
    _arrow.image = [UIImage imageNamed:@"fav1"];
    [btn addSubview:_arrow];
    
    //默认不展开
    _isOpen = NO;
    _listTable = [[UITableView alloc]initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y+self.frame.size.height, self.frame.size.width,0) style:UITableViewStylePlain];
    _listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _listTable.delegate = self;
    _listTable.dataSource = self;
    _listTable.layer.borderWidth = 0.5;
    _listTable.layer.borderColor = [UIColor colorWithRed:219/255.0 green:217/255.0 blue:216/255.0 alpha:1].CGColor;
    [self addSubview:_listTable];
    _titleLabel.text = [_titlesList objectAtIndex:_defaultIndex];
}

//刷新视图
-(void)reloadData
{
    [_listTable reloadData];
    _titleLabel.text = [_titlesList objectAtIndex:_defaultIndex];
}

//点击事件
-(void)tapAction
{
    if(_isOpen)
    {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = _listTable.frame;
            frame.size.height = 0;
            [_listTable setFrame:frame];
        } completion:^(BOOL finished){
            [_listTable removeFromSuperview];//移除
            _isOpen = NO;
            _arrow.transform = CGAffineTransformRotate(_arrow.transform, DEGREES_TO_RADIANS(180));
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            if(_titlesList.count>0)
            {
                [_listTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
            
          
            
            
            CGRect frame = _listTable.frame;
            frame.size.height = _tableHeight>0?_tableHeight:tableH;
            float height = [UIScreen mainScreen].bounds.size.height;
            if(frame.origin.y+frame.size.height>height)
            {
                //避免超出屏幕外
                frame.size.height -= frame.origin.y + frame.size.height - height;
            }
            
            [_listTable setFrame:frame];
            
            [self addSubview:_listTable];
            [self bringSubviewToFront:_listTable];//避免被其他子视图遮盖住
            
        } completion:^(BOOL finished){
            _isOpen = YES;
            _arrow.transform = CGAffineTransformRotate(_arrow.transform, DEGREES_TO_RADIANS(180));
        }];
    }
}

#pragma mark -tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titlesList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.frame.size.height;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _titleLabel.text = [_titlesList objectAtIndex:indexPath.row];
    _isOpen = YES;
    [self tapAction];
    if([_delegate respondsToSelector:@selector(selectAtIndex:inCombox:)])
    {
        [_delegate selectAtIndex:indexPath.row inCombox:self];
    }
    //    [self performSelector:@selector(deSelectedRow) withObject:nil afterDelay:0.2];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.backgroundColor = [UIColor blueColor];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(2, 0, self.frame.size.width-4, self.frame.size.height)];
//        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = [UIColor darkGrayColor];
        label.tag = 1000;
        [cell addSubview:label];
        
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-0.5, self.frame.size.width, 0.5)];
        line.backgroundColor = [UIColor colorWithRed:219/255.0 green:217/255.0 blue:216/255.0 alpha:1];
        [cell addSubview:line];
    }
    UILabel *label = (UILabel *)[cell viewWithTag:1000];
    label.text = [_titlesList objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}


-(void)deSelectedRow
{
    [_listTable deselectRowAtIndexPath:[_listTable indexPathForSelectedRow] animated:YES];
}

@end
