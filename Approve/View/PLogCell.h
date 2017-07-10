//
//  PLogCell.h
//  XAYD
//
//  Created by songdan Ye on 15/12/30.
//  Copyright © 2015年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  PLogModel;
@interface PLogCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *states;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topC;

//保存当前cell显示数据
@property (nonatomic,retain) PLogModel *model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dayLableLeftC;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
