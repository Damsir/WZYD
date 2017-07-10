//
//  GWViewController.h
//  XAYD
//
//  Created by dist on 15/8/3.
//  Copyright (c) 2015年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "GWListViewController.h"
#import "baseViewController.h"

@interface SPViewController : baseViewController<UITableViewDataSource,UITableViewDelegate>
- (void)viewDidLoad;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

//存放分类对应个数的字典
@property (strong, nonatomic) NSDictionary *dic;
//图片数组
@property (strong,nonatomic) NSArray *imgArr;
//存放分类数组
@property (strong, nonatomic) NSArray *keys;

@end
