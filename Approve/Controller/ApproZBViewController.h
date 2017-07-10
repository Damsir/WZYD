//
//  ApproZBViewController.h
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
//#import "baseTable.h"

@interface ApproZBViewController : SHBaseViewController
<UITableViewDataSource,UITableViewDelegate,SendViewDelegate>
{
    int mode; // 0:普通 1:搜索
    
}

@property (nonatomic,strong) UINavigationController *nav;

-(void)screenRotation;

@end
