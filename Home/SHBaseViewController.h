//
//  SHBaseViewController.h
//  WZYD
//
//  Created by 吴定如 on 17/5/16.
//  Copyright © 2017年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface SHBaseViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

/** 网络状态 */
@property (nonatomic,assign) NetworkStatus status;
/** 公共表格 */
@property (nonatomic,strong) UITableView *tableView;
/** 无数据提示 */
- (void)showEmptyData;
/** 移除无数据提示 */
- (void)removeEmptyData;
/** 导航栏标题 */
- (void)initNavigationBarTitle:(NSString *)title;
/** 导航栏按钮(左侧) */
- (UIButton *)createNavigationLeftBarButtonTitle:(NSString *)title;
/** 导航栏按钮(右侧) */
- (UIButton *)createNavigationRightBarButtonTitle:(NSString *)title;
/** CustomButton */
- (UIButton *)createCustomButtonWithTitle:(NSString *)title;
/** 纯色图片 */
- (UIImage *)imageWithColor:(UIColor *)color;
/** 删除字典里的null */
- (NSDictionary *)deleteNullWithDictionary:(NSDictionary *)dic;

@end
