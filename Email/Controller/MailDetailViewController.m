//
//  MailDetailViewController.m
//  WZYD
//
//  Created by 吴定如 on 16/11/2.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "MailDetailViewController.h"
#import "Global.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "BaseMessageCell.h"
#import "MailDetailModel.h"
#import "SendMailViewController.h"
#import "AttachmentViewController.h"

@interface MailDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIView *borderView;
@property(nonatomic,assign) CGFloat height;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) NSArray *titleArray;
@property(nonatomic,strong) UIView *footView;
@property(nonatomic,strong) UILabel *mainLabel;
@property(nonatomic,strong) MailDetailModel *model;

@end

@implementation MailDetailViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    //self.navigationItem.title = @"邮件详情";
    [self initNavigationBarTitle:@"邮件详情"];
    
    _dataArray = [NSMutableArray array];
    
    [self createTableViewAndNavigationBar];
    
    [self loadData];
    
    //监听屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}

//屏幕旋转改变视图的Frame
-(void)screenRotation
{
    if (_height < 200)
    {
        _footView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200+40);
        _borderView.frame = CGRectMake(15, 20, SCREEN_WIDTH-30, 200);
    }
    else
    {
        _footView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _height+40);
        _borderView.frame = CGRectMake(15, 20, SCREEN_WIDTH-30, _height);
    }
    _mainLabel.frame = CGRectMake(10, 10, SCREEN_WIDTH-50, _height);
    [_mainLabel sizeToFit];

    _tableView.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height-64);
    [_tableView reloadData];
}

#pragma mark -- 创建 tableView && NaviBar
-(void)createTableViewAndNavigationBar
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, MainR.size.height-64) style:UITableViewStylePlain];
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView = tableView;
    [tableView registerNib:[UINib nibWithNibName:@"BaseMessageCell" bundle:nil] forCellReuseIdentifier:@"BaseMessageCell"];
    
    [self.view addSubview:tableView];
    
    
}

-(void)createFooterView
{
    UIView *footView = [[UIView alloc] init];
    footView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
    _footView = footView;
    
    UIView *borderView = [[UIView alloc] init];
    _height = [self GetLabelHeightWithContent:_model.body];
   // _height = [self GetLabelHeightWithContent:@"核发建设工程规划许可证（正本)快去武汉玩任何法律热比任何物理业务覅额护肤吴何其覅恢复好办法了 我腹黑胡覅去后覅非无企鹅号发货期合并胡说八道我的情况及地区气温确定前往吴金额了千万金额接企鹅技巧 全额问问期间饿哦我请假日哦我日 科维奇和切换为吴日日我去hi如何接吻任务比护额无会武器和红日去黄日华吴入户恶化瑞毫无吴入会后入期货日武汉日去火热胡瑞额外红日乌尔禾i不服诶核发建设工程规划许可证（正本)快去武汉玩任何法律热比任何物理业务覅额护肤吴何其覅恢复好办法了 我腹黑胡覅去后覅非无企鹅号发货期合并胡说八道我的情况及地区气温确定前往吴金额了千万金额接企鹅技巧 全额问问期间饿哦我"];

    if (_height < 200)
    {
        borderView.frame = CGRectMake(15, 20, SCREEN_WIDTH-30, 200);
        footView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200+40);
    }
    else
    {
        borderView.frame = CGRectMake(15, 20, SCREEN_WIDTH-30, _height);
        footView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _height+40);
    }
    borderView.layer.borderWidth = 0.5;
    borderView.layer.borderColor = GRAYCOLOR_MIDDLE.CGColor;
    _borderView = borderView;
    [footView addSubview:borderView];
    
    
    UILabel *mainLabel = [[UILabel alloc] init];
    mainLabel.frame = CGRectMake(10, 10, SCREEN_WIDTH-50, 200);
   // mainLabel.backgroundColor = [UIColor orangeColor];
    mainLabel.text = [NSString stringWithFormat:@"正文:\n%@",_model.body];
   // mainLabel.text = [NSString stringWithFormat:@"正文: 核发建设工程规划许可证（正本)快去武汉玩任何法律热比任何物理业务覅额护肤吴何其覅恢复好办法了 我腹黑胡覅去后覅非无企鹅号发货期合并胡说八道我的情况及地区气温确定前往吴金额了千万金额接企鹅技巧 全额问问期间饿哦我请假日哦我日 科维奇和切换为吴日日我去hi如何接吻任务比护额无会武器和红日去黄日华吴入户恶化瑞毫无吴入会后入期货日武汉日去火热胡瑞额外红日乌尔禾i不服诶核发建设工程规划许可证（正本)快去武汉玩任何法律热比任何物理业务覅额护肤吴何其覅恢复好办法了 我腹黑胡覅去后覅非无企鹅号发货期合并胡说八道我的情况及地区气温确定前往吴金额了千万金额接企鹅技巧 全额问问期间饿哦我"];
    mainLabel.numberOfLines = 0;
    mainLabel.textAlignment = NSTextAlignmentLeft;
    
    _mainLabel = mainLabel;
    
    NSMutableAttributedString *attr =
    [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"正文:\n%@",_model.body]];
   // attr =[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"正文: 核发建设工程规划许可证（正本)快去武汉玩任何法律热比任何物理业务覅额护肤吴何其覅恢复好办法了 我腹黑胡覅去后覅非无企鹅号发货期合并胡说八道我的情况及地区气温确定前往吴金额了千万金额接企鹅技巧 全额问问期间饿哦我请假日哦我日 科维奇和切换为吴日日我去hi如何接吻任务比护额无会武器和红日去黄日华吴入户恶化瑞毫无吴入会后入期货日武汉日去火热胡瑞额外红日乌尔禾i不服诶核发建设工程规划许可证（正本)快去武汉玩任何法律热比任何物理业务覅额护肤吴何其覅恢复好办法了 我腹黑胡覅去后覅非无企鹅号发货期合并胡说八道我的情况及地区气温确定前往吴金额了千万金额接企鹅技巧 全额问问期间饿哦我"]];
    UIFont *boldFont = [UIFont boldSystemFontOfSize:17.0];
    [attr addAttribute:NSFontAttributeName value:boldFont
                     range:NSMakeRange(0, 3)];
    [attr addAttribute:NSForegroundColorAttributeName value:BLUECOLOR range:NSMakeRange(0,3)];
    
    mainLabel.attributedText = attr;

    [mainLabel sizeToFit];
    [borderView addSubview:mainLabel];
    
    _tableView.tableFooterView = footView;
}

-(CGFloat)GetLabelHeightWithContent:(NSString *)content
{
    CGRect rect = [content boundingRectWithSize:CGSizeMake(MainR.size.width-50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]} context:nil];
    return rect.size.height + 20;
}


-(void)loadData
{
    _titleArray = @[@"标题",@"发件人",@"收件人",@"时间"];
    
    //加载提示框
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/mail/MailDetail.ashx"];
    NSDictionary *paremeters = @{@"mailID":_mailModel.MailID,@"deviceNumber":[Global deviceUUID],@"username":[Global userName]};
    
    [manager POST:url parameters:paremeters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *arr = [responseObject objectForKey:@"result"];
        for (NSDictionary *dic in arr)
        {
            MailDetailModel *model = [[MailDetailModel alloc] initWithDictionary:dic];
            if ([model.body isEqualToString:@""]) {
                model.body = @"暂无正文!";
            }
            else{
                // 解析乱码
                model.body = [errorCode deleteFlagOfHTML:model.body];
                //model.body = [HtmlCode deleteFlagOfHTML:model.body];
            }
            _model = model;
            [_dataArray addObject:model.EmailTile];
            [_dataArray addObject:model.SenderName];
            [_dataArray addObject:model.TargetName];
            [_dataArray addObject:model.DateTime1];
        }
        
        [self createFooterView];
        if ([_mailType isEqualToString:@"mailInbox"])
        {
            [self createMailInboxNavigationBar];
        }
        else if ([_mailType isEqualToString:@"mailDraft"])
        {
            [self createMailDraftNavigationBar];
        }
        else if ([_mailType isEqualToString:@"mailOutbox"])
        {
            [self createMailOutboxNavigationBar];
        }
        
        [_tableView reloadData];
        //加载提示框
        [MBProgressHUD hideHUDForView:self.view animated:NO];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //加载提示框
        [MBProgressHUD hideHUDForView:self.view animated:NO];

        NSLog(@"%@",error);
        
    }];
    
}

#pragma -mark  UITableViewDataSource,UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaseMessageCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(_dataArray.count > indexPath.row)
    {
        cell.title.text = _titleArray[indexPath.row];;
        cell.detailTitle.text = _dataArray[indexPath.row];
    }
    
//    UIView *line =[[UIView alloc] initWithFrame:CGRectMake(15, cell.frame.size.height-0.5, MainR.size.width, 0.5)];
//    line.backgroundColor = GRAYCOLOR_MIDDLE;
//    [cell.contentView addSubview:line];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = [self GetCellHeightWithContent:_dataArray[indexPath.row]];
    if (cellHeight >= 44.0)
    {
        return cellHeight;
    }
    
    return 44.0;
}

-(CGFloat)GetCellHeightWithContent:(NSString *)content
{
    CGRect rect = [content boundingRectWithSize:CGSizeMake(MainR.size.width-148, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]} context:nil];
    return rect.size.height + 10;
}

#pragma mark -- createDifferentNaviBar

// 收件箱
-(void)createMailInboxNavigationBar
{
    UIButton *replyBtn = [self createButtonWithTitle:@"回复" andFrame:CGRectMake(0, 0, 50, 30) Tag:100];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:replyBtn];
    
    UIButton *materialBtn = [self createButtonWithTitle:@"附件" andFrame:CGRectMake(0, 0, 50, 30) Tag:101];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:materialBtn];
    self.navigationItem.rightBarButtonItems = @[item1,item2];
}
// 草稿箱
-(void)createMailDraftNavigationBar
{
    UIButton *materialBtn = [self createButtonWithTitle:@"发送" andFrame:CGRectMake(0, 0, 50, 30) Tag:102];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:materialBtn];
    self.navigationItem.rightBarButtonItem = item;
}
// 已发邮件
-(void)createMailOutboxNavigationBar
{
    UIButton *materialBtn = [self createButtonWithTitle:@"附件" andFrame:CGRectMake(0, 0, 50, 30) Tag:103];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:materialBtn];
}


// customButton
-(UIButton *)createButtonWithTitle:(NSString *)title andFrame:(CGRect)frame Tag:(NSInteger)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //button.backgroundColor = BLUECOLOR;
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    button.layer.cornerRadius = 2;
    button.clipsToBounds = YES;
    // 按钮对齐方式设置
    button.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    button.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    button.titleLabel.font = [UIFont systemFontOfSize:16.5];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.tag = tag;
    
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

-(void)clickButton:(UIButton *)btn
{
    // 回复
    if (btn.tag == 100)
    {
        SendMailViewController *sendMailVC = [[SendMailViewController alloc] init];
        sendMailVC.fsOrhf = @"hf";
        sendMailVC.model = _model;
        
        [self.navigationController pushViewController:sendMailVC animated:YES];
    }
    // 发送
    else if (btn.tag == 102)
    {
        SendMailViewController *sendMailVC = [[SendMailViewController alloc] init];
        sendMailVC.fsOrhf = @"fs";
        sendMailVC.model = _model;

        [self.navigationController pushViewController:sendMailVC animated:YES];
    }
    // 附件
    else if (btn.tag == 101 || btn.tag == 103)
    {
        AttachmentViewController *attachmentVC = [[AttachmentViewController alloc] init];
        attachmentVC.model = _mailModel;
        [self.navigationController pushViewController:attachmentVC animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end