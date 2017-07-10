//
//  SearchMore.m
//  XAYD
//
//  Created by songdan Ye on 16/2/18.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "SearchMore.h"
#import "MBProgressHUD+MJ.h"
#import "SHSiteList.h"
#import "SHSiteModel.h"
#import "SearchResultVC.h"
#import "DatePickerView.h"

@interface SearchMore ()<UITextFieldDelegate,SiteListDelegate>

@property(nonatomic,strong) DatePickerView *datePicker;
@end

@implementation SearchMore
//结果数组
- (NSMutableArray *)resultArray
{
    if (_resultArray==nil) {
        _resultArray =[NSMutableArray array];
        
    }
    return _resultArray;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title= @"高级查询";
   
    _PSarray = @[@{@"id":@"0",@"name":@"接件"},@{@"id":@"0",@"name":@"分件"},@{@"id":@"0",@"name":@"初审"},@{@"id":@"0",@"name":@"审查"},@{@"id":@"0",@"name":@"审核"},@{@"id":@"0",@"name":@"业务例会"},@{@"id":@"0",@"name":@"审批"}];
    NSMutableArray *mArr=[NSMutableArray array];
    for (NSDictionary *dic in _PSarray) {
        SHSiteModel *model =[SHSiteModel siteModelWithDict:dic];
        [mArr addObject:model];
        
    }
    
    _PN.tag = 100;
    _PN.delegate= self;
    _contact.delegate =self;
    _adress.delegate= self;
    _num.delegate=self;
    _pState.delegate =self;
    _type.delegate= self;
    _pName.delegate =self;
    _slDate.delegate = self;
    _fzDate.delegate = self;;
    
    _PSarray1 = [mArr copy];
    
    self.baScrollView.contentSize = CGSizeMake(MainR.size.width, 664);
    if (MainR.size.width==320)
    {
        self.resetWidthC.constant =self.searchBWidthC.constant = 140;
    }
    if (MainR.size.width>414)
    {
        self.resetWidthC.constant =self.searchBWidthC.constant = (MainR.size.width-100)*0.5;
        self.chaxunRC.constant =self.chongzhiLC.constant = 20;
        self.nameHeigtht.constant = self.numberHeight.constant =self.sponsorHeight.constant=self.contactHeight.constant=self.adressHeight.constant=self.numHeight.constant=self.pstateHeight.constant =self.typeHeight.constant = 40;
    }
    //键盘唤起和隐藏的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeComS) name:UIDeviceOrientationDidChangeNotification object:nil];
}
//屏幕旋转结束执行的方法
- (void)changeComS
{
    [_datePicker screenRotation];

}
#pragma UITextField代理方法

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    NSLog(@"y=%f,%f",CGRectGetMinY(textField.frame),MainR.size.height-240-64);
//    
    if (CGRectGetMaxY(textField.frame)>=240+64) {
        self.baScrollView.contentOffset = CGPointMake(0, 240);
        NSLog(@"%f",CGRectGetMaxY(textField.frame)-(MainR.size.height-280-64));
    }
    else
    {
        self.baScrollView.contentOffset =CGPointMake(0, 0);
    
    }
    
    if (textField == _pState) {
        [_PN resignFirstResponder];
        [_contact resignFirstResponder];
        [_adress resignFirstResponder];
        [_num resignFirstResponder];
        [_pState resignFirstResponder];
        [_type resignFirstResponder];
        [_pName resignFirstResponder];
        [_slDate resignFirstResponder];
        [_fzDate resignFirstResponder];
        
        
        SHSiteList *site =[[SHSiteList alloc] initWithTitle:@"项目状态" options:_PSarray1];
        site.delegate =self;
        [site showInView:self.view animated:YES];
        [textField resignFirstResponder];
    }
    else if (textField == _slDate||textField == _fzDate )
    {
        [_PN resignFirstResponder];
        [_contact resignFirstResponder];
        [_adress resignFirstResponder];
        [_num resignFirstResponder];
        [_pState resignFirstResponder];
        [_type resignFirstResponder];
        [_pName resignFirstResponder];
        [_slDate resignFirstResponder];
        [_fzDate resignFirstResponder];
    
        DatePickerView *datePicker  = [[DatePickerView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, MainR.size.height) AndDatePickerMode:UIDatePickerModeDate];
        _datePicker = datePicker;
        [_datePicker showInView:self.view.window.rootViewController.view animated:YES];
        
        DefineWeakSelf(weakSelf);
        //选择回调
        _datePicker.dateSelectBlock = ^(NSDate *selectDate){
            
            //定义日期显示的格式
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString *selectDateStr = [dateFormatter stringFromDate:selectDate];
            if (textField == _slDate)
            {
                
                weakSelf.slDate.text = selectDateStr;
                if (MainR.size.height==480) {
                    weakSelf.baScrollView.contentOffset = CGPointMake(0, 250);
                }else if (MainR.size.height == 568)
                {
                     weakSelf.baScrollView.contentOffset =CGPointMake(0, 200);
                }
                 weakSelf.baScrollView.contentOffset = CGPointMake(0, 0);

                
            }else
            {
                weakSelf.fzDate.text = selectDateStr;
                if (MainR.size.height==480) {
                     weakSelf.baScrollView.contentOffset = CGPointMake(0, 250);
                }else if (MainR.size.height == 568)
                {
                    weakSelf.baScrollView.contentOffset =CGPointMake(0, 200);
                }
            }
             weakSelf.baScrollView.contentOffset = CGPointMake(0, 0);

        };
        //取消回调
        _datePicker.cancelSelectBlock = ^(NSDate *selectDate)
        {
            if (textField == _slDate)
            {
                
                if (MainR.size.height==480) {
                    weakSelf.baScrollView.contentOffset = CGPointMake(0, 250);
                }else if (MainR.size.height == 568)
                {
                    weakSelf.baScrollView.contentOffset =CGPointMake(0, 200);
                }
                weakSelf.baScrollView.contentOffset = CGPointMake(0, 0);
                
                
            }else
            {
                if (MainR.size.height==480) {
                    weakSelf.baScrollView.contentOffset = CGPointMake(0, 250);
                }else if (MainR.size.height == 568)
                {
                    weakSelf.baScrollView.contentOffset =CGPointMake(0, 200);
                }
            }
            weakSelf.baScrollView.contentOffset = CGPointMake(0, 0);
  
        };

        return NO;
    }
    
    return  YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (textField == _pState) {
        [textField resignFirstResponder];
        
    }
    else if (textField == _slDate||textField == _fzDate )
    {
        [textField resignFirstResponder];

    }
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{

    if (textField == _type) {
        if (MainR.size.height==480) {
            _baScrollView.contentOffset = CGPointMake(0, 250);
        }else if (MainR.size.height == 568)
        {
        _baScrollView.contentOffset =CGPointMake(0, 200);
        }
    }

}

#pragma mark - SHSiteList delegates

- (void)siteList:(SHSiteList *)SHSiteListView didSelectedIndex:(NSInteger)Index
{
    SHSiteModel *model = [_PSarray1 objectAtIndex:Index];
    
    _pState.text = model.name;
    
}

- (void)siteListViewDidCancel
{
    
    
}

- (IBAction)searchBtnClick:(id)sender {
    
    if (_PN.text.length!=0||_pName.text.length!=0||_contact.text.length!=0||_adress.text.length!=0||_num.text.length!=0||_pState.text.length!=0||_type.text.length!=0||_slDate.text!=0||_fzDate.text!=0)
    {
   
        //添加 字典，将label的值通过key值设置传递
        NSDictionary *dict =[NSDictionary dictionary];
       //项目名称－ProjectName，项目编号－项目总流水号，主办人－无，联系人－联系人，建设地址－BuildAdress，受理编号－ProjectNo ，项目状态－办理状态，业务类型－BusinessName

        NSString *pMStr =[NSString string];
        NSString *str = [NSMutableString string];

        if (![self.pName.text isEqualToString:@""]) {
           str=[NSString stringWithFormat:@"{\"Name\":\"ProjectName\",\"DefualtValue\":\"%@\",\"MaxValue\":null,\"MinValue\":null,\"QueryType\":1,\"ValueType\":0},",_pName.text];
          pMStr=[pMStr stringByAppendingString:str];
        }
        if (![self.PN.text isEqualToString:@""])
        {
        
          str=[NSString stringWithFormat:@"{\"Name\":\"项目总流水号\",\"DefualtValue\":\"%@\",\"MaxValue\":null,\"MinValue\":null,\"QueryType\":1,\"ValueType\":0},",_PN.text];
          pMStr=  [pMStr stringByAppendingString:str];
        }
       
//        if (![self.Sponsor.text isEqualToString:@""])
//        {
//            
//            str=[NSString stringWithFormat:@"{\"Name\":\"zbrName\",\"DefaultValue\":\"%@\",\"MaxValue\":null,\"MinValue\":null,\"QueryType\":0,\"ValueType\":0},",_Sponsor.text];
//           pMStr= [pMStr stringByAppendingString:str];
//        }
        if (![self.contact.text isEqualToString:@""])
        {
            
            str=[NSString stringWithFormat:@"{\"Name\":\"联系人\",\"DefualtValue\":\"%@\",\"MaxValue\":null,\"MinValue\":null,\"QueryType\":1,\"ValueType\":0},",_contact.text];
          pMStr=  [pMStr stringByAppendingString:str];
        }
        if (![self.adress.text isEqualToString:@""])
        {
            
            str=[NSString stringWithFormat:@"{\"Name\":\"BuildAdress\",\"DefualtValue\":\"%@\",\"MaxValue\":null,\"MinValue\":null,\"QueryType\":1,\"ValueType\":0},",_adress.text];
           pMStr= [pMStr stringByAppendingString:str];
        }
        if (![self.num.text isEqualToString:@""])
        {
            
            str=[NSString stringWithFormat:@"{\"Name\":\"ProjectNo\",\"DefualtValue\":\"%@\",\"MaxValue\":null,\"MinValue\":null,\"QueryType\":1,\"ValueType\":0},",_num.text];
          pMStr=  [pMStr stringByAppendingString:str];
        }
        if (![self.pState.text isEqualToString:@""])
        {
            
            str=[NSString stringWithFormat:@"{\"Name\":\"办理状态\",\"DefualtValue\":\"%@\",\"MaxValue\":null,\"MinValue\":null,\"QueryType\":1,\"ValueType\":0},",_pState.text];
           pMStr= [pMStr stringByAppendingString:str];
        }
        
        if (![self.type.text isEqualToString:@""])
        {
            
            str=[NSString stringWithFormat:@"{\"Name\":\"BusinessName\",\"DefualtValue\":\"%@\",\"MaxValue\":null,\"MinValue\":null,\"QueryType\":1,\"ValueType\":0},",_type.text];
         pMStr=   [pMStr stringByAppendingString:str];
        }
        if(![self.slDate.text isEqualToString:@""])
        {
            NSArray *arr=[self.slDate.text componentsSeparatedByString:@"-"];
            NSString *next = [NSString stringWithFormat:@"%@-%@-%d",arr[0],arr[1],[arr[2] intValue]+1];
            str=[NSString stringWithFormat:@"{\"Name\":\"RegisterTime\",\"DefualtValue\":\"\",\"MaxValue\":\"%@\",\"MinValue\":\"%@\",\"QueryType\":2,\"ValueType\":2},",next,_slDate.text];
//            str=@"{\"Name\":\"RegisterTime\",\"DefualtValue\":\"\",\"MaxValue\":\"2016-10-14\",\"MinValue\":\"2016-09-28\",\"QueryType\":2,\"ValueType\":2},";

            pMStr= [pMStr stringByAppendingString:str];
        }
        
        if(![self.fzDate.text isEqualToString:@""])
        {
           
            NSArray *arr=[self.fzDate.text componentsSeparatedByString:@"-"];
           NSString *next = [NSString stringWithFormat:@"%@-%@-%d",arr[0],arr[1],[arr[2] intValue]+1];
            str=[NSString stringWithFormat:@"{\"Name\":\"实际办结日期\",\"DefualtValue\":\"\",\"MaxValue\":\"%@\",\"MinValue\":\"%@\",\"QueryType\":2,\"ValueType\":2},",next,_fzDate.text];
            
            pMStr= [pMStr stringByAppendingString:str];
        }
//        if(![self.fzDate.text isEqualToString:@""])
//        {
//            str=[NSString stringWithFormat:@"{\"Name\":\"BuildDate\",\"DefualtValue\":\"\",\"MaxValue\":\"%@\",\"MinValue\":\"%@\",\"QueryType\":1,\"ValueType\":0},",_fzDate.text,_fzDate.text];
//            pMStr= [pMStr stringByAppendingString:str];
//        }
        NSString *ms =[pMStr substringToIndex:pMStr.length-1];
        NSString *params =[NSString stringWithFormat:@"[%@]",ms];
//        NSLog(@"lllllll%@",params);
        
        SearchResultVC *searchResult =[[SearchResultVC alloc] init];
        searchResult.quryStr = params;
        [self.navigationController pushViewController:searchResult animated:YES];
    }
    else
    {
     UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入内容再搜索" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alertV show];
    
    }
    
}


- (IBAction)resetBtnClick:(id)sender
{
    _PN.text=_pName.text=_contact.text=_adress.text=_num.text=_pState.text=_type.text=_slDate.text = _fzDate.text=nil;
    
    
}

#pragma mark-textField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
//    if (textField == _pName) {
//        [_PN becomeFirstResponder];
//    }
//    else if (textField == _PN)
//    {
//        [_contact becomeFirstResponder];
//    }
//    else if (textField == _contact)
//    {
//        [_adress becomeFirstResponder];
//    }
//    else if (textField == _adress)
//    {
//        [_num becomeFirstResponder];
//    }
//    else if (textField == _num)
//    {
//        [_pState becomeFirstResponder];
//    }
//    else if (textField == _pState)
//    {
//        [_pState resignFirstResponder];
//    }
//    else if (textField == _type)
//    {
//        [_type resignFirstResponder];
//    }
//    else if (textField == _slDate)
//    {
//        [_slDate resignFirstResponder];
//    }
//    else if (textField == _fzDate)
//    {
//        [_fzDate resignFirstResponder];
//    }
    [textField resignFirstResponder];
    return YES;
}
- (void)searMutilSection
{
    
    
    
}


//触摸空白处
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_PN resignFirstResponder];
    [_contact resignFirstResponder];
    [_adress resignFirstResponder];
    [_num resignFirstResponder];
    [_pState resignFirstResponder];
    [_type resignFirstResponder];
    [_pName resignFirstResponder];
    [_slDate resignFirstResponder];
    [_fzDate resignFirstResponder];
}

#pragma mark -- 键盘升起/隐藏
-(void)keyboardWillShow:(NSNotification *)noti
{
    //获取键盘弹出的动画时间
    CGFloat durtion = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGSize keyboardSize = [noti.userInfo[@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue].size ;
    CGFloat keyboard_h = keyboardSize.height;
    NSLog(@"1=====%f",keyboard_h);
    if (MainR.size.height<1024) {
        [UIView animateWithDuration:durtion animations:^{
            //判断当前编辑的对象
            if (_type.isFirstResponder == YES ) {
               
                self.baScrollView.contentOffset = CGPointMake(0, keyboard_h*3/5);
                
                
//                CGRect scrollViewFrame = _baScrollView.frame;
//                if (MainR.size.width == 1024 || MainR.size.height == 480)
//                {
//                    scrollViewFrame.origin.y = -keyboard_h*3/4;
//                }else
//                {
//                    scrollViewFrame.origin.y = -keyboard_h;
//                }
//                _baScrollView.frame = scrollViewFrame;
//                 NSLog(@"scroll=====%@",_baScrollView);
            }
            if ( MainR.size.height == 480 && _num.isFirstResponder)
            {
                self.baScrollView.contentOffset = CGPointMake(0, keyboard_h*3/5);
            }
            
        }];
        
    }
    
}
-(void)keyboardWillHide:(NSNotification *)noti
{
    //获取键盘弹出的动画时间
    CGFloat durtion = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGSize keyboardSize = [noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].size ;
    CGFloat keyboard_h = keyboardSize.height;
    NSLog(@"2=====%f",keyboard_h);
    [UIView animateWithDuration:durtion animations:^{
        
        self.baScrollView.contentOffset = CGPointMake(0, 0);
//        CGRect scrollViewFrame = _baScrollView.frame;
//        scrollViewFrame.origin.y = 0;
//        _baScrollView.frame = scrollViewFrame;
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
