//
//  SHBaseViewController.m
//  WZYD
//
//  Created by 吴定如 on 17/5/16.
//  Copyright © 2017年 dist. All rights reserved.
//

#import "SHBaseViewController.h"

@interface SHBaseViewController ()

@property (nonatomic,strong) UIButton *emptyButton;
/** Reachability */
@property (nonatomic,weak) Reachability *hostReach;
/** NotReachableRemind */
@property (nonatomic,strong) UILabel *remindLabel;

@end

@implementation SHBaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)dealloc {
    // 移除通知和监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //[[self.view removeObserver:self forKeyPath:@"frame" context:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initWithTableView];
    
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.dist.com.cn"];
    self.hostReach = reach;
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(networkStatusChange:) name:kReachabilityChangedNotification object:nil];
    //实现监听
    [reach startNotifier];
    
    // 监听屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
}

#pragma mark -- 屏幕旋转
- (void)screenRotation:(NSNotification *)noty {
    
    _remindLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    _emptyButton.center = self.tableView.center;
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}

#pragma mark -- 初始化表格
- (void)initWithTableView {
    
    UITableView *tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [[UIView alloc] init];
    self.tableView = tableView;
    
    [self.view addSubview:tableView];
}

#pragma mark -- 无数据提示
- (void)showEmptyData {
    
    if (!_emptyButton) {
        UIButton *emptyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //        emptyButton.backgroundColor = [UIColor orangeColor];
        emptyButton.frame = CGRectMake(0, 0, 113, 160);
        emptyButton.center = self.tableView.center;
        [emptyButton setTitle:@"暂无数据" forState:UIControlStateNormal];
        [emptyButton setImage:[UIImage imageNamed:@"empty_data"] forState:UIControlStateNormal];
        [emptyButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 160-113, 0)];
        [emptyButton setTitleEdgeInsets:UIEdgeInsetsMake(113, -113, 0, 0)];
        // 按钮对齐方式设置
        emptyButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        emptyButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [emptyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [emptyButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        //    [button addTarget:self action:@selector(buttonOnclick:) forControlEvents:UIControlEventTouchUpInside];
        emptyButton.enabled = NO;
        _emptyButton = emptyButton;
        
        [self.tableView addSubview:emptyButton];
    }
    
    //    UIImageView *emptyImage = [[UIImageView alloc] init];
    //    emptyImage.frame = CGRectMake(0, 0, 113, 113);
    //    emptyImage.image = [UIImage imageNamed:@"empty_data"];
    //    emptyImage.center = _tableView.center;
    //    _emptyImage = emptyImage;
    //
    //    [_tableView addSubview:emptyImage];
}

#pragma mark -- 移除无数据提示
- (void)removeEmptyData;
{
    if (_emptyButton) {
        [_emptyButton removeFromSuperview];
        _emptyButton = nil;
    }
    
    //    UIImageView *emptyImage = [[UIImageView alloc] init];
    //    emptyImage.frame = CGRectMake(0, 0, 113, 113);
    //    emptyImage.image = [UIImage imageNamed:@"empty_data"];
    //    emptyImage.center = _tableView.center;
    //    _emptyImage = emptyImage;
    //
    //    [_tableView addSubview:emptyImage];
    
}

#pragma mark -- tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[UITableViewCell alloc] init];
}

// 导航栏标题
- (void)initNavigationBarTitle:(NSString *)title
{
    UILabel *lab      = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-100, 40)];
    lab.textColor     = [UIColor whiteColor];
    lab.font          = [UIFont boldSystemFontOfSize:17.0];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text          = title;
    
    self.navigationItem.titleView = lab;
}

// 导航栏左侧标题
- (UIButton *)createNavigationLeftBarButtonTitle:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    //    button.backgroundColor = [UIColor orangeColor];
    button.frame = CGRectMake(0, 0, 80, 30);
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:Font_PingFangSC_Light size:14.0]];
    [button.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [button setTitleColor:BLUECOLOR forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    return button;
}

// 导航栏右侧标题
- (UIButton *)createNavigationRightBarButtonTitle:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    //    button.backgroundColor = [UIColor orangeColor];
    button.frame = CGRectMake(0, 0, 80, 30);
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:Font_PingFangSC_Light size:14.0]];
    [button.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [button setTitleColor:BLUECOLOR forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    return button;
    
}

#pragma mark -- CustomButton
- (UIButton *)createCustomButtonWithTitle:(NSString *)title {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.backgroundColor = BLUECOLOR;
    button.frame = CGRectMake(0, 0, 80, 30);
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:Font_PingFangSC_Regular size:16.0]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 3.0;
    button.clipsToBounds = YES;
    
    return button;
}

// 纯色图片
- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 35);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark -- 对字典做删除null处理
- (NSDictionary *)deleteNullWithDictionary:(NSDictionary *)dic{
    
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
    for (NSString *key in dic.allKeys) {
        
        if ([[dic objectForKey:key] isEqual:[NSNull null]]) {
            
            [mutableDic setObject:@"" forKey:key];
        }else{
            [mutableDic setObject:[dic objectForKey:key] forKey:key];
        }
    }
    return mutableDic;
}

#pragma mark --  MARK: 处理网络监听 , 连接改变
- (void)networkStatusChange:(NSNotification *)noty {
    
    Reachability *currentReach = [noty object];
    NSParameterAssert([currentReach isKindOfClass: [Reachability class]]);
    [self updateInterfaceWithReachability:currentReach];
}

// 处理连接改变后的情况
- (void)updateInterfaceWithReachability:(Reachability *) currentReach {
    //    NSLog(@"网络状况发生改变");
    // 对连接改变做出响应的处理动作。
    self.status = [currentReach currentReachabilityStatus];
    if (self.status == NotReachable) {
        //        NSLog(@"请设置网络");
        [self showNotReachableRemind];
    } else {
        //        NSLog(@"有网络");
        [self removeNotReachableRemind];
    }
}

// 无网络连接提醒
- (void)showNotReachableRemind {
    
    if (!_remindLabel) {
        UILabel *remindLabel = [UILabel new];
        remindLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
        remindLabel.text = @"当前网络不可用, 请检查你的网络设置";
        remindLabel.backgroundColor = [UIColor colorWithRed:208/255.0f green:228/255.0f blue:240/255.0f alpha:1.0];
        remindLabel.textColor = [UIColor colorWithRed:56/255.0f green:154/255.0f blue:216/255.0f alpha:1.0];
        remindLabel.textColor = [UIColor darkGrayColor];
        remindLabel.font = [UIFont systemFontOfSize:15.0];
        remindLabel.textAlignment = NSTextAlignmentCenter;
        _remindLabel = remindLabel;
        self.tableView.tableHeaderView = remindLabel;
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //            [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        //                self.tableView.tableHeaderView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0);
        //                self.tableView.tableHeaderView = nil;
        //            } completion:^(BOOL finished) {
        //
        //            }];
        //        });
    }
}

// 移除无网络提醒
- (void)removeNotReachableRemind {
    
    if (_remindLabel) {
        //        self.tableView.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
        self.tableView.tableHeaderView = nil;
        [_remindLabel removeFromSuperview];
        _remindLabel = nil;
    }
}

#pragma mark -- CheckNetworkStatus
- (BOOL)checkeNetStatue {
    
    if (self.status == NotReachable) {
        NSLog(@"请设置网络");
        return NO;
    } else {
        return YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
