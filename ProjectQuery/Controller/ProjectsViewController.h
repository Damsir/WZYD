//
//  ProjectsViewController.h
//  WZYD
//
//  Created by 吴定如 on 16/10/25.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueryModel.h"

@interface ProjectsViewController : SHBaseViewController

@property(nonatomic,strong) ChildModel *childModel;
@property(nonatomic,strong) NSDictionary *searchInfoDic; /**< 查询信息 */

@end
