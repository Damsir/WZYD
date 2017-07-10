//
//  SendOffDocDetailVC.h
//  XAYD
//
//  Created by songdan Ye on 16/4/1.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendOffDocDetailVC : UIViewController
{
    UIButton *openMaterialBtn;
    int mode; // 0:普通 1:搜索
    
}
//在办,已办,督办
//@property (nonatomic,copy)NSString *docProperty;

@property (strong, nonatomic)  UITableView *sendOffTableV;

//@property (nonatomic,strong)NSArray *datasource;
@property (nonatomic,strong)NSMutableArray *datasource;

@property (nonatomic,strong)NSMutableArray *searchSource;

//用来确定是传阅还是签阅(0/1)
@property (nonatomic,strong)NSString *forwardType;

//保存导航控制器
@property (strong,nonatomic)UINavigationController *nav;

@end
