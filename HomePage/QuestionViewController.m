//
//  QuestionViewController.m
//  WZYD
//
//  Created by 吴定如 on 16/12/13.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "QuestionViewController.h"
#import "MBProgressHUD+MJ.h"
#import "Global.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "QuestionCell.h"
#import "QuestionModel.h"
#import "PickerView.h"

static NSDateFormatter *dateFormatter;

@interface QuestionViewController () <UITableViewDelegate,UITableViewDataSource>

//@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,assign) NSInteger pageSize;
@property(nonatomic,assign) NSInteger selectedIndex;
@property(nonatomic,strong) NSMutableArray *replyArray;//微博内容

@end

@implementation QuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    //self.navigationItem.title = @"问题反馈";
    [self initNavigationBarTitle:@"问题反馈"];
    
    _pageSize = 10;
    _dataArray = [NSMutableArray array];
    _replyArray = [NSMutableArray array];
    
    [self createTableViewAndNaviSearchBar];
    [self loadData];
    
    //监听屏幕旋转的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}

//屏幕旋转改变视图的Frame
-(void)screenRotation:(NSNotification *)noti
{
    self.tableView.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height-64);
    [self.tableView reloadData];
}

#pragma mark -- 创建 tableView && SearchBar
-(void)createTableViewAndNaviSearchBar
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, MainR.size.height-64) style:UITableViewStylePlain];
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    [tableView registerNib:[UINib nibWithNibName:@"QuestionCell" bundle:nil] forCellReuseIdentifier:@"QuestionCell"];
    [self.view addSubview:tableView];
    
    //下拉刷新
    tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [_dataArray removeAllObjects];
        [_replyArray removeAllObjects];
        //_pageSize = 10;
        [self loadData];
    }];
    //上拉加载更多
    tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [_dataArray removeAllObjects];
        [_replyArray removeAllObjects];
        _pageSize += 10;
        [self loadData];
    }];
    
    
    //    UIButton *writeBlogButton = [self createButtonWithImage:@"fbwb" andTitle:@"发布" andFrame:CGRectMake(0, 0, 80, 30) andTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:writeBlogButton];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"我要反馈" style:UIBarButtonItemStylePlain target:self action:@selector(writeQuestion)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(writeQuestion)];
    
}

-(void)loadData
{
    //加载提示框
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
   //61.153.29.236:8891/mobileService/service/comment/comment.ashx?action=list&pageIndex=0&pageSize=10
    
    NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/comment/comment.ashx"];
    NSDictionary *paremeters = @{@"action":@"list",@"pageIndex":@"0",@"pageSize":[NSString stringWithFormat:@"%ld",(long)_pageSize],@"deviceNumber":[Global deviceUUID],@"username":[Global userName]};
    
    [manager POST:url parameters:paremeters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"success"] isEqual:@1]) {
            NSArray *result = [responseObject objectForKey:@"result"];
            for (NSDictionary *dic in result)
            {
                QuestionModel *model = [[QuestionModel alloc] initWithDictionary:dic];
                // 拼接问题内容和回复内容
                NSString *reply = model.content;
                for (ReplyListModel *replyModel in model.replyList)
                {
                    reply = [NSString stringWithFormat:@"%@\n%@@%@: %@  --  %@",reply,replyModel.userName,replyModel.replyToUser,replyModel.content,replyModel.createDate];
                }
                [_replyArray addObject:reply];
                [_dataArray addObject:model];
            }
            
            //加载提示框
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            [self.tableView reloadData];
            // 暂无数据
            _dataArray.count == 0 ? [self showEmptyData]: [self removeEmptyData] ;
            
        }else
        {
            //加载提示框
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            [MBProgressHUD showError:@"加载失败"];
        }
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        //加载提示框
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [MBProgressHUD showError:@"加载失败"];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
}

#pragma -- mark  UITableViewDataSource,UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_replyArray.count > indexPath.row) {
        
        QuestionModel *model = _dataArray[indexPath.row];
        cell.userName.text = [NSString stringWithFormat:@"%@ · %@",model.userName,model.createDate];
        cell.reply.text = _replyArray[indexPath.row];
        
        NSString *reply = _replyArray[indexPath.row];
        NSRange range = [reply rangeOfString:@"\n"];
       // NSLog(@"location:%ld length:%ld",range.location,range.length);
        if (range.location != NSNotFound) {
            NSMutableAttributedString *attr =
            [[NSMutableAttributedString alloc] initWithString:reply];
            //UIFont *boldFont = [UIFont boldSystemFontOfSize:17.0];
            //[attr addAttribute:NSFontAttributeName value:boldFont range:NSMakeRange(0, 3)];
            
            [attr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,range.location+1)];
            
            cell.reply.attributedText = attr;
        } else if(range.location == NSNotFound) {
            
            NSMutableAttributedString *attr =
            [[NSMutableAttributedString alloc] initWithString:reply];
            //UIFont *boldFont = [UIFont boldSystemFontOfSize:17.0];
            //[attr addAttribute:NSFontAttributeName value:boldFont range:NSMakeRange(0, 3)];
            
            [attr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,reply.length)];
            
            cell.reply.attributedText = attr;
        }
        
        // 回复
        cell.replyButton.tag = indexPath.row;
        [cell.replyButton addTarget:self action:@selector(replyRequestion:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_replyArray.count > indexPath.row)
    {
        CGFloat cellHeight = [self GetCellHeightWithContent:_replyArray[indexPath.row]];
        if (cellHeight >= 105.0)
        {
            return cellHeight;
        }
        
    }
    return 105.0;
}

#pragma mark -- 计算文字高度
- (CGFloat)GetCellHeightWithContent:(NSString *)content {
    
    CGRect rect = [content boundingRectWithSize:CGSizeMake(MainR.size.width-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil];
    return rect.size.height + 85.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark -- 反馈问题

-(void)writeQuestion
{
    PickerView *pickerView = [[PickerView alloc] initWithFrame:SCREEN_BOUNDS pickerType:@"question"];
    // 发布微博
    pickerView.sendMicroblogBlock = ^(NSString *content)
    {
        //加载提示框
        [MBProgressHUD showMessage:@"正在提交" toView:self.view];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        //61.153.29.236:8891/mobileService/service/comment/comment.ashx?action=add&userId=996&content=测试
        
        NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/comment/comment.ashx"];
        NSDictionary *paremeters = @{@"action":@"add",@"userId":[Global userId],@"content":content,@"deviceNumber":[Global deviceUUID],@"username":[Global userName]};
        
        [manager POST:url parameters:paremeters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if ([[responseObject objectForKey:@"success"] isEqual:@1])
            {
                [MBProgressHUD hideHUDForView:self.view animated:NO];
                [MBProgressHUD showSuccess:@"提交成功"];
                
                [_dataArray removeAllObjects];
                [_replyArray removeAllObjects];
                [self loadData];
            }else
            {
                //加载提示框
                [MBProgressHUD hideHUDForView:self.view animated:NO];
                [MBProgressHUD showError:@"提交失败"];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"%@",error);
            //加载提示框
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            [MBProgressHUD showError:@"提交失败"];
        }];
    };
    
    [pickerView showInView:self.view.window.rootViewController.view animated:YES];
}

#pragma mark -- 问题回复

-(void)replyRequestion:(UIButton *)replyButton
{
    PickerView *pickerView = [[PickerView alloc] initWithFrame:SCREEN_BOUNDS pickerType:@"question"];
    // 发布微博
    pickerView.sendMicroblogBlock = ^(NSString *content)
    {
        //加载提示框
        [MBProgressHUD showMessage:@"正在回复" toView:self.view];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        //61.153.29.236:8891/mobileService/service/AddReply.ashx?userid=&content=&pid=
        NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/AddReply.ashx"];
        NSDictionary *paremeters = @{@"userid":[Global userId],@"content":content,@"pid":[_dataArray[replyButton.tag] Id]};
        
        [manager POST:url parameters:paremeters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *JsonDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
            
            if ([[JsonDic objectForKey:@"result"] isEqualToString:@"True"])
            {
                [MBProgressHUD showSuccess:@"回复成功"];
                // 回复问题反馈
                [self addReplyWithContent:content atIndex:replyButton.tag];
            }
            
            //[self loadData];
            //[self.tableView reloadData];
            //加载提示框
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            //加载提示框
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            [MBProgressHUD showError:@"回复失败"];
            NSLog(@"%@",error);
            
        }];
    };
    
    [pickerView showInView:self.view.window.rootViewController.view animated:YES];
    
}

#pragma mark -- 添加一条微博

-(void)addMicroblogWithContent:(NSString *)content
{
//    dateFormatter = [NSDateFormatter new];
//    [dateFormatter setDateFormat:@"yyyy年MM月dd日 hh:mm"];
//    NSString *newssetdate = [dateFormatter stringFromDate:[NSDate date]];
//    MicroblogModel *model = [[MicroblogModel alloc] init];
//    model.newssetdate = newssetdate;
//    model.userId = [Global userId];
//    model.newscontent = content;
//    model.username = [Global userName];
//    
//    [_dataArray insertObject:model atIndex:0];
    
}

#pragma mark -- 添加一条回复

-(void)addReplyWithContent:(NSString *)content atIndex:(NSInteger)index
{
    dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    QuestionModel *model = _dataArray[index];
    // 拼接问题内容和回复内容
    NSString *reply = model.content;
    reply = [NSString stringWithFormat:@"%@\n%@@%@: %@  --  %@",reply,[Global userName],model.userName,content,[dateFormatter stringFromDate:[NSDate date]]];

    [_replyArray replaceObjectAtIndex:index withObject:reply];

    
    // 只刷新本条反馈
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    
    
    
}

// customButton
-(UIButton *)createButtonWithImage:(NSString *)imageName andTitle:(NSString *)title andFrame:(CGRect)frame andTitleEdgeInsets:(UIEdgeInsets)titleEdgeInsets
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = BLUECOLOR;
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setTitleEdgeInsets:titleEdgeInsets];
    [button setImageEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 50)];
    button.layer.cornerRadius = 2;
    button.clipsToBounds = YES;
    // 按钮对齐方式设置
    button.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    button.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.highlighted = NO;
    button.adjustsImageWhenHighlighted = NO;
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    //[button addTarget:self action:@selector(writeMicroblog) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}
// customLabel
-(UILabel *)createLabelWithFrame:(CGRect)frame andContent:(NSString *)content andBackgroundColor:(UIColor *)color
{
    UILabel *label = [[UILabel alloc] init];
    label.frame = frame;
    label.backgroundColor = color;
    label.text = content;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:15.0];
    
    return label;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
