//
//  OffiDocDetaiVController.h
//  XAYD
//
//  Created by songdan Ye on 16/4/1.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OffiDocDetaiVController : UIViewController
{
    UIButton *openMaterialBtn;
//    int mode; // 0:普通 1:搜索
    
}
//在办,已办,督办
//@property (nonatomic,copy)NSString *docProperty;
@property(nonatomic,assign) int mode;

@property (strong, nonatomic)  UITableView *offDDetailtableView;

@property (nonatomic,strong)NSMutableArray *datasource;

@property (nonatomic,strong)NSMutableArray *searchSource;

//用来加载传阅或者签阅的数据(传阅是0,签阅是1)
@property(nonatomic,strong)NSString *forwardType;
//保存导航控制器
@property (strong,nonatomic)UINavigationController *nav;

@end
