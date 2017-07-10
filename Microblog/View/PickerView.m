//
//  PickerView.m
//  WZYD
//
//  Created by 吴定如 on 16/11/10.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "PickerView.h"

@interface PickerView ()<UITextViewDelegate>

@property(nonatomic,strong) UIView *dateBackView;
@property(nonatomic,strong) UIButton *sureBtn;
@property(nonatomic,strong) UIButton *cancelBtn;
@property(nonatomic,strong) UIView *viewH;
@property(nonatomic,strong) UIView *viewV;
@property(nonatomic,strong) UITextView *textView;

@end

@implementation PickerView

- (instancetype)initWithFrame:(CGRect)frame pickerType:(NSString *)pickerType
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //监听屏幕旋转的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotation) name:UIDeviceOrientationDidChangeNotification object:nil];
        _pickerType = pickerType;
        //蒙版(自己)
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [self createPikerView];
        
    }
    return self;
}

-(void)screenRotation
{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _dateBackView.center = CGPointMake(MainR.size.width/2, MainR.size.height/2);
}

-(void)createPikerView
{
    //大的背景view
    UIView *dateBackView = [[UIView alloc] init];
    if (MainR.size.width < 768)
    {
        dateBackView.frame = CGRectMake(0, 0, MainR.size.width-20, 306);
    }else
    {
        dateBackView.frame = CGRectMake(0, 0, 400, 306);
    }
    dateBackView.layer.cornerRadius = 10;
    dateBackView.clipsToBounds = YES;
    dateBackView.backgroundColor = [UIColor whiteColor];
    dateBackView.center = CGPointMake(MainR.size.width/2, MainR.size.height/2);
    _dateBackView = dateBackView;
    [self addSubview:dateBackView];
    
    
    //
    UITextView *textView = [[UITextView alloc] init];
    textView.frame = CGRectMake(20, 20, dateBackView.frame.size.width-40, 215);
    if ([_pickerType isEqualToString:@"microblog"]) {
        textView.text = @"请输入微博内容";
    }else if ([_pickerType isEqualToString:@"question"])
    {
        textView.text = @"请输入反馈内容";
    }
    textView.font = [UIFont systemFontOfSize:17.0];
    
    if ([textView.text isEqualToString:@"请输入微博内容"] || [textView.text isEqualToString:@"请输入反馈内容"])
    {
        textView.textColor = [UIColor lightGrayColor];
    }
    textView.layer.borderWidth = 1.0;
    textView.layer.borderColor = GRAYCOLOR_MIDDLE.CGColor;
    textView.layer.cornerRadius = 5;
    textView.clipsToBounds = YES;
    textView.returnKeyType = UIReturnKeyDone;
    textView.delegate = self;
    _textView = textView;
    [dateBackView addSubview:textView];
    
    // 分割线
    UIView *viewH = [[UIView alloc] initWithFrame:CGRectMake(0, dateBackView.frame.size.height- 51, dateBackView.frame.size.width, 1)];
    viewH.backgroundColor = GRAYCOLOR_MIDDLE;
    _viewH = viewH;
    [dateBackView addSubview:viewH];
    
    UIView *viewV = [[UIView alloc] initWithFrame:CGRectMake(dateBackView.frame.size.width/2, dateBackView.frame.size.height- 51, 1, 51)];
    viewV.backgroundColor = GRAYCOLOR_MIDDLE;
    _viewV = viewV;
    [dateBackView addSubview:viewV];
    
    CGFloat btn_w = dateBackView.frame.size.width/2;
    // 取消
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0,dateBackView.frame.size.height-50,btn_w,50);
    [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelSelect) forControlEvents:UIControlEventTouchUpInside];
    _cancelBtn = cancelBtn;
    [dateBackView addSubview:cancelBtn];
    // 确定
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(btn_w,dateBackView.frame.size.height-50,btn_w,50);;
    [sureBtn setTitleColor:[UIColor colorWithRed:0.020 green:0.591 blue:0.110 alpha:1.000] forState:UIControlStateNormal];
    if ([_pickerType isEqualToString:@"microblog"]) {
        [sureBtn setTitle:@"立即发布" forState:UIControlStateNormal];
    }else if ([_pickerType isEqualToString:@"question"])
    {
        [sureBtn setTitle:@"立即反馈" forState:UIControlStateNormal];
    }
    [sureBtn addTarget:self action:@selector(sendMicroblog) forControlEvents:UIControlEventTouchUpInside];
    _sureBtn = sureBtn;
    [dateBackView addSubview:sureBtn];
}

#pragma mark -- 确定选择事件

-(void)sendMicroblog
{
    if ([_textView.text isEqualToString:@""]||[_textView.text isEqualToString:@"请输入微博内容"] || [_textView.text isEqualToString:@"请输入反馈内容"])
    {
        [MBProgressHUD showError:@"请输入内容!"];
    }
    else if (_sendMicroblogBlock)
    {
        _sendMicroblogBlock(_textView.text);
        [self fadeOut];
    }
    
}
 #pragma mark -- 取消选择事件
-(void)cancelSelect
{
    [self fadeOut];
}

-(void)showInView:(UIView *)superView animated:(BOOL)animated
{
    [superView addSubview:self];
    if (animated)
    {
        [self fadeIn];
    }
}

-(void)fadeIn
{
    /**
     *  弹出动画
     */
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}
-(void)fadeOut
{
    /**
     *  消失动画
     */
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished)
        {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark -- touch

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
    [self fadeOut];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入微博内容"] || [textView.text isEqualToString:@"请输入反馈内容"])
    {
        textView.text = @"";
    }
    textView.textColor =[UIColor blackColor];
}
//点击键盘右下角的键收起键盘
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        if (textView.text.length == 0)
        {
            textView.textColor =[UIColor lightGrayColor];
            if ([_pickerType isEqualToString:@"microblog"]) {
                textView.text = @"请输入微博内容";
            }else if ([_pickerType isEqualToString:@"question"])
            {
                textView.text = @"请输入反馈内容";
            }
        }
        else
        {
            textView.textColor =[UIColor blackColor];
        }
        [textView resignFirstResponder];
    }
    return YES;
}


@end