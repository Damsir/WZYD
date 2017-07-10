//
//  DocDetailVC.m
//  XAYD
//
//  Created by songdan Ye on 16/4/5.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "DocDetailVC.h"
#import "SPDetailModel.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworking.h"
#import "Global.h"
#import "FormViewController.h"
//打开表单的模型和打印报表的模型一样
#import "PrintFromModel.h"
#import "FileViewController.h"
//打开公文正文的模型和材料清单一样
#import "MaterialModel.h"
#import "MaterialItems.h"

#import "CYQYModel.h"

#import "SHCover.h"
#import "CyHistory.h"

#import "CyHistory.h"
#import "PLogViewController.h"

#import "TransFormStyleVC.h"




@interface DocDetailVC ()<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, assign) NSInteger currentData1Index;

@property (nonatomic,strong) NSString *tempAdviceS;

//保存表单数据
@property (nonatomic,strong) NSArray *dataArray;
//保存正文数组
@property (nonatomic,strong) NSArray *mainBodyArray;


//导航栏右侧按钮(打开表单)
@property (nonatomic,strong)UIButton *rightBtn;
//(公文正文按钮)
@property (nonatomic,strong)UIButton *mainBodyBtn;

@property (nonatomic,strong)UIView *popView;

//蒙板
@property (nonatomic,strong) UIView *cover;


@property (nonatomic,strong) NSArray *titleArray1;

//流转方式
@property (nonatomic,strong)UILabel *selectedSty;

//流转方式的View
@property (nonatomic,strong)UIView *transformStyle;


//流转方式直线上
@property (nonatomic,strong)UIView *line1;

//流转方式直线下
@property (nonatomic,strong)UIView *line2;
//箭头
@property (nonatomic,strong)UIImageView *jiantouI;



//打开表单
@property (nonatomic,strong)UIButton *forms;
//传阅记录
@property (nonatomic,strong)UIButton *cyHistory;

//签阅记录
@property (nonatomic,strong)UIButton *xmForms;

//公文日志
@property (nonatomic,strong)UIButton *gwLog;
@property (nonatomic,strong)UIView *bgView;
//导航栏选择位置

@end

@implementation DocDetailVC


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
    if ([self.currentState isEqualToString:@"2"]) {
//        self.adviseTextv.hidden = YES;
//        [self.comfirmBtn setTitle:@"传阅" forState:UIControlStateNormal];
    }
    if([self.currentState isEqualToString:@"3"])
    {
        self.adviseTextv.hidden = NO;
//        [self.comfirmBtn setTitle:@"签阅" forState:UIControlStateNormal];
    }
    
    if([self.dataType isEqualToString:@"zbgwlist"])
    {
//        [self.comfirmBtn setTitle:@"发送" forState:UIControlStateNormal];
    
    }
    if([self.dataType isEqualToString:@"ybgwlist"])
    {
        self.comfirmBtn.hidden = YES;
        self.adviseTextv.hidden = YES;
        _transformStyle.hidden = YES;
        
        
    }
    //清空状态用来判断流转状态是否选择
    
    self.currentState = @"";
}
- (void)setSpModel:(SPDetailModel *)spModel
{
    _spModel = spModel;
 
}


- (void)setCqModel:(CYQYModel *)cqModel
{

    _cqModel= cqModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *bgView=[[UIView alloc] initWithFrame:CGRectMake(0, -64, MainR.size.width, 64)];
    bgView.backgroundColor =[UIColor whiteColor];
    _bgView = bgView;
    [self.view addSubview:_bgView];
    //创建顶部头部视图
    [self createTopInformTableView];
    //设置标题
    self.title = @"公文详情";
    //设置边框
    [self setBoard];
//    //设置公文正文按钮
//    [self setShowDtail];
    //修改初始化数据
    [self amentInitData];
    //设置意见textView的代理
    _adviseTextv.delegate=self;
    //设置textView的键盘样式
    _adviseTextv.returnKeyType = UIReturnKeyDone;
    //给传阅或者签阅按钮添加响应事件
//    if (MainR.size.width>414) {
//        self.confirmBtnleftC.constant =self.confirmBtnRightC.constant = 80;
//    }
    
    [self.comfirmBtn addTarget:self action:@selector(sendTo) forControlEvents:UIControlEventTouchUpInside];
     //导航栏右侧更多
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom ];
    btn.frame = CGRectMake(0, 0, 20, 20) ;
    [btn setImage:[UIImage imageNamed:@"iconfont-gengduom"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(popSelectionV) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *b =[[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.rightBarButtonItem = b;

    
    //加载表单数据
    [self loadForm];
    //加载公文正文
    [self loadMainBody];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    CGFloat y =0;
       y=CGRectGetMaxY(_adviseTextv.frame);
    _titleArray1 =[NSArray array];
     if([self.dataType isEqualToString:@"zbgwlist"]||[self.dataType isEqualToString:@"ybgwlist"])
     {
    
        _titleArray1 = [NSMutableArray arrayWithObjects: @"发送", @"传阅", @"签阅",nil];
     }
    else
    {
        if([_selectedIndex isEqualToString:@"0"])
        {
            _titleArray1 = [NSMutableArray arrayWithObjects:@"阅毕", @"续传",nil];
            
        }
        if ([_selectedIndex isEqualToString:@"1"])
        {
            _titleArray1 = [NSMutableArray arrayWithObjects:@"续传",nil];
        }
    }
    
    
    self.titleArray = @[_titleArray1];

    [self createTransformStyle];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentTransStyle:) name:@"TransfStyle" object:nil];
    
    // 注册键盘尺寸监听的通知
    [[NSNotificationCenter  defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification  object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(docDetailChanged) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    
    
}
//屏幕旋转结束执行的方法
- (void)docDetailChanged
{
//    self.view.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height);
    self.topInformationT.frame = CGRectMake(0, 0, MainR.size.width, 176);
    [self.topInformationT reloadData];
    
    CGFloat y=CGRectGetMaxY(_adviseTextv.frame)+10;
    
    
    if(MainR.size.width == 320)
    {
        y = y-105;
        
    }
    
    _transformStyle.frame = CGRectMake(0, y, MainR.size.width, 44);
    _line1.frame = CGRectMake(0, 0, MainR.size.width, 1);
    _line2.frame = CGRectMake(0, 44, MainR.size.width, 1);
    CGFloat w=0;
    if (MainR.size.width>414) {
        w=10;
    }
//    UILabel *tipLabe =[[UILabel alloc] initWithFrame:CGRectMake(10+5, 0, MainR.size.width/2.0, 44)];
      _jiantouI.frame = CGRectMake(MainR.size.width-30, 10, 20,20 );
    
    
   _selectedSty.frame =CGRectMake(MainR.size.width-90, 0,100, 44);
   
    
    //蒙版
    _cover.frame  =[UIScreen mainScreen].bounds;
    self.popView.frame= CGRectMake(MainR.size.width-155, 64, 140, 176);
    
    
}
- (void)currentTransStyle:(NSNotification *)text
{
    
    NSString *str =text.userInfo[@"selected"];
    NSInteger i= [str integerValue];
    if (i!=-1) {
        NSString *suStyle=[_titleArray1 objectAtIndex:i];
        
        [_selectedSty setText:suStyle];
    }
 
    
}

- (void)createTransformStyle
{
    
    
   CGFloat y=CGRectGetMaxY(_adviseTextv.frame)+10;

    
    if(MainR.size.width == 320)
    {
        y = y-105;
    
    }
    
    UIView *transformStyle = [[UIView alloc] initWithFrame:CGRectMake(0, y, MainR.size.width, 44)];
    transformStyle.backgroundColor =[UIColor whiteColor];
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainR.size.width, 1)
                     ];
    line1.backgroundColor =RGB(238, 238, 238);
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 44, MainR.size.width, 1)];
    line2.backgroundColor =RGB(238, 238, 238);
    _line2= line2;
    [transformStyle addSubview:_line2];
    CGFloat w=0;
    if (MainR.size.width>414) {
        w=10;
    }
    UILabel *tipLabe =[[UILabel alloc] initWithFrame:CGRectMake(10+5, 0, MainR.size.width/2.0, 44)];
    [tipLabe setText:@"流转方式"];
        [tipLabe setTextColor:[UIColor blackColor]];
    [tipLabe setFont:[UIFont systemFontOfSize:17]];
    _transformStyle = transformStyle;

    [transformStyle addSubview:tipLabe];
    
    [self.view addSubview:_transformStyle];
    _line1 =line1;
    [transformStyle addSubview:_line1];
    
    UIImageView *jiantouI = [[UIImageView alloc] initWithFrame:CGRectMake(MainR.size.width-30, 10, 20,20 )];
    jiantouI.image =[UIImage imageNamed:@"jiant"];
    _jiantouI= jiantouI;
    [transformStyle addSubview:_jiantouI];
    
    
    UILabel *selectedSty =[[UILabel alloc] initWithFrame:CGRectMake(MainR.size.width-90, 0,100, 44)];
    [selectedSty setText:@"未选择"];
    if ([_selectedIndex isEqualToString:@"1"] && !([self.dataType isEqualToString:@"zbgwlist"]||[self.dataType isEqualToString:@"ybgwlist"]))
    {
        [selectedSty setText:@"续传"];
    }
    [selectedSty setTextColor:[UIColor lightGrayColor]];
    [selectedSty setFont:[UIFont systemFontOfSize:17]];
    _selectedSty =selectedSty;
    [transformStyle addSubview:_selectedSty];
    
 UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuTapped)];
    [transformStyle addGestureRecognizer:tapGesture];
    
    
}

//流转方式选择
- (void)menuTapped
{

    TransFormStyleVC *tVC=[[TransFormStyleVC alloc] init];
    tVC.datasource = self.titleArray1;
    [ self.nav pushViewController:tVC animated:YES];

}

- (void)popSelectionV
{
    
    SHCover *cover =[SHCover show];
    _cover = cover;
    cover.userInteractionEnabled =YES;
    cover.delegate =self;
    UIView *popView =[[UIView alloc] initWithFrame:CGRectMake(MainR.size.width-155, 64, 140, 176)];
    popView.backgroundColor =[UIColor whiteColor];
     _popView = popView;
    [SHKeyWindow addSubview:popView];
    
    UIButton *forms = [self createBtnWithImageName:@"打开表单" sysTemFont:[UIFont systemFontOfSize:17 ] titleColor:[UIColor blackColor] ];
 
    [ forms addTarget:self action:@selector(openForm) forControlEvents:UIControlEventTouchUpInside];
    forms.frame =CGRectMake(0, 0, popView.frame.size.width,popView.frame.size.height/4.0);
    UIButton *cyHistory = [self createBtnWithImageName:@"传阅记录" sysTemFont:[UIFont systemFontOfSize:17 ] titleColor:[UIColor blackColor]];
    cyHistory.frame =CGRectMake(0, popView.frame.size.height/4.0, popView.frame.size.width, popView.frame.size.height/4.0);
    [cyHistory addTarget:self action:@selector(openCYHistory) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *xmForms = [self createBtnWithImageName:@"签阅记录" sysTemFont:[UIFont systemFontOfSize:17 ] titleColor:[UIColor blackColor]];
    xmForms.frame =CGRectMake(0, popView.frame.size.height*2/4.0, popView.frame.size.width, popView.frame.size.height/4.0);
    
    [xmForms addTarget:self action:@selector(openQYHistory) forControlEvents:UIControlEventTouchUpInside];
    UIButton *gwLog = [self createBtnWithImageName:@"公文日志" sysTemFont:[UIFont systemFontOfSize:17 ] titleColor:[UIColor blackColor]];
    gwLog.frame =CGRectMake(0, popView.frame.size.height*3/4.0, popView.frame.size.width, popView.frame.size.height/4.0);
    
    [gwLog addTarget:self action:@selector(openPLogView) forControlEvents:UIControlEventTouchUpInside];
}

- (UIButton *)createBtnWithImageName:(NSString *)ImageName sysTemFont:(UIFont * )font titleColor:(UIColor *)col
{
    
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:ImageName forState:UIControlStateNormal];
    [btn setFont:font];
    
    [btn setTitleColor:col forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"iconfont-yd"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 13, 0, 0);
    
    [_popView addSubview:btn];
    return btn;
    
}

// 点击蒙板的时候调用
- (void)coverDidClickCover:(SHCover *)cover
{
    // 隐藏pop菜单
    [_popView removeFromSuperview];
    
}


//加载打开正文
-(void)loadMainBody{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // 创建一个参数字典
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    type=smartplan&action=materials&slbh=XZ20150014
    params[@"type"] = @"smartplan";
    params[@"action"]=@"materials";
    
   if ([_dataType isEqualToString:@"zbgwlist"]||[_dataType isEqualToString:@"ybgwlist"])
   {
   params[@"slbh"]=_spModel.slbh;
   
   }else
   {
   
       params[@"slbh"]=_cqModel.bh;

   }
//    NSLog(@"%@?type=smartplan&action=materials&slbh=%@",[Global serverAddress],_spModel.slbh);
     self.mainBodyArray =[NSArray array];
    [manager POST:[Global serverAddress] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *rs = (NSDictionary *)responseObject;
        if ([[rs objectForKey:@"success"] isEqualToString:@"true"]) {
            
            _mainBodyBtn.enabled = YES;
            
            
            NSArray *td= [rs objectForKey:@"result"];
            MaterialModel *mModel;
            NSMutableArray *mulArr =[NSMutableArray array];
            for (NSDictionary *dict in td) {
                mModel = [MaterialModel materialWithDict:dict];
                [mulArr addObject:mModel];
            }
            self.mainBodyArray = [mulArr copy];
            NSLog(@"%@",self.mainBodyArray);
            //   [myRefresh endRefreshing];
            
        }else{
            
                   }
        [MBProgressHUD hideHUDForView:self.view];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        
    }];
}
//打开表单
- (void)openForm
{
    [_popView removeFromSuperview];
    [_cover removeFromSuperview];
    FormViewController *formView = [[FormViewController alloc] initWithNibName:@"FormViewController" bundle:nil];
    if (_dataArray!=nil) {
        PrintFromModel *model=(PrintFromModel *) [_dataArray objectAtIndex:0];
        [formView projectInfo:[PrintFromModel dictionaryWithprintModel:model]];
    }
    
    [self.navigationController pushViewController:formView animated:YES];
}

//打开传阅记录
- (void)openCYHistory
{
    [_popView removeFromSuperview];
    [_cover removeFromSuperview];
    CyHistory *cyHis =[[CyHistory  alloc] init];
    cyHis.dataType =self.dataType;
     cyHis.forwardType = @"0";

    if ([_dataType isEqualToString:@"zbgwlist"]||[_dataType isEqualToString:@"ybgwlist"])
    {
        cyHis.model = self.spModel;
    }else
    {
        
        cyHis.cqModel = self.cqModel;
    }
   
    [self.navigationController pushViewController:cyHis animated:YES];
    


}
//打开签阅记录
- (void)openQYHistory
{
    [_popView removeFromSuperview];
    [_cover removeFromSuperview];
    CyHistory *cyHis =[[CyHistory  alloc] init];
    cyHis.dataType =self.dataType;
    cyHis.forwardType = @"1";
    
    if ([_dataType isEqualToString:@"zbgwlist"]||[_dataType isEqualToString:@"ybgwlist"])
    {
        cyHis.model = self.spModel;
    }else
    {
        
        cyHis.cqModel = self.cqModel;
    }
    
    [self.navigationController pushViewController:cyHis animated:YES];
    
}

//打开公文日志
- (void)openPLogView
{
    [_popView removeFromSuperview];
    [_cover removeFromSuperview];
    PLogViewController *pLog =[[PLogViewController alloc]  init];
    pLog.dataType =self.dataType;
    if ([_dataType isEqualToString:@"zbgwlist"]||[_dataType isEqualToString:@"ybgwlist"])
    {
        [pLog setModel:self.spModel];
    }else
    {
        
        [pLog setCyModel:self.cqModel];
        
    }
    
    [self.navigationController pushViewController:pLog animated:YES];
    
    
}

//加载报表
-(void)loadForm{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // 创建一个参数字典
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //   type=smartplan&action=formlist&projectId=12680
    params[@"type"] = @"smartplan";
    params[@"action"]=@"formlist";
    if ([_dataType isEqualToString:@"zbgwlist"]||[_dataType isEqualToString:@"ybgwlist"])
    {
        params[@"projectId"]=_spModel.ProjectId;
        
    }else
    {
        
        params[@"projectId"]=_cqModel.owner;

        
    }
    
//    //打开表单
//    NSLog(@"%@?type=%@&action=%@&projectId=%@",[Global serverAddress],[params objectForKey:@"type"],[params objectForKey:@"action"],[params objectForKey:@"projectId"]);
    
        _dataArray =[NSArray array];
    [manager POST:[Global serverAddress] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *rs = (NSDictionary *)responseObject;
        if ([[rs objectForKey:@"success"] isEqualToString:@"true"]) {
            NSArray *td= [rs objectForKey:@"result"];
            PrintFromModel *pModel;
            NSMutableArray *mulArr =[NSMutableArray array];
            for (NSDictionary *dict in td) {
                pModel = [PrintFromModel printFromWithDict:dict];
                [mulArr addObject:pModel];
            }
            self.dataArray = [mulArr copy];
                       NSLog(@"%@",self.dataArray);
            //   [myRefresh endRefreshing];
            _rightBtn.enabled = YES;
            
            
        }else{
            self.dataArray = nil;
            
            //            [myRefresh endRefreshing];
        }
        //        [_spDetailTableView reloadData];
        //设置下次取消下拉刷新
        //        _isDropRefersh = NO;
        [MBProgressHUD hideHUDForView:self.view];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        //        [myRefresh endRefreshing];
        //        _isDropRefersh = NO;
        
        
    }];
}

//创建顶部信息tableView
- (void)createTopInformTableView
{
    self.topInformationT.delegate = self;
    self.topInformationT.dataSource = self;
    self.topInformationT.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.topInformationT.scrollEnabled = NO;
   
}
//传阅/签阅按钮点击的响应事件
- (void)sendTo
{
    
    if ([self.selectedSty.text isEqualToString:@"未选择"]) {
         [[[UIAlertView alloc] initWithTitle:@"请选择流转方式" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
    }
    
    
    
       //传阅按钮被点击
    if ([self.selectedSty.text isEqualToString:@"发送"]) {
        NSLog(@"在办按钮被点击");
        SendViewController *svc = [[SendViewController alloc] init];
        //设置代理(SPDetailController)
        svc.delegate = self.sendDelegate;
        [svc projectInfo:[SPDetailModel dictionaryWithGWModel:self.spModel]];
//暂时使用签阅 2
        [svc sendType:0];
        [self.navigationController pushViewController:svc animated:YES];
     
    }
    if([self.selectedSty.text isEqualToString:@"传阅"])//传阅按钮被点击

    {
        NSLog(@"传阅按钮被点击");
        SendViewController *svc = [[SendViewController alloc] init];
        //设置代理(SPDetailController)
        svc.delegate = self.sendDelegate;
        [svc projectInfo:[SPDetailModel dictionaryWithGWModel:self.spModel]];

//        [svc projectInfo:[CYQYModel dictionaryGWCQ:self.cqModel]];

        [svc sendType:2];
        [self.navigationController pushViewController:svc animated:YES];
        
        
    }
    
    
    if([self.selectedSty.text isEqualToString:@"签阅"])//签阅
    {
        NSLog(@"签阅阅按钮被点击");
        SendViewController *svc = [[SendViewController alloc] init];
        //设置代理(SPDetailController)
        svc.delegate = self.sendDelegate;
        [svc projectInfo:[SPDetailModel dictionaryWithGWModel:self.spModel]];

//        [svc projectInfo:[CYQYModel dictionaryGWCQ:self.cqModel]];
        
        [svc sendType:3];
        [self.navigationController pushViewController:svc animated:YES];
    
    }
    if([self.selectedSty.text isEqualToString:@"阅毕"])//传阅按钮被点击
        
    {
        NSLog(@"已阅按钮被点击");
       
        [self submitReadStatus];
        
    }
    if([self.selectedSty.text isEqualToString:@"续传"])//传阅按钮被点击
        
    {
        NSLog(@"续传按钮被点击");
        SendViewController *svc = [[SendViewController alloc] init];
        //设置代理(SPDetailController)
        svc.delegate = self.sendDelegate;
        [svc projectInfo:[CYQYModel dictionaryGWCQ:self.cqModel]];
    
        //传阅
        if ([self.forwordType isEqualToString:@"2"]) {
            [svc sendStutas:0];

        }else//签阅
        {
            [svc sendStutas:1];

        
        }
        [svc sendType:4];
        [self.navigationController pushViewController:svc animated:YES];
        
        
    }
}

-(void)submitReadStatus{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // 创建一个参数字典
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//2.168.2.239/WSYDService/ServiceProvider.ashx?type=smartplan&action=SignOpinionForwardItem&forwardItemId=&opinion=&isFinish=

    params[@"type"] = @"smartplan";
    params[@"action"]=@"SignOpinionForwardItem";
    params[@"forwardItemId"]=self.cqModel.itemid;
    NSString *text =@"";
    if (![self.adviseTextv.text isEqualToString:@"请给出你的意见!"]) {
        text= self.adviseTextv.text;
    }
    params[@"opinion"]=text;
    params[@"isFinish"]=@"true";

    NSMutableString *requestAddress = [NSMutableString stringWithString:[Global serverAddress]];
    [requestAddress appendString:@"?"];
    
    if (nil!=params) {
        for (NSString *key in params.keyEnumerator) {
            NSString *val = [params objectForKey:key];
            [requestAddress appendFormat:@"&%@=%@",key,val];
        }
    }
    
    NSLog(@"阅毕%@",requestAddress);
    
    self.mainBodyArray =[NSArray array];
    [manager POST:[Global serverAddress] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *rs = (NSDictionary *)responseObject;
        if ([[rs objectForKey:@"success"] isEqualToString:@"true"]) {
            
            [MBProgressHUD showSuccess:@"已阅毕" toView:[self.navigationController.viewControllers objectAtIndex:0].view];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
        
        }else{
            [MBProgressHUD showSuccess:@"无法修改未读状态" toView:self.view];
        }
        [MBProgressHUD hideHUDForView:self.view];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        
    }];
}

//-(void)sendToRead{
//    if (_isForward) {
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        manager.responseSerializer = [AFJSONResponseSerializer serializer];
//        NSDictionary *parameters = @{@"user":[Global myuserId],@"type":@"smartplan",@"action":@"finishforward",@"forward":[_project objectForKey:@"forward"]};
//        
//        [manager POST:[Global serverAddress] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            [DejalBezelActivityView removeViewAnimated:YES];
//            NSDictionary *rs = (NSDictionary *)responseObject;
//            if ([[rs objectForKey:@"success"] isEqualToString:@"true"]) {
//                [self.sendDelegate sendViewDidSendCompleted];
//            }else{
//                [self forwardFaild];
//            }
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            [DejalBezelActivityView removeViewAnimated:YES];
//            [self forwardFaild];
//        }];
//    }else{
//        SendViewController *svc = [[SendViewController alloc] init];
//        svc.delegate = self;
//        [svc projectInfo:_project];
//        [svc sendType:2];
//        [self.navigationController pushViewController:svc animated:YES];
//    }
//}

-(void)forwardFaild{
    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"操作失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
}



-(void)sendViewDidSendCompleted{
    [self.navigationController popToViewController:self animated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==0)
    {
//        [_signText becomeFirstResponder];
    }
}

//修改初始化化数据
- (void)amentInitData
{

    if (MainR.size.width == 320) {
        self.adviseTFHeightC.constant = 100;
    }
    
    
    //设置意见箱默认的文字以及颜色
    self.adviseTextv.text = @"请给出你的意见!";
    if ([self.adviseTextv.text  isEqualToString: @"请给出你的意见!"]) {
        self.adviseTextv.textColor =[UIColor lightGrayColor];
    }
    else
    {
        self.adviseTextv.textColor = [UIColor blackColor];
    }
}

- (void)commitAdvise
{
    if([_adviseTextv.text isEqualToString:@"请给出你的意见!"] )
    {
        [MBProgressHUD showError:@"意见不能为空!"];
    }
    if (_adviseTextv.text!=nil&&![_adviseTextv.text isEqualToString:@"请给出你的意见!"]) {
        //提交意见
        
        _tempAdviceS = nil;
        _adviseTextv.text = @"请给出你的意见!";
        _adviseTextv.textColor =[UIColor lightGrayColor];
    }
}


- (void)keyboardWillChange:(NSNotification  *)note
{
    
    //
    //    _loadBtn.hidden = YES;
    //    _tipLabel.hidden= YES;
    // 获取键盘弹出的动画时间
    CGFloat durtion = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 获取键盘的frame
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (frame.origin.y == MainR.size.height) { // 没有弹出键盘
        [UIView animateWithDuration:durtion animations:^{
            
            self.view.transform =  CGAffineTransformIdentity;
        }];
    }else{ // 弹出键盘
        // 工具条往上移动258
        [UIView animateWithDuration:durtion animations:^{
            
            
            //            self.bgScrollView.transform = CGAffineTransformMakeTranslation(0,-frame.size.height+self.tabBarController.tabBar.frame.size.height);
            //            self.view.transform = CGAffineTransformMakeTranslation(0,-frame.size.height);
            self.view.transform = CGAffineTransformMakeTranslation(0,-self.adviseTextv.frame.origin.y);
            
            
            
            
        }];
        
    }
    
}



#pragma mark - UITextView Delegate Methods

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
     if ([text isEqualToString:@"\n"]) {
        if (_adviseTextv.text.length==0) {
            _adviseTextv.textColor =[UIColor lightGrayColor];
            _adviseTextv.text = @"请给出你的意见!";
        }
        else
        {
            _adviseTextv.textColor = [UIColor blackColor];
            _tempAdviceS = _adviseTextv.text;
            
        }
        [textView resignFirstResponder];
        
        
        return NO;
    }
    return YES;
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (_tempAdviceS.length !=nil) {
        _adviseTextv.text = _tempAdviceS;
    }
    else
    {
        
        _adviseTextv.text= @"";
    }
    _adviseTextv.textColor =[UIColor blackColor];
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.adviseTextv resignFirstResponder];
}



//设置边框
- (void)setBoard
{
    //设置textView的圆弧
    self.adviseTextv.layer.borderWidth = 0.5;
    self.adviseTextv.layer.cornerRadius = 6;
    self.adviseTextv.layer.borderColor =[UIColor lightGrayColor].CGColor;
    self.adviseTextv.clipsToBounds = YES;



}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//
//点击公文正文后执行的方法
- (void)showDetail:(id)sender {
    
//    NSLog(@"公文正文被点击");
//    FileViewController *fvc = [[FileViewController alloc] init];
//    MaterialModel *model = (MaterialModel *)[_mainBodyArray objectAtIndex:0];
//    if(model.files.count!=0)
//    {
//    
//        MaterialItems *mDetailModel=[model.files objectAtIndex:0];
//        NSString *fileId = [NSString stringWithFormat:@"%@_%@",model.instanceid,mDetailModel.identity];
//        NSString *downloadUrl = [NSString stringWithFormat:@"%@?type=smartplan&action=downloadmaterial&fileId=%@",[Global serverAddress],mDetailModel.identity];
//        [fvc openFile:fileId url:downloadUrl ext:mDetailModel.ext];
//        [self presentViewController:fvc animated:YES completion:nil];
//    }
//    else
//    {
//    
//        [[[UIAlertView alloc] initWithTitle:@"暂无正文信息" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
//    }
    
}

#pragma -mark  UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    cell.userInteractionEnabled = NO;
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    CGFloat w=0;
    
    if(MainR.size.width>414)
    {
        w=10;
    
    }
    
    //cell左侧label
    UILabel *leftLabel=[[UILabel alloc]initWithFrame:CGRectMake(10+w,0, 80, 44)];
    leftLabel.font=[UIFont systemFontOfSize:17];
    leftLabel.textColor=[UIColor blackColor];
    [leftLabel setTextAlignment:NSTextAlignmentLeft];
    [cell.contentView addSubview:leftLabel];
    //cell右侧label
    UILabel *rightLabel=[[UILabel alloc]initWithFrame:CGRectMake(MainR.size.width-MainR.size.width/2-20-w,0, MainR.size.width/2-10+20, 44)];
    rightLabel.numberOfLines = 0;
    rightLabel.font=[UIFont systemFontOfSize:15];
    rightLabel.textColor=[UIColor darkGrayColor];
    [rightLabel setTextAlignment:NSTextAlignmentRight];
    [cell.contentView addSubview:rightLabel]; //cell左侧label
  
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 43, MainR.size.width, 1)];
    line.backgroundColor=RGB(238.0, 238.0, 238.0);
    [cell.contentView addSubview:line];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([_dataType isEqualToString:@"zbgwlist"]||[_dataType isEqualToString:@"ybgwlist"])
    {
        if(indexPath.row == 0)
        {
            if ([_selectedIndex isEqualToString:@"0"])
            {
                [leftLabel setText:@"来文号"];
            }
            else if ([_selectedIndex isEqualToString:@"1"])
            {
                [leftLabel setText:@"发文号"];
            }
            else
            {
                [leftLabel setText:@"文号"];
            }
            
            [rightLabel setText:_spModel.slbh];
        }
        if(indexPath.row == 1)
        {
            [leftLabel setText:@"标题"];
            //        [rightLabel setText:_spModel.projectName];
            [rightLabel setText:_spModel.projectName];
        }
        if(indexPath.row ==2)
        {
            [leftLabel setText:@"发文日期"];
            NSArray *arr=[_spModel.time componentsSeparatedByString:@"/"];
            NSString *subString =[arr objectAtIndex:2];
            NSString *year =[arr objectAtIndex:0];
            NSString *month =[arr objectAtIndex:1];
            NSArray *temparr= [subString componentsSeparatedByString:@" "];
            NSString *day=[temparr objectAtIndex:0];
            
            [rightLabel setText:[NSString stringWithFormat:@"%@年%@月%@日",year,month,day]];
        }
        if(indexPath.row == 3)
        {
            [leftLabel setText:@"公文正文"];
            [leftLabel setTextColor:[UIColor blackColor]];
            cell.userInteractionEnabled = YES;
            
            UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(MainR.size.width-90, 0, 80, 44);
            //        btn.backgroundColor =[UIColor blueColor];
            [btn setImage:[UIImage imageNamed:@"huixingz"] forState:UIControlStateNormal];
            
            [btn addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];
            btn.enabled = NO;
            _mainBodyBtn = btn;
            [cell.contentView addSubview:_mainBodyBtn];
            
        }
    }else
    {
        
        if(indexPath.row == 0)
        {
            [leftLabel setText:@"发文号"];
            [rightLabel setText:_cqModel.bh];
        }
        if(indexPath.row == 1)
        {
            [leftLabel setText:@"标题"];
            //        [rightLabel setText:_spModel.projectName];
            [rightLabel setText:_cqModel.name];
        }
        if(indexPath.row ==2)
        {
            [leftLabel setText:@"发文日期"];
            NSArray *arr=[_cqModel.time componentsSeparatedByString:@"-"];
            NSString *subString =[arr objectAtIndex:2];
            NSString *year =[arr objectAtIndex:0];
            NSString *month =[arr objectAtIndex:1];
            NSArray *temparr= [subString componentsSeparatedByString:@" "];
            NSString *day=[temparr objectAtIndex:0];
            
            [rightLabel setText:[NSString stringWithFormat:@"%@年%@月%@日",year,month,day]];
        }
        if(indexPath.row == 3)
        {
            [leftLabel setText:@"公文正文"];
            [leftLabel setTextColor:[UIColor blackColor]];
            cell.userInteractionEnabled = YES;
            
            UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(MainR.size.width-90-w, 0, 80, 44);
            //        btn.backgroundColor =[UIColor blueColor];
            [btn setImage:[UIImage imageNamed:@"huixingz"] forState:UIControlStateNormal];
            
            [btn addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];
            btn.enabled = NO;
            _mainBodyBtn = btn;
            [cell.contentView addSubview:_mainBodyBtn];
            
        }
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
//
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}





@end
