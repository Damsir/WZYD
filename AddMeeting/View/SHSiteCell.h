//
//  SHSiteCell.h
//  distmeeting
//
//  Created by songdan Ye on 15/12/16.
//  Copyright © 2015年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHSiteModel.h"

@interface SHSiteCell : UITableViewCell

//保存当前cell显示数据
@property (nonatomic,retain) SHSiteModel *model;

@property (weak, nonatomic) IBOutlet UILabel *siteName;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
