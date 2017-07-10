//
//  OfficialDocCell.h
//  XAYD
//
//  Created by songdan Ye on 16/4/5.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SPDetailModel;
@class CYQYModel;
@interface OfficialDocCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageState;
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *xmbh;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconLC;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLabelRC;

@property (nonatomic,strong)SPDetailModel *spDetailmodel;
@property (nonatomic,strong)CYQYModel *cqModel;


+ (instancetype)cellWithTableView:(UITableView *)tableView;



@end
