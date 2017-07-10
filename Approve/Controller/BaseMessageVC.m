//
//  BaseMessageVC.m
//  XAYD
//
//  Created by dingru Wu on 16/7/19.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "BaseMessageVC.h"
#import "SPDetailModel.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworking.h"
#import "Global.h"
#import "PopSignUtil.h"
#import "BaseMessageCell.h"
#import "BaseAdviceCell.h"
#import "AdviceModel.h"
#import "MJExtension.h"
#import "BaseInfoModel.h"
#import "PLogViewController.h"

#define Space @"                     "
static NSDateFormatter *dateFormattor;


@interface BaseMessageVC ()<UIScrollViewDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIAlertViewDelegate>

@property (nonatomic,strong)UITableView *baseTableView;
//为了确保第二次输入时文本框的内容为nil
@property (nonatomic,strong)NSString *tempAdviceS;
@property (nonatomic,strong)NSDictionary *signInfo;

@property(nonatomic,strong) NSMutableArray *markArray;//标记数组(分组收放)
@property(nonatomic,strong) NSMutableArray *groupImgArray;//分组图标
@property(nonatomic,strong) NSMutableArray *detailArray_in;//详细信息
@property(nonatomic,strong) NSMutableArray *detailArray_out;
@property(nonatomic,strong) UITextView *textView;//意见框
@property(nonatomic,strong) UIView *footView;
@property(nonatomic,strong) UIView *footLine;
@property(nonatomic,strong) UIButton *saveBtn;//保存意见
@property(nonatomic,strong) UIButton *backBtn;//回退
@property(nonatomic,strong) UIButton *sendBtn;//发送
@property(nonatomic,strong) NSArray *adviceArray;//意见数组
@property(nonatomic,strong) UIActionSheet *actionSheet;//签名提示框

@property(nonatomic,strong) BaseInfoModel *baseInfoModel;
@property(nonatomic,strong) NSArray *formIdArray;//表单Id
@property(nonatomic,strong) NSMutableArray *baseInfoArray;//表单数据

@end

@implementation BaseMessageVC

-(NSDictionary *)data
{
    if (_data==nil) {
        _data=[NSDictionary dictionary];
    }
    return _data;
}

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
   // NSLog(@"55555555%@",_model);
    _signInfo =[NSDictionary dictionary];
    
    self.view.backgroundColor =[UIColor whiteColor];
    _tempAdviceS = [NSString string];
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, MainR.size.height-114-220) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    // YB
    if (!([_Id isEqualToString:@"YB"]||[_Id isEqualToString:@"xmcx"]||[_Id isEqualToString:@"gwcx"]) )
    {
        tableView.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height-114-220);
    }
    else
    {
        tableView.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height-114);
    }
    tableView.delegate = self;
    tableView.dataSource = self;
    //tableView.backgroundColor = [UIColor orangeColor];
    //tableView.tableFooterView = [[UIView alloc] init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.hidden = YES;
    _baseTableView = tableView;
    [self.view addSubview:_baseTableView];
    
    [tableView registerNib:[UINib nibWithNibName:@"BaseMessageCell" bundle:nil] forCellReuseIdentifier:@"BaseMessageCell"];

    
    [self createFootView];
    // 加载数据
    [self loadData];
    
    //键盘唤起和隐藏的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    [self createNotification];
    
}
-(void)createNotification
{
    //屏幕旋转通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation:) name:UIDeviceOrientationDidChangeNotification object:nil];
}
//屏幕旋转改变视图的Frame
-(void)screenRotation:(NSNotification *)noti
{
//    self.view.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height);
//    if (_footView.hidden == YES)
//    {
//        _baseTableView.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height-114);
//    }
//    else
//    {
//        _baseTableView.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height-114-220);
//    }
    
    if (!([_Id isEqualToString:@"YB"]||[_Id isEqualToString:@"xmcx"]||[_Id isEqualToString:@"gwcx"]))
    {
        _baseTableView.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height-114-220);
    }
    else
    {
        _baseTableView.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height-114);
    }
    
    _footView.frame = CGRectMake(0, MainR.size.height-220-64-50, MainR.size.width, 220);
    _footLine.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
    _textView.frame = CGRectMake(10, 10, MainR.size.width-20, 140);
  
    CGFloat btn_W = (MainR.size.width-40)/3;
    _saveBtn.frame = CGRectMake(10, _footView.frame.size.height-60, btn_W, 40);
    _sendBtn.frame = CGRectMake(CGRectGetMaxX(_saveBtn.frame)+10, _saveBtn.frame.origin.y, btn_W, 40);
    _backBtn.frame = CGRectMake(CGRectGetMaxX(_sendBtn.frame)+10, _saveBtn.frame.origin.y, btn_W, 40);
    
    [_baseTableView reloadData];
    

}

-(void)loadData
{
    //加载提示框
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    /**
     *  是否可以发送
     */
    NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/form/SendEnable.ashx"];
    NSDictionary *parameters = [NSDictionary dictionary];
    
//    if (_model.ProjectId)
//    {
//        parameters = @{@"project":_model.ProjectId,@"user":[Global userName],@"deviceNumber":DeviceId,@"username":[Global userName]};
//    }
//    else if (_model.Id)
//    {
//        parameters = @{@"project":_model.Id,@"user":[Global userName],@"deviceNumber":DeviceId,@"username":[Global userName]};
//    }
//    
//    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//         if ([[responseObject objectForKey:@"result"] isEqual:@1])
//         {
//             _footView.hidden = NO;
//         }
//         else
//         {
//             // 不能发送 & 回退
//             _footView.hidden = NO;
//         }
//         
//         [self changeTableViewFrame];
//         
//     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//         //
//         _footView.hidden = YES;
//         NSLog(@"%@",error);
//     }];

    /**
     *  是否可以签字
     */
    _adviceArray = [NSArray array];
    url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/form/SignInfo.ashx"];

    // projectType=1  项目
    // projectType=2  公文
    NSString *projectType = @"";
    if ([_spOrgw isEqualToString:@"gw"])
    {
        projectType = @"2";
    }else
    {
        projectType = @"1";
    }
    if (_model.ProjectId)
    {
        parameters = @{@"project":_model.ProjectId,@"projectType":projectType,@"user":[Global userId],@"deviceNumber":[Global deviceUUID],@"username":[Global userName]};
    }
    else if (_model.Id)
    {
        parameters = @{@"project":_model.Id,@"projectType":projectType,@"user":[Global userId],@"deviceNumber":[Global deviceUUID],@"username":[Global userName]};
    }
    
    NSMutableString *requestAddress = [NSMutableString stringWithString:[Global serverAddress]];
    [requestAddress appendString:@"?"];
    if (nil!=parameters) {
        for (NSString *key in parameters.keyEnumerator) {
            NSString *val = [parameters objectForKey:key];
            [requestAddress appendFormat:@"&%@=%@",key,val];
        }
    }
    
    NSLog(@"签字signInfo:%@",requestAddress);
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSArray *result = [responseObject objectForKey:@"result"];
         if (result.count)
         {
             _adviceArray = result;
             // 可以签字(有权限)
             _saveBtn.backgroundColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:239/255.0 alpha:1.0];
             [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
             _saveBtn.enabled = YES;
         }
         else
         {
             // 不能签字
//             _saveBtn.backgroundColor = GRAYCOLOR;
//             [_saveBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//             _saveBtn.enabled = NO;
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"%@",error);
     }];
    
    
    _baseInfoArray = [NSMutableArray array];
    _detailArray_in = [NSMutableArray array];
    _detailArray_out = [NSMutableArray array];
    
    

    /**
     *  表单
     */
    // 1.表单数据需要先请求表单列表
    url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/form/FormList.ashx"];
    if (_model.ProjectId)
    {
        parameters = @{@"project":_model.ProjectId,@"deviceNumber":[Global deviceUUID],@"username":[Global userName]};
    }
    else if (_model.Id)
    {
        parameters = @{@"project":_model.Id,@"deviceNumber":[Global deviceUUID],@"username":[Global userName]};
    }

    NSMutableString *requestAddres = [NSMutableString stringWithString:[Global serverAddress]];
    [requestAddres appendString:@"?"];
    if (nil!=parameters) {
        for (NSString *key in parameters.keyEnumerator) {
            NSString *val = [parameters objectForKey:key];
            [requestAddres appendFormat:@"&%@=%@",key,val];
        }
    }
    
    NSLog(@"信息:%@",requestAddres);
    // 1.表单数据需要先请求表单列表
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        _formIdArray = [dic objectForKey:@"result"];
        
        // 有表单
        if (_formIdArray.count)
        {
            _markArray = [NSMutableArray array];
            _groupImgArray = [NSMutableArray array];
            for (int i=0; i<_formIdArray.count; i++)
            {
                NSString *mark = @"";
                NSString *image = @"";
                if (i==0)
                {
                    mark = @"1";
                    image = @"xiangshang";
                }
                else
                {
                    mark = @"0";
                    image = @"zhankai";
                }
                [_groupImgArray addObject:image];
                [_markArray addObject:mark];
                
            }
            
            NSString *Id = [_formIdArray[0] objectForKey:@"Id"];
            NSString *ProjectId = [_formIdArray[0] objectForKey:@"ProjectId"];
            NSString *BusiFormId = [_formIdArray[0] objectForKey:@"BusiFormId"];
            
            NSDictionary *parameters = @{@"form":Id,@"busiFormId":BusiFormId,@"project":ProjectId,@"user":[Global userId],@"deviceNumber":[Global deviceUUID],@"username":[Global userName]};
            NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/form/FormDetail.ashx"];
            
            // 2.表单信息
            [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
                
                // 每个表单信息
                for (NSDictionary *dic in [responseObject objectForKey:@"result"])
                {
                    _baseInfoModel = [[BaseInfoModel alloc] initWithDictionary:dic];
                    if (![_baseInfoModel.text isEqualToString:@""] && ![_baseInfoModel.text isEqualToString:@"处长签字"] && ![_baseInfoModel.text isEqualToString:@"处室经办整理办理人签名"]) {
                        
                        [_baseInfoArray addObject:_baseInfoModel];
                    }
                }
                _baseTableView.hidden = NO;
                [_baseTableView reloadData];
                
                //加载提示框
                [MBProgressHUD hideHUDForView:self.view animated:NO];
                
            }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                //加载提示框
                [MBProgressHUD hideHUDForView:self.view animated:NO];
                NSLog(@"%@",error);
            }];
        }
        else{
            // 无表单
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            [MBProgressHUD showError:@"缺少移动表单!"];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //加载提示框
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        NSLog(@"%@",error);
    }];
    
}

-(void)changeTableViewFrame
{
//    if (_footView.hidden == YES)
//    {
//        _baseTableView.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height-114);
//    }
//    else
//    {
//        _baseTableView.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height-113-220);
//    }
}

#pragma -- footView
-(void)createFootView
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-220-64-50, SCREEN_WIDTH, 220)];
    //footView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    footView.backgroundColor = [UIColor whiteColor];
    
    UIView *footLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    footLine.backgroundColor = GRAYCOLOR_MIDDLE;
    _footLine = footLine;
    [footView addSubview:footLine];

    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, MainR.size.width-20, 140)];
    textView.text = @"请输入您的意见...";
    textView.textColor = [UIColor blueColor];
    if ([textView.text isEqualToString:@"请输入您的意见..."]) {
        textView.textColor = [UIColor lightGrayColor];
    }
    textView.backgroundColor = [UIColor whiteColor];
    textView.layer.borderWidth = 0.5;
    textView.layer.borderColor = GRAYCOLOR_MIDDLE.CGColor;
    textView.font = [UIFont systemFontOfSize:19.0];
    textView.layer.cornerRadius = 5;
    textView.clipsToBounds = YES;
    textView.returnKeyType = UIReturnKeyDone;
    textView.delegate = self;
    _textView = textView;
    [footView addSubview:_textView];
    // 保存,发送,回退
    CGFloat btn_W = (MainR.size.width-40)/3;
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    saveBtn.frame = CGRectMake(10, footView.frame.size.height-60, btn_W, 40);
    [saveBtn setTitle:@"保存意见" forState:UIControlStateNormal];
    saveBtn.backgroundColor = GRAYCOLOR;
    [saveBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    saveBtn.enabled = NO;
    [saveBtn addTarget:self action:@selector(saveAdvice:) forControlEvents:UIControlEventTouchUpInside];
    _saveBtn = saveBtn;
    [footView addSubview:saveBtn];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sendBtn.frame = CGRectMake(CGRectGetMaxX(saveBtn.frame)+10, saveBtn.frame.origin.y, btn_W, 40);
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    sendBtn.backgroundColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:239/255.0 alpha:1.0];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendAgree:) forControlEvents:UIControlEventTouchUpInside];
    _sendBtn = sendBtn;
    [footView addSubview:sendBtn];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backBtn.frame = CGRectMake(CGRectGetMaxX(sendBtn.frame)+10, saveBtn.frame.origin.y, btn_W, 40);
    backBtn.backgroundColor = [UIColor colorWithRed:34/255.0 green:152/255.0 blue:239/255.0 alpha:1.0];
    [backBtn setTitle:@"回退" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backFront:) forControlEvents:UIControlEventTouchUpInside];
    _backBtn = backBtn;
    [footView addSubview:backBtn];
    
    _footView = footView;
    // 公文和审批在办 (签字,发送,回退)
    if (!([_Id isEqualToString:@"YB"]||[_Id isEqualToString:@"xmcx"]||[_Id isEqualToString:@"gwcx"]))
    {
//        footView.hidden = YES;
        [self.view addSubview:footView];
    }
}

#pragma mark -- 保存意见
- (void)saveAdvice:(UIButton *)btn
{
    [self.view endEditing:YES];
    
    // 从本地读取本项目是否已经签字
    //BOOL haveSaveAdvice = [[defaults objectForKey:_model.ProjectId] boolValue];
    // 公文发文必须签意见,收文可签可不签意见
    if(([_textView.text isEqualToString:@"请输入您的意见..."]||[_textView.text isEqualToString:@""]))
    {
        [MBProgressHUD showError:@"意见不能为空!"];
    }
    else
    {
        //加载提示框
        [MBProgressHUD showMessage:@"保存中..." toView:self.view];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        
        NSString *url = [NSString stringWithFormat:@"%@%@",[Global Url],@"service/form/SaveOpinion.ashx"];
        NSDictionary *parameters = [NSDictionary new];
        
        NSString *table = @"";
        NSString *field = @"";
        NSString *oldvalue = @"";
        NSString *usertable = @"";
        NSString *userfield = @"";
        NSString *datetable = @"";
        NSString *datefield = @"";
     
        // 意见返回有数据->保存
        if (_adviceArray.count)
        {
            NSString *advice = @"";
            
            if ([_spOrgw isEqualToString:@"gw"])
            {
//                if (!dateFormattor)
//                {
//                    dateFormattor = [[NSDateFormatter alloc] init];
//                }
//                [dateFormattor setDateFormat:@"yyyy年MM月dd日"];
//                NSDate *date = [NSDate date];
//                NSString *nowDate = [dateFormattor stringFromDate:date];
//                advice = [NSString stringWithFormat:@"%@\n%@%@  %@",_textView.text,Space,[Global userName],nowDate];
                advice = _textView.text;
            }
            else
            {
                advice = _textView.text;
            }
            
            // 遍历字典的key
            for (NSString *key in [_adviceArray[0] keyEnumerator])
            {
                // NSLog(@"%@",key);
                if ([key isEqualToString:@"text"])
                {
                    table = [[_adviceArray[0] objectForKey:@"text"] objectForKey:@"table"];
                    field = [[_adviceArray[0] objectForKey:@"text"] objectForKey:@"field"];
                    oldvalue = [[_adviceArray[0] objectForKey:@"text"] objectForKey:@"oldvalue"];
                }
                else if ([key isEqualToString:@"user"])
                {
                    usertable = [[_adviceArray[0] objectForKey:@"user"] objectForKey:@"table"];
                    userfield = [[_adviceArray[0] objectForKey:@"user"] objectForKey:@"field"];
                }
                else if ([key isEqualToString:@"date"])
                {
                    datetable = [[_adviceArray[0] objectForKey:@"date"] objectForKey:@"table"];
                    datefield = [[_adviceArray[0] objectForKey:@"date"] objectForKey:@"field"];
                }
            }
            if (_model.ProjectId)
            {
                parameters = @{@"user":[Global userId],@"username":[Global userName],@"project":_model.ProjectId,@"value":advice,@"table":table,@"field":field,@"oldvalue":oldvalue,@"usertable":usertable,@"userfield":userfield,@"datetable":datetable,@"datefield":datefield,@"deviceNumber":[Global deviceUUID]};
            }
            else if (_model.Id)
            {
                parameters = @{@"user":[Global userId],@"username":[Global userName],@"project":_model.Id,@"value":advice,@"table":table,@"field":field,@"oldvalue":oldvalue,@"usertable":usertable,@"userfield":userfield,@"datetable":datetable,@"datefield":datefield,@"deviceNumber":[Global deviceUUID]};
            }
            
            NSMutableString *requestAddress = [NSMutableString stringWithString:[Global serverAddress]];
            [requestAddress appendString:@"?"];
            if (nil!=parameters) {
                for (NSString *key in parameters.keyEnumerator) {
                    NSString *val = [parameters objectForKey:key];
                    [requestAddress appendFormat:@"&%@=%@",key,val];
                }
            }
            
            NSLog(@"保存意见:%@",requestAddress);
            
            [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 [MBProgressHUD hideHUDForView:self.view animated:NO];
                 NSDictionary *JsonDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
                 
                 if ([[JsonDic objectForKey:@"result"] isEqual:@1])
                 {
                     [MBProgressHUD showSuccess:@"保存成功!"];
                     [self loadData];
                     
                 }
                 else
                 {
                     [MBProgressHUD showError:@"保存失败!"];
                 }
                 
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 [MBProgressHUD hideHUDForView:self.view animated:NO];
                 [MBProgressHUD showError:@"保存失败!"];
                 NSLog(@"%@",error);
             }];
        }
    }
}

#pragma mark -- 发送
-(void)sendAgree:(UIButton *)btn
{
    [self.view endEditing:YES];
    if ([_textView.text isEqualToString:@"请输入您的意见..."]) {
        _textView.text = @"";
    }
    if (_saveBtn.enabled == YES)
    {
        // 公文发文必须签意见,收文可签可不签意见
        // 判断本项目是否已经签字
        BOOL hasSign = [[[_adviceArray firstObject] objectForKey:@"hasSign"] boolValue];
        if(!hasSign && [_Id isEqualToString:@"gwfw"]&&([_textView.text isEqualToString:@"请输入您的意见..."]||[_textView.text isEqualToString:@""]))
        {
            [MBProgressHUD showError:@"意见不能为空!"];
        }
        else
        {
            if(!hasSign && ![_Id isEqualToString:@"gwsw"])
            {
                [MBProgressHUD showError:@"意见尚未保存!"];
            }
            else
            {
                SendViewController *sendVC = [[SendViewController alloc] init];
                sendVC.navigation = self.nav;
                //设置代理(SPDetailController)
                sendVC.delegate = self.sendDelegate;
                [sendVC projectInfoModel:_model];
                if ([_spOrgw isEqualToString:@"gw"])
                {
                    [sendVC sendType:2];
                    [sendVC projectType:@"2"];
                }
                else
                {
                    [sendVC sendType:0];
                    [sendVC projectType:@"1"];
                }
                [sendVC signXml:_textView.text];
                [self.nav pushViewController:sendVC animated:YES];
            }
        }
    }
    else
    {
        SendViewController *sendVC = [[SendViewController alloc] init];
        sendVC.navigation = self.nav;
        //设置代理(SPDetailController)
        sendVC.delegate = self.sendDelegate;
        [sendVC projectInfoModel:_model];
        if ([_spOrgw isEqualToString:@"gw"])
        {
            [sendVC sendType:2];
            [sendVC projectType:@"2"];
        }
        else
        {
            [sendVC sendType:0];
            [sendVC projectType:@"1"];
        }
        [sendVC signXml:_textView.text];
        [self.nav pushViewController:sendVC animated:YES];
    }
}

#pragma mark -- 回退事件
-(void)backFront:(UIButton *)btn
{
    [self.view endEditing:YES];
    if ([_textView.text isEqualToString:@"请输入您的意见..."]) {
        _textView.text = @"";
    }
    if (_saveBtn.enabled == YES)
    {
        // 公文发文必须签意见,收文可签可不签意见
        // 判断本项目是否已经签字
        BOOL hasSign = [[[_adviceArray firstObject] objectForKey:@"hasSign"] boolValue];
        
        if(!hasSign && [_Id isEqualToString:@"gwfw"]&&([_textView.text isEqualToString:@"请输入您的意见..."]||[_textView.text isEqualToString:@""]))
        {
            [MBProgressHUD showError:@"意见不能为空!"];
        }
        else
        {
            if(!hasSign && ![_Id isEqualToString:@"gwsw"])
            {
                [MBProgressHUD showError:@"意见尚未保存!"];
            }
            else
            {
                SendViewController *sendVC = [[SendViewController alloc] init];
                sendVC.navigation = self.nav;
                //设置代理(SPDetailController)
                sendVC.delegate = self.sendDelegate;
                [sendVC projectInfoModel:_model];
                if ([_spOrgw isEqualToString:@"gw"])
                {
                    [sendVC sendType:3];
                    [sendVC projectType:@"2"];
                }
                else
                {
                    [sendVC sendType:1];
                    [sendVC projectType:@"1"];
                }
                [sendVC signXml:_textView.text];
                [self.nav pushViewController:sendVC animated:YES];

            }
        }
    }
    else
    {
        SendViewController *sendVC = [[SendViewController alloc] init];
        sendVC.navigation = self.nav;
        //设置代理(SPDetailController)
        sendVC.delegate = self.sendDelegate;
        [sendVC projectInfoModel:_model];
        if ([_spOrgw isEqualToString:@"gw"])
        {
            [sendVC sendType:3];
            [sendVC projectType:@"2"];
        }
        else
        {
            [sendVC sendType:1];
            [sendVC projectType:@"1"];
        }
        [sendVC signXml:_textView.text];
        [self.nav pushViewController:sendVC animated:YES];
    }

}
#pragma -- tableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_spOrgw isEqualToString:@"gw"])
    {
        return 1;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        NSString *mark = [_markArray objectAtIndex:section];

        if ([mark isEqualToString:@"1"])
        {
            return [_baseInfoArray count];
        }
    }
    
    return 0;
 
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaseMessageCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0)
    {
        _baseInfoModel = _baseInfoArray[indexPath.row];
        cell.title.text = _baseInfoModel.text;
        cell.detailTitle.text = _baseInfoModel.value;
        
//        UIView *line =[[UIView alloc] initWithFrame:CGRectMake(15, cell.frame.size.height-1, MainR.size.width, 1)];
//        line.backgroundColor = GRAYCOLOR;
//        [cell.contentView addSubview:line];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([_spOrgw isEqualToString:@"gw"] )
    {
        if (section == 1)
        {
            return @"公文日志";
        }
        else
        {
            return [_formIdArray[section] objectForKey:@"Name"];
        }
        
    }
    
    return [_formIdArray[section] objectForKey:@"Name"];
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    return footView;
}

//头部视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] init];
    headView.tag = section;
    //headView.backgroundColor = GRAYCOLOR_LIGHT;
    headView.backgroundColor = [UIColor whiteColor];
    
    UIView *line_t =[[UIView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, 0.5)];
    line_t.backgroundColor = GRAYCOLOR_MIDDLE;
    [headView addSubview:line_t];
    
    UIView *line =[[UIView alloc] initWithFrame:CGRectMake(0, 44.5, MainR.size.width, 0.5)];
    line.backgroundColor = GRAYCOLOR_MIDDLE;
    [headView addSubview:line];
    
    UIView *backV = [[UIView alloc] init];
    backV.backgroundColor = [UIColor whiteColor];
    backV.frame = CGRectMake(0, 0, MainR.size.width, 45);
    //[headView addSubview:backV];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, MainR.size.width-60, 45)];
    lab.font = [UIFont boldSystemFontOfSize:16.0];
    lab.textColor = BLUECOLOR;
    [headView addSubview:lab];

    UIButton *groupBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    groupBtn.frame = CGRectMake(CGRectGetMaxX(backV.frame)-35, 30/2.0, 15, 15);
    groupBtn.enabled = NO;
    groupBtn.tag = section+1000;
    [headView addSubview:groupBtn];
    
    if ([_spOrgw isEqualToString:@"gw"] )
    {
        if (section == 1)
        {
            lab.text = @"公文日志";
            [groupBtn setImage:[UIImage imageNamed:@"zhankai"] forState:UIControlStateNormal];
        }
        else
        {
            lab.text = [NSString stringWithFormat:@"%@",[_formIdArray[section] objectForKey:@"Name"]];
            [groupBtn setImage:[UIImage imageNamed:_groupImgArray[section]] forState:UIControlStateNormal];
        }
    }
    else
    {
        lab.text = [NSString stringWithFormat:@"%@",[_formIdArray[section] objectForKey:@"Name"]];
        [groupBtn setImage:[UIImage imageNamed:_groupImgArray[section]] forState:UIControlStateNormal];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openOrCloseHeader:)];
    [headView addGestureRecognizer:tap];
    return headView;
}

//打开关闭分组
-(void)openOrCloseHeader:(UITapGestureRecognizer *)tap
{
    UIView *tapView = tap.view;
    
    //UIButton *btn = (UIButton *)[tapView viewWithTag:tapView.tag+1000];
    //NSLog(@"tag: %ld, %@",(long)btn.tag,btn);
    
    //项目日志
    if (tapView.tag == 1) {
        
        PLogViewController *pLog =[[PLogViewController alloc]  init];
       
        [pLog setModel:self.model];
        [self.nav pushViewController:pLog animated:YES];
       
    }else{
        NSString *mark = _markArray[tapView.tag];
        
        if ([mark isEqualToString:@"0"]) {
            [_markArray replaceObjectAtIndex:tapView.tag withObject:@"1"];
            [UIView animateWithDuration:0.5 animations:^{
                //            [btn setImage:[UIImage imageNamed:@"zhankai"] forState:UIControlStateNormal];
                [_groupImgArray replaceObjectAtIndex:tapView.tag withObject:@"xiangshang"];
            }];
        }
        else
        {
            [_markArray replaceObjectAtIndex:tapView.tag withObject:@"0"];
            [UIView animateWithDuration:0.5 animations:^{
                //[btn setImage:[UIImage imageNamed:@"zhankai"] forState:UIControlStateNormal];
                [_groupImgArray replaceObjectAtIndex:tapView.tag withObject:@"zhankai"];
            }];
        }
    }
    
    [_baseTableView reloadData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _baseInfoModel = _baseInfoArray[indexPath.row];
    CGFloat cellHeight = [self GetCellHeightWithContent:[_baseInfoModel value]];
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


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}

#pragma mark - UITextView Delegate Methods
//点击键盘右下角的键收起键盘
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if (_textView.text.length == 0) {
            _textView.textColor =[UIColor lightGrayColor];
            _textView.text = @"请输入您的意见...";
        }
        else
        {
            _textView.textColor = [UIColor blackColor];
            _tempAdviceS = _textView.text;
            
        }
        [textView resignFirstResponder];
        
        //        _bgScrollView.contentOffset = CGPointMake(0, 300);
        //        if (MainR.size.height ==480) {
        //            self.bgScrollView.contentOffset = CGPointMake(0, 380);
        //        }
        //        if (MainR.size.width>414) {
        //            self.bgScrollView.contentOffset = CGPointMake(0, 80);
        //
        //        }
        
        
        //return NO;
    }
    return YES;
}

// 键盘升起/隐藏
-(void)keyboardWillShow:(NSNotification *)noti
{
    // 获取键盘弹出的动画时间
    CGFloat durtion = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGSize keyboardSize = [noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].size ;
//    CGFloat keyboard_h = keyboardSize.height;
    NSLog(@"1=====%@",noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"]);
    if (MainR.size.height<=1024) {
        
        [UIView animateWithDuration:durtion animations:^{
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
            CGRect footerFrame = _footView.frame;
            
            footerFrame.origin.y = SCREEN_HEIGHT==480? SCREEN_HEIGHT-_footView.frame.size.height-keyboardSize.height-64+45:SCREEN_HEIGHT-_footView.frame.size.height-keyboardSize.height-64-50;
            
            _footView.frame = footerFrame;
        }];
    }
}
-(void)keyboardWillHide:(NSNotification *)noti
{
    [self createNotification];
    // 获取键盘弹出的动画时间
    CGFloat durtion = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGSize keyboardSize = [noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].size ;
    CGFloat keyboard_h = keyboardSize.height;
    NSLog(@"2=====%f",keyboard_h);
    [UIView animateWithDuration:durtion animations:^{
        
        CGRect foorterFrame = _footView.frame;
        foorterFrame.origin.y = MainR.size.height-220-64-50;
        _footView.frame = foorterFrame;
        
    }];
}

//开始编辑意见框,键盘遮挡问题
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    if ([textView.text isEqualToString:@"请输入您的意见..."])
    {
        _textView.text = @"";
    }
    
    if (_tempAdviceS.length !=0)
    {
        // _adviseTF.text = _tempAdviceS;
    }
    else
    {
        //  _adviseTF.text= @"";
    }
     textView.textColor =[UIColor blackColor];
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
   
    [_textView resignFirstResponder];
    [PopSignUtil closePop];
}


-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (_saveBtn.enabled == NO)
    {
        return YES;
    }
    return YES;
}

#pragma SendViewDelegate 代理方法
-(void)sendViewDidSendCompleted{
    
    [self.nav popToViewController:self animated:YES];
    //    [self.nav popViewControllerAnimated:YES];
    //    [self.nav popViewControllerAnimated:YES];
    //       [self.nav popToViewController:[self.nav.viewControllers objectAtIndex:1] animated:YES];
}


-(NSString *)generateSignXml{
    
    if (nil == _signInfo) {
        return nil;
    }
    NSDate* now = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy年MM月dd日";
    NSString *dateString = [df stringFromDate:now];
    NSString *tableName = [[_signInfo objectForKey:@"text"] objectForKey:@"table"];
    NSString *textField = [[_signInfo objectForKey:@"text"] objectForKey:@"field"];
    //NSString *userField = [[_signInfo objectForKey:@"user"] objectForKey:@"field"];
    //NSString *dateField = [[_signInfo objectForKey:@"date"] objectForKey:@"field"];
    //NSString *xml = [NSString stringWithFormat:@"<root><%@><%@><![CDATA[%@]]></%@><%@><![CDATA[%@]]></%@><%@><![CDATA[%@]]></%@></%@></root>",tableName,textField,_signText.text,textField,userField,[Global userName],userField,dateField,dateString,dateField,tableName];
    NSString *textOldValue = [[_signInfo objectForKey:@"text"] objectForKey:@"oldvalue"];
    
    
    NSString *flag=@"";
    if ([textOldValue length]>0) {
        flag=@"\r";
    }
    
    NSString *textData=[NSString stringWithFormat:@"%@%@  %@ \r                      %@ %@",textOldValue,flag,self.textView.text,[Global userName],dateString];
    
    NSString *xml = [NSString stringWithFormat:@"<root><%@><%@><![CDATA[%@]]></%@></%@></root>",tableName,textField,textData,textField,tableName];
    NSLog(@"%@",xml);
    return xml;
}


-(void)loadSignInfo{
    //    if (self.readonly) {
    //        [DejalBezelActivityView removeViewAnimated:YES];
    //        [self updateControls];
    //        self.scrollConstraints.constant = 0;
    //    }else{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *parameters = @{@"wfWorkItemId":self.model.wfWorkItemId,@"type":@"smartplan",@"action":@"signinfo",@"project":self.model.ProjectId};
    
    NSLog(@"%@?wfWorkItemId=%@&type=smartplan&action=signinfo&project=%@",[Global serverAddress],self.model.wfWorkItemId,self.model.ProjectId);
    [manager POST:[Global serverAddress] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rs = (NSDictionary *)responseObject;
        if ([[rs objectForKey:@"success"] isEqualToString:@"true"]) {
            _signInfo = [[rs objectForKey:@"result"] objectAtIndex:0];
        }
        //            [self updateControls];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //            [self updateControls];
    }];
    //    }
}

- (void)keyboardWillChange:(NSNotification  *)note
{
    // 获取键盘弹出的动画时间
//    CGFloat durtion = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
//    
//    // 获取键盘的frame
//    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    
//    if (frame.origin.y == MainR.size.height) { // 没有弹出键盘
//        [UIView animateWithDuration:durtion animations:^{
//            
//            self.bgScrollView.transform =  CGAffineTransformIdentity;
//            self.view.transform =  CGAffineTransformIdentity;
//            
//        }];
//    }else{ // 弹出键盘
//        // 工具条往上移动258
//        [UIView animateWithDuration:durtion animations:^{
//            
//            if (MainR.size.width>414) {
//                self.view.transform = CGAffineTransformMakeTranslation(0,-(frame.size.height));
//                //                self.bgScrollView.contentOffset = CGPointMake(0, frame.size.height-400);
//                
//            }
//            
//            else
//            {
//                self.view.transform = CGAffineTransformMakeTranslation(0,-frame.size.height);
//                self.bgScrollView.contentOffset = CGPointMake(0, frame.size.height);
//                
//                
//            }
//        }];
//        
//    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
