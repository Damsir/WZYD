//
//  MatterIngVC.h
//  XAYD
//
//  Created by songdan Ye on 16/1/4.
//  Copyright © 2016年 dist. All rights reserved.
//待办事项

#import <UIKit/UIKit.h>

@interface MatterIngVC : UIViewController
{

 int mode; // 0:普通 1:搜索
}

@property (strong, nonatomic) UITableView *matterTableView;
@property (strong,nonatomic)UINavigationController *nav;





@end
