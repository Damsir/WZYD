//
//  FormViewController.h
//  iBusiness
//
//  Created by zhangliang on 15/5/4.
//  Copyright (c) 2015年 sh. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface FormViewController : UIViewController<UIWebViewDelegate,UIAlertViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIWebView *formView;
@property (weak, nonatomic) IBOutlet UIPickerView *formPicker;
@property (weak, nonatomic) IBOutlet UIView *formPickView;
@property(nonatomic,assign) NSInteger meetingForm;//记录是否为会议


@property (nonatomic,strong)UITabBarController *tab;



- (IBAction)onFormPickCancel:(id)sender;
- (IBAction)onFormPickOk:(id)sender;
-(void)projectInfo:(NSDictionary *)data;
@end
