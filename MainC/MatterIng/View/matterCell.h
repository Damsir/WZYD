//
//  matterCell.h
//  XAYD
//
//  Created by songdan Ye on 16/1/4.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "matterModel.h"
@interface matterCell : UITableViewCell
@property (nonatomic,strong)matterModel *matterModel;
@property (weak, nonatomic) IBOutlet UILabel *mainTitle;
@property (weak, nonatomic) IBOutlet UILabel *publishTime;


+ (instancetype)CellWithTableView:(UITableView *)tableView;
@end
