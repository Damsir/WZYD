//
//  SystemNewCell.h
//  XAYD
//
//  Created by songdan Ye on 16/4/13.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
@class pressModel;
@interface SystemNewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (nonatomic,strong)pressModel *pModel;
@property (weak, nonatomic) IBOutlet UIImageView *balckImageView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewOfNewsBHeightC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewLC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewRC;

//标题离顶部的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLTopC;
@property (weak, nonatomic) IBOutlet UIImageView *babaView;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
