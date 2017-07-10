//
//  MicroblogViewController.m
//  WZYD
//
//  Created by 吴定如 on 16/11/10.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "MicroblogViewController.h"
#import "MBProgressHUD+MJ.h"
#import "Global.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "MicroblogCell.h"
#import "MicroblogModel.h"
#import "PickerView.h"

static NSDateFormatter *dateFormatter;

@interface MicroblogViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,assign) NSInteger pageSize;
@property(nonatomic,assign) NSInteger selectedIndex;
@property(nonatomic,strong) NSMutableArray *newsContent;//微博内容

@end

@implementation MicroblogViewController

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
    //self.navigationItem.title = @"微博列表";
    [self initNavigationBarTitle:@"微博列表"];
    
    _pageSize = 10;
    _dataArray = [NSMutableArray array];
    
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
    [tableView registerNib:[UINib nibWithNibName:@"MicroblogCell" bundle:nil] forCellReuseIdentifier:@"MicroblogCell"];
    [self.view addSubview:tableView];
    
    //下拉刷新
    tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [_dataArray removeAllObjects];
        //_pageSize = 10;
        [self loadData];
    }];
    //上拉加载更多
    tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [_dataArray removeAllObjects];
        _pageSize += 10;
        [self loadData];
    }];
    
    
//    UIButton *writeBlogButton = [self createButtonWithImage:@"fbwb" andTitle:@"发布" andFrame:CGRectMake(0, 0, 80, 30) andTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:writeBlogButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发微博" style:UIBarButtonItemStylePlain target:self action:@selector(writeMicroblog)];
    
}

-(void)loadData
{
    //加载提示框
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];

    NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/microblog/MicroBlogList.ashx"];
    NSDictionary *paremeters = @{@"index":@"0",@"size":[NSString stringWithFormat:@"%ld",(long)_pageSize],@"deviceNumber":[Global deviceUUID],@"username":[Global userName]};
    
    [manager POST:url parameters:paremeters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *arr = [responseObject objectForKey:@"result"];
        for (NSDictionary *dic in arr)
        {
            MicroblogModel *model = [[MicroblogModel alloc] initWithDictionary:dic];
            // 解析乱码
//            model.newscontent = [errorCode analysisByErrorCode:model.newscontent];
//            NSMutableArray *newsContent = [NSMutableArray arrayWithArray:[model.newscontent componentsSeparatedByString:@"回复"]];
//            _newsContent = newsContent;
//            if (newsContent.count > 1 && [[newsContent lastObject] isEqualToString:@""])
//            {
//                [newsContent removeLastObject];
//            }
//            model.newscontent = [newsContent componentsJoinedByString:@"\n"];
            model.newscontent = [self deleteFlagOfHTML:model.newscontent];
            
            [_dataArray addObject:model];
        }
        
        [self.tableView reloadData];
        
        // 暂无数据
        _dataArray.count == 0 ? [self showEmptyData]: [self removeEmptyData] ;
        //加载提示框
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        //加载提示框
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
}

#pragma mark -- 去除HTML标签

-(NSString *)deleteFlagOfHTML:(NSString *)html{
    
    NSScanner *theScanner;
    NSString *text = nil;
    
    // 将原来的 \n(换行符) 替换为 @""
    html = [html stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    theScanner = [NSScanner scannerWithString:html];
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        
        // <br> 为换行
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<br>"] withString:@"\n"];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"回复"] withString:@""];
        
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
        
    } // while //
   // NSLog(@"-----===%@",html);
    return html;
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
    MicroblogCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MicroblogCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(_dataArray.count > indexPath.row)
    {
        MicroblogModel *model = _dataArray[indexPath.row];
        cell.name.text = model.username;
        cell.date.text = model.newssetdate;
        
        //1.
//        UILabel *sendLabel = [self createLabelWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-160, 60) andContent:[_newsContent firstObject] andBackgroundColor:[UIColor orangeColor]];
//        [cell.content addSubview:sendLabel];
    
        
        cell.content.text = model.newscontent;
        //2.
//        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:model.newscontent];
//        [attr addAttribute:NSForegroundColorAttributeName value:BLUECOLOR range:NSMakeRange(0,8)];
//        cell.content.attributedText = attr;
        
        
        // 回复
        cell.reply.tag = indexPath.row;
        [cell.reply addTarget:self action:@selector(replyMicreoblog:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

#pragma mark -- 微博回复
-(void)replyMicreoblog:(UIButton *)replyButton
{
    PickerView *pickerView = [[PickerView alloc] initWithFrame:SCREEN_BOUNDS pickerType:@"microblog"];
    // 发布微博
    pickerView.sendMicroblogBlock = ^(NSString *content)
    {
        //加载提示框
        [MBProgressHUD showMessage:@"正在回复" toView:self.view];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];

        NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/microblog/MicrsoBlogReply.ashx"];
        NSDictionary *paremeters = @{@"uid":[Global userId],@"content":content,@"wbID":[_dataArray[replyButton.tag] Id],@"deviceNumber":[Global deviceUUID],@"username":[Global userName]};
        
        [manager POST:url parameters:paremeters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [MBProgressHUD showSuccess:@"回复成功"];
            
            NSDictionary *JsonDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];

            if ([[JsonDic objectForKey:@"result"] isEqual:@1])
            {
                // 回复微博
                [self addReplyBlogWithContent:content atIndex:replyButton.tag];
            }
            
            
           // [self.tableView reloadData];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_dataArray.count > indexPath.row)
    {
        CGFloat cellHeight = [self GetCellHeightWithContent:[_dataArray[indexPath.row] newscontent]];
        if (cellHeight >= 112.0)
        {
            return cellHeight;
        }
        
    }
    return 112.0;
}

-(CGFloat)GetCellHeightWithContent:(NSString *)content
{
    CGRect rect = [content boundingRectWithSize:CGSizeMake(MainR.size.width-95, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil];
    return rect.size.height + 85;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark -- 发微博

-(void)writeMicroblog
{
    PickerView *pickerView = [[PickerView alloc] initWithFrame:SCREEN_BOUNDS pickerType:@"microblog"];
    // 发布微博
    pickerView.sendMicroblogBlock = ^(NSString *content)
    {
        //加载提示框
        [MBProgressHUD showMessage:@"正在发布" toView:self.view];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];

        NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/microblog/MicroBlogAdd.ashx"];
        NSDictionary *paremeters = @{@"uid":[Global userId],@"content":content,@"deviceNumber":[Global deviceUUID],@"username":[Global userName]};
        
        [manager POST:url parameters:paremeters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            //NSDictionary *JsonDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];

            [MBProgressHUD hideHUDForView:self.view animated:NO];
            [MBProgressHUD showSuccess:@"发布成功"];
            
            [_dataArray removeAllObjects];
            [self loadData];
            // 发布一条微博
            //[self addMicroblogWithContent:content];
            
            //[self.tableView reloadData];
            
            //加载提示框
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [MBProgressHUD showError:@"发布失败"];
            NSLog(@"%@",error);
            //加载提示框
            [MBProgressHUD hideHUDForView:self.view animated:NO];
           
        }];

    };
    
    [pickerView showInView:self.view.window.rootViewController.view animated:YES];
}

#pragma mark -- 添加一条微博

-(void)addMicroblogWithContent:(NSString *)content
{
    dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 hh:mm"];
    NSString *newssetdate = [dateFormatter stringFromDate:[NSDate date]];
    MicroblogModel *model = [[MicroblogModel alloc] init];
    model.newssetdate = newssetdate;
    model.userId = [Global userId];
    model.newscontent = content;
    model.username = [Global userName];
    
    [_dataArray insertObject:model atIndex:0];

}

#pragma mark -- 添加一条微博

-(void)addReplyBlogWithContent:(NSString *)content atIndex:(NSInteger)index
{
    dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MM月dd日 hh:mm"];
    MicroblogModel *model = _dataArray[index];
    NSString *newscontent = [NSString stringWithFormat:@"%@@%@:  %@ --%@",[Global userName],model.username, content,[dateFormatter stringFromDate:[NSDate date]]];
    model.newscontent = [NSString stringWithFormat:@"%@\n%@",[_dataArray[index] newscontent],newscontent];
    

    // 只刷新本条微博
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
    [button addTarget:self action:@selector(writeMicroblog) forControlEvents:UIControlEventTouchUpInside];
    
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
