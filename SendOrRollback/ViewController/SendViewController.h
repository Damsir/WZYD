//
//  SendViewController.h
//  iBusiness
//
//  Created by zhangliang on 15/5/5.
//  Copyright (c) 2015年 sh. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "TouchTableView.h"
#import "SPDetailModel.h"

@protocol SendViewDelegate <NSObject>

-(void)sendViewDidSendCompleted;

@end

@interface SendViewController : UIViewController

//@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
//@property (weak, nonatomic) IBOutlet TouchTableView *activityTable;
@property (weak, nonatomic) IBOutlet UIButton *btnComplete;
@property (weak, nonatomic) IBOutlet UIView *sendView;
//@property (strong, nonatomic) UIImage *signImage;
@property (nonatomic,strong) NSString *fildName;
@property (nonatomic,strong) CAShapeLayer *clickCicrleLayer;

@property (strong,nonatomic) id<SendViewDelegate> delegate;

-(IBAction)onBtnCompleteTap:(id)sender;
-(void)projectInfo:(NSDictionary *)data;
-(void)projectInfoModel:(SPDetailModel *)model;
-(void)sendType:(int)type;
-(void)sendStutas:(int)status;
-(void)signXml:(NSString *)xml;
-(void)projectType:(NSString *)projectType;

- (void)fildName:(NSString *)fildName;
//-(void)setSignImage:(UIImage *)signImage;

@property(nonatomic,strong) UINavigationController *navigation;

@end


