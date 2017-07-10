//
//  ApproYBViewController.h
//  XAYD
//
//  Created by songdan Ye on 16/4/8.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ListView.h"
#import "MJRefresh.h"
#import <UIKit/UIKit.h>
//#import "BaseListViewController.h"
#import "SendViewController.h"

@interface ApproYBViewController : SHBaseViewController <UITableViewDataSource,UITableViewDelegate,SendViewDelegate>
{
    UIButton *openMaterialBtn;
    int mode; // 0:普通 1:搜索
    
}
//在办,已办,督办
@property (nonatomic,copy) NSString *docProperty;
@property (nonatomic,strong) UINavigationController *nav;

-(void)screenRotation;

@end
