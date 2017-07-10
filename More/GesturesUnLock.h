//
//  GesturesUnLock.h
//  iPortal
//
//  Created by xiao on 14-11-24.
//  Copyright (c) 2014年 sh. All rights reserved.
//
#import "PersenalViewController.h"
#import "ZQButton.h"
#import <UIKit/UIKit.h>

@interface GesturesUnLock : UIViewController<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UILabel *lblHint;

@property (strong, nonatomic) UIImageView *lockView;

@property (nonatomic, strong) NSMutableArray *rightPassword;
@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic, strong) NSMutableArray *waitSure;

@property (nonatomic, strong) NSMutableArray *btnArray;

@property (nonatomic) BOOL reSet;
@property (weak, nonatomic) IBOutlet UIButton *forgetPassWord;
@property (nonatomic) BOOL Flag;
@property (nonatomic) BOOL sureFlag;
@property (nonatomic) BOOL isHomePage;
@property (weak, nonatomic) IBOutlet UIButton *otherStyle;
- (IBAction)otherPatternClick:(id)sender;
- (IBAction)forgetPassWordClick:(id)sender;


@end
