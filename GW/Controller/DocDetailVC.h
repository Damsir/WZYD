//
//  DocDetailVC.h
//  XAYD
//
//  Created by songdan Ye on 16/4/5.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendViewController.h"
@class SPDetailModel;
@class CYQYModel;
@interface DocDetailVC : UIViewController<SendViewDelegate>

@property (nonatomic,weak)IBOutlet UITableView *topInformationT;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmBtnleftC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmBtnRightC;

//
////查看公文正文按钮
//@property (weak, nonatomic) IBOutlet UIButton *btn;



@property (nonatomic,strong)SPDetailModel *spModel;
@property (nonatomic,strong)CYQYModel *cqModel;
//传阅/签阅按钮
@property (weak, nonatomic) IBOutlet UIButton *comfirmBtn;
//意见框
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adLeftMarginC;
@property (weak, nonatomic) IBOutlet UITextView *adviseTextv;
//意见框离上边的约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adviseTFHeightC;
//当前状态(传阅/签阅)
@property (nonatomic,strong) NSString *currentState;

@property (strong,nonatomic) id<SendViewDelegate> sendDelegate;

@property (nonatomic,strong)UINavigationController *nav;

@property (nonatomic,strong)NSString *dataType;
//区分传阅签阅
@property (nonatomic,strong)NSString *forwordType;


//区分收文,发文,发给我的和我发送的
@property(nonatomic,strong) NSString *selectedIndex;


@end
