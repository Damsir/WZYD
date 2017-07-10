//
//  PressCell.h
//  XAYD
//
//  Created by songdan Ye on 16/2/17.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pressModel.h"
@interface PressCell : UITableViewCell
@property (nonatomic,strong)pressModel *pressModel;
@property (weak, nonatomic) IBOutlet UIImageView *image;


@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *date;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
