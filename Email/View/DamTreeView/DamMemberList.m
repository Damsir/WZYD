//
//  DamMemberList.m
//  WZYD
//
//  Created by 吴定如 on 16/12/4.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "DamMemberList.h"
#import "AFNetworking.h"
#import "DamTreeView.h"


#define POPLISTVIEW_SCREENINSET 40.
#define POPLISTVIEW_HEADER_HEIGHT 50.
#define RADIUS 5.

@interface DamMemberList () <TreeDelegate>

@property(nonatomic,strong) DamTreeView *DamTreeView;

- (void)fadeIn;
- (void)fadeOut;

@end

@implementation DamMemberList

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
   // _selectedAll.frame =CGRectMake(5, (_topbtn.frame.size.height-30)*0.5, 30, 30);
    _sumName.frame =CGRectMake(15, (_topbtn.frame.size.height- 50)*0.5, _innerView.frame.size.width-120, 50);
    _imageV.frame = CGRectMake(_topbtn.frame.size.width-55, 7, 40, 40) ;
    _confirmBtn.frame =  CGRectMake(CGRectGetMaxX(_innerView.frame)-100,CGRectGetMaxY(_innerView.frame) , 100, _bView.frame.size.height-CGRectGetMaxY(_innerView.frame));
    [_confirmBtn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    _cancelBtn.frame = CGRectMake(CGRectGetMaxX(_innerView.frame)-180,CGRectGetMaxY(_innerView.frame) , 100, _bView.frame.size.height-CGRectGetMaxY(_innerView.frame));
    
    //
    _DamTreeView.frame = CGRectMake(0, CGRectGetMaxY(_topbtn.frame),_topbtn.frame.size.width, _innerView.frame.size.height-_topbtn.frame.size.height);
    [_DamTreeView screenRotation];
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
        nameLabel.backgroundColor = [UIColor whiteColor];
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
        line.backgroundColor =RGB(220.0, 220.0, 220.0);
        _line = line;
        [innerView addSubview:line];
        
        UIImageView *selectedAll =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-unselected"]];
        selectedAll.frame =CGRectMake(5, (_topbtn.frame.size.height-30)*0.5, 30, 30);
        _selectedAll= selectedAll;
        //[topbtn addSubview:_selectedAll];
        
        UILabel *sumName =[[UILabel alloc] initWithFrame:CGRectMake(15, (_topbtn.frame.size.height-50)*0.5, innerView.frame.size.width-120, 50)];
        [sumName setTextColor:BLUECOLOR];
        [sumName setFont:[UIFont systemFontOfSize:18.0]];
        _sumName = sumName;
        [topbtn addSubview:_sumName];
        
        UIImageView *imageV =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon"]];
        imageV.frame =CGRectMake(topbtn.frame.size.width-55, 7, 40, 40) ;
        imageV.layer.cornerRadius = 5;
        imageV.clipsToBounds = YES;
        _imageV = imageV;
        [topbtn addSubview:imageV];
        
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topbtn.frame),topbtn.frame.size.width, innerView.frame.size.height-topbtn.frame.size.height)];
//        _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
//        _tableView.separatorColor = [UIColor colorWithWhite:0 alpha:.2];
//        _tableView.backgroundColor = [UIColor whiteColor];
//        _tableView.dataSource = self;
//        _tableView.delegate = self;
//        _tableView.sectionHeaderHeight = 40;
//        [innerView addSubview:_tableView];
        
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
        
    }
    
    return self;
}

/**
 *  下载所有参会人员
 */
- (void)loadMemebersData
{
    [MBProgressHUD showMessage:@"正在加载" toView:KeyWindow];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/mail/SendList.ashx"];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSArray *result = [responseObject objectForKey:@"result"];
         if (result.count)
         {
             DamTreeView *treeView = [[DamTreeView instanceView] initTreeWithFrame:CGRectMake(0, CGRectGetMaxY(_topbtn.frame),_topbtn.frame.size.width, _innerView.frame.size.height-_topbtn.frame.size.height) dataArray:result haveHiddenSelectBtn:NO haveHeadView:NO isEqualX:NO];
             _DamTreeView = treeView;
             treeView.returnSelectCountBlock = ^(NSInteger count){
                 _sumName.text = [NSString stringWithFormat:@"已选收件人 (%ld)",(long)count];
             };
             treeView.delegate = self;
             [_innerView addSubview:treeView];
         }
         else{
             [MBProgressHUD showError:@"人员列表加载失败"];
         }
         [MBProgressHUD hideHUDForView:KeyWindow animated:NO];
 
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [MBProgressHUD hideHUDForView:KeyWindow animated:NO];
         [MBProgressHUD showError:@"人员列表加载失败"];
         NSLog(@"error:%@",error);
     }];
    
}

#pragma mark -- DamTreeViewDelegate

-(void)itemSelectInfo:(DamPeopleCellModel *)item
{
   // NSLog(@"info::%@",item.name);
}

-(void)itemSelectArray:(NSArray *)selectArray
{
    NSLog(@"selectArray::%@",selectArray);
    NSMutableArray *names = [NSMutableArray array];
    for (NSDictionary *person in selectArray) {
        [names addObject:[person objectForKey:@"name"]];
    }
    NSString *nameString = [names componentsJoinedByString:@","];
    _nameString = nameString;
}

#pragma mark -- 确定选择
- (void)confirmClick
{
    if (_selectedContactBlock)
    {
        _selectedContactBlock(_nameString);
    }
    [self fadeOut];
}

#pragma mark -- 取消选择
- (void)cancelClick
{
    [self fadeOut];
}

#pragma mark -- 选择所有人
- (void)allSelect:(UIButton *)btn
{
    
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

#pragma mark - TouchTouchTouch
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self fadeOut];
}

@end
