//
//  SPDetailCell.h
//  XAYD
//
//  Created by songdan Ye on 16/3/7.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComprehensiveModel.h"

@class SPDetailModel;
@interface SPDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageState;
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *xmbh;
@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UILabel *smDetail;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flowLeftTimeRC;

@property (nonatomic,strong)SPDetailModel *spDetailmodel;
@property (nonatomic,strong)searchResultModel *comModel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconImageLC;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
