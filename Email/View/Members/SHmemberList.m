//
//  SHmemberList.m
//  distmeeting
//
//  Created by songdan Ye on 15/10/9.
//  Copyright (c) 2015年 dist. All rights reserved.
//

#import "SHmemberList.h"
#import "SHMemberListViewCell.h"
#import "SHmemeberHeadder.h"
#import "MailContactModel.h"
#import "AFNetworking.h"
#import "DamTreeView.h"


#define POPLISTVIEW_SCREENINSET 40.
#define POPLISTVIEW_HEADER_HEIGHT 50.
#define RADIUS 5.

@interface SHmemberList () <TreeDelegate>

- (void)fadeIn;
- (void)fadeOut;

@end


@implementation SHmemberList

/**
 *  屏幕旋转
 */
-(void)screenRotation
{
    
    if(MainR.size.height == 480)
    {
        _bView.frame=CGRectMake(10, 100, MainR.size.width-20, MainR.size.height-130);
    }
    if(MainR.size.width > 414)
    {
        _bView.frame=CGRectMake(150, 180, MainR.size.width-300, MainR.size.height-360-64);
    }
    
    _nameLabel.frame = CGRectMake(10, 10, _bView.frame.size.width-20, 44);
    _innerView.frame =CGRectMake(10, CGRectGetMaxY(_nameLabel.frame)+5, _bView.frame.size.width-20, _bView.frame.size.height-2*50-10);
    _topbtn.frame = CGRectMake(0, 0, _innerView.frame.size.width, 55);
    _line.frame =CGRectMake(0, CGRectGetMaxY(_topbtn.frame)-1, _topbtn.frame.size.width, 1);
    _selectedAll.frame =CGRectMake(5, (_topbtn.frame.size.height-30)*0.5, 30, 30);
    _sumName.frame =CGRectMake(CGRectGetMaxX(_selectedAll.frame)+5, (_topbtn.frame.size.height- 50)*0.5, _innerView.frame.size.width-120, 50);
    _imageV.frame = CGRectMake(_topbtn.frame.size.width-55, 7, 40, 40) ;
    _tableView.frame = CGRectMake(0, CGRectGetMaxY(_topbtn.frame),_topbtn.frame.size.width, _innerView.frame.size.height-_topbtn.frame.size.height);
    _confirmBtn.frame =  CGRectMake(CGRectGetMaxX(_innerView.frame)-100,CGRectGetMaxY(_innerView.frame) , 100, _bView.frame.size.height-CGRectGetMaxY(_innerView.frame));
    [_confirmBtn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    _cancelBtn.frame = CGRectMake(CGRectGetMaxX(_innerView.frame)-180,CGRectGetMaxY(_innerView.frame) , 100, _bView.frame.size.height-CGRectGetMaxY(_innerView.frame));
    [_tableView reloadData];
}

/**
 *  初始化视图
 */
- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title;
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //请求参会人员数据
        [self loadMemebersData];
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        UIView *bView=[[UIView alloc]initWithFrame:CGRectMake(10, 100, MainR.size.width-20, MainR.size.height-180)];
        if(MainR.size.height == 480)
        {
            bView.frame=CGRectMake(10, 100, MainR.size.width-20, MainR.size.height-130);
            
        }
        if(MainR.size.width > 414)
        {
            bView.frame=CGRectMake(150, 180, MainR.size.width-300, MainR.size.height-360-64);
            
            
        }
        bView.backgroundColor =[UIColor whiteColor];
        bView.layer.cornerRadius =6;
        bView.layer.masksToBounds=YES;
        _bView = bView;
        [self addSubview:_bView];
        
        UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, bView.frame.size.width-20, 44)];
        [nameLabel setText:title];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setFont:[UIFont systemFontOfSize:19.0]];
        [nameLabel setTextColor:[UIColor blackColor]];
        _nameLabel = nameLabel;
        [_bView addSubview:nameLabel];
        
        UIView *innerView =[[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(nameLabel.frame)+5, _bView.frame.size.width-20, _bView.frame.size.height-2*50-10)];
        [innerView.layer setMasksToBounds:YES];
        [innerView.layer setCornerRadius:10];
        [innerView.layer setBorderWidth:1.0];
        [innerView.layer setBorderColor:[UIColor blackColor].CGColor];
        _innerView = innerView;
        [_bView addSubview:innerView];
        
        UIButton *topbtn =[UIButton buttonWithType:UIButtonTypeCustom];
        topbtn.frame =CGRectMake(0, 0, innerView.frame.size.width, 55);
        topbtn.backgroundColor =[UIColor whiteColor];
        //选择所有人
        [topbtn addTarget:self action:@selector(allSelect:) forControlEvents:UIControlEventTouchUpInside];
        _topbtn = topbtn;
        _selected = _topbtn.selected;
        [innerView addSubview:_topbtn];
        
        UIImageView *line =[[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topbtn.frame)-1, topbtn.frame.size.width, 1)];
        line.backgroundColor =RGB(230.0, 230.0, 230.0);
        _line = line;
        [innerView addSubview:line];
        
        UIImageView *selectedAll =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-unselected"]];
        selectedAll.frame =CGRectMake(5, (_topbtn.frame.size.height-30)*0.5, 30, 30);
        _selectedAll= selectedAll;
        [topbtn addSubview:_selectedAll];
        
        UILabel *sumName =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(selectedAll.frame)+5, (_topbtn.frame.size.height-50)*0.5, innerView.frame.size.width-120, 50)];
        [sumName setTextColor:BLUECOLOR];
        [sumName setFont:[UIFont systemFontOfSize:17.0]];
        _sumName = sumName;
        [topbtn addSubview:_sumName];
        
        UIImageView *imageV =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon"]];
        imageV.frame =CGRectMake(topbtn.frame.size.width-55, 7, 40, 40) ;
        imageV.layer.cornerRadius = 5;
        imageV.clipsToBounds = YES;
        _imageV = imageV;
        [topbtn addSubview:imageV];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topbtn.frame),topbtn.frame.size.width, innerView.frame.size.height-topbtn.frame.size.height)];
        _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor = [UIColor colorWithWhite:0 alpha:.2];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.sectionHeaderHeight = 40;
        [innerView addSubview:_tableView];
        
        _confirmBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor colorWithRed:19.0/255 green:128.0/255 blue:182.0/255 alpha:1] forState:UIControlStateNormal];
        _confirmBtn.frame = CGRectMake(CGRectGetMaxX(innerView.frame)-100,CGRectGetMaxY(innerView.frame) , 100, bView.frame.size.height-CGRectGetMaxY(innerView.frame));
        [_confirmBtn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
        [bView addSubview:_confirmBtn];
        
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cancelBtn.frame = CGRectMake(CGRectGetMaxX(innerView.frame)-180,CGRectGetMaxY(innerView.frame) , 100, bView.frame.size.height-CGRectGetMaxY(innerView.frame));
        [_cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [bView addSubview:_cancelBtn];
        
        [_tableView reloadData];
        
    }
    
    return self;
}

/**
 *  下载所有参会人员
*/
- (void)loadMemebersData
{
    _contacts = [NSMutableArray array];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/mail/SendList.ashx"];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSArray *array = [responseObject objectForKey:@"result"];
        
         for (NSDictionary *dic in array)
         {
             MailContactModel *model = [[MailContactModel alloc] initWithDictionary:dic];
             [_contacts addObject:model];
         }
         
         [_tableView reloadData];
         
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];
    
}

- (void)confirmClick
{
    NSString *mStr = @"";
    NSString *ID=@"";
    for (MailContactModel *model in _contacts) {
        for (UsersModel *usersModel in model.users) {
            if (usersModel.isSelected == YES) {
                if (mStr.length ==0)
                {
                    mStr = [mStr stringByAppendingString:usersModel.name];
                    ID = [ID stringByAppendingString:usersModel.Id];
                }
                else
                {
                    mStr = [mStr stringByAppendingString:[NSString stringWithFormat:@",%@",usersModel.name]];
                    ID = [ID stringByAppendingString:[NSString stringWithFormat:@",%@",usersModel.Id]];
                }
            }
        }
    }
    NSLog(@"mStr:%@,ID:%@",mStr,ID);

    if (_selectedContactBlock)
    {
        _selectedContactBlock(mStr);
    }
    [self fadeOut];

}

- (void)cancelClick
{
    NSLog(@"取消");
    [self fadeOut];
    
}

- (void)allSelect:(UIButton *)btn
{
    _selected= !_selected;
    BOOL state= _selected;
    
    for (MailContactModel *model in _contacts) {
        
        if (state ==YES) {
            _selectedAll.image =[UIImage imageNamed:@"iconfont-selected"];
            model.selected = true;
        }
        else
        {
            _selectedAll.image =[UIImage imageNamed:@"iconfont-unselected"];


            model.selected = false;
            
        }
        
        for (UsersModel *usersModel in model.users) {
            
            
            if (state == YES) {
                usersModel.selected = YES;
                
//                [btn setTitle:@"取消" forState:UIControlStateNormal];
                
            }
            else{
                
                usersModel.selected = NO;
//                [btn setTitle:@"全选" forState:UIControlStateNormal];
            }
            
        }
    }
    
    [_tableView reloadData];
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
- (void)showInView:(UIView *)view animated:(BOOL)animated
{
    [view addSubview:self];
    if (animated) {
        [self fadeIn];
    }
}

#pragma mark - Tableview datasource & delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //
    MailContactModel *model = [_contacts objectAtIndex:(section)];
    NSInteger counts = model.users.count;
    NSInteger count = model.isOpened ? counts: 0;
    return  count;
}

#pragma mark -tabelViewDelge代理方法

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SHmemeberHeadder *headerView = [SHmemeberHeadder memberHeaderWithTableView:tableView];
    headerView.selectBut.tag = section;
    headerView.delegate = self;
    headerView.membersModel = _contacts[section];
    
    //MailContactModel *model = [self.contacts objectAtIndex:0];
    //NSLog(@"model= %@,model.name=%@",model,model.organName);
    //[_sumName setText:@"选择所有人"];

    NSInteger sum = 0;
    for (int i=0; i<_contacts.count; i++) {
        
        sum += [[_contacts[i] users] count];
    }
     _sumName.text = [NSString stringWithFormat:@"选择所有人(%ld)",sum];
    
    return headerView;
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_contacts.count)
    {
        NSInteger count =_contacts.count;
        return count;
    }
    
    return  0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity = @"Cell";
    
    SHMemberListViewCell *cell = (SHMemberListViewCell *)[tableView dequeueReusableCellWithIdentifier:identity];
    if (cell ==  nil) {
        cell = [[SHMemberListViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identity] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    MailContactModel *model = _contacts[indexPath.section];
    UsersModel *usersModel = model.users[indexPath.row];

    if (usersModel.isSelected == NO) {
        usersModel.selected = NO;
        [cell setChecked:NO];
    }
    else
    {
        usersModel.selected = YES;
        [cell setChecked:true];
    }
    cell.textLabel.text = usersModel.name;
    cell.textLabel.textColor =[UIColor blackColor];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    SHMemberListViewCell *cell = (SHMemberListViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    MailContactModel *model = _contacts[indexPath.section];
    UsersModel *usersModel = model.users[indexPath.row];
    
    if (usersModel.isSelected==false) {
        usersModel.selected = YES;
        [cell setChecked:YES];
    }
    else
    {
        usersModel.selected = NO;
        [cell setChecked:NO];
    }
    
    
}

#pragma mark-SHmemeberHeadder代理方法
- (void)clickHeaderView
{
    [_tableView reloadData];
}

- (void)selctGroupWithButton:(UIButton *)btn;
{
    
    //点击了选择组按钮;
    MailContactModel *model = _contacts[btn.tag];
    model.selected = !model.selected;
    
    for (UsersModel *usersModel in model.users) {
        
        if (model.selected == true)
        {
            usersModel.selected = YES;
        }
        else
        {
            usersModel.selected = NO;
        }
        
    }
    [_tableView reloadData];
    
}

#pragma mark - TouchTouchTouch
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self fadeOut];
}



@end

