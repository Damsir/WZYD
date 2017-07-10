//
//  AnnoTableViewCell.h
//  XAYD
//
//  Created by songdan Ye on 16/2/29.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AnnoModel;
@interface AnnoTableViewCell : UITableViewCell

@property (nonatomic,strong)AnnoModel *annoModel;
@property (weak, nonatomic) IBOutlet UIView *bageView;
@property (weak, nonatomic) IBOutlet UILabel *lableTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelTypeName;
@property (weak, nonatomic) IBOutlet UILabel *comeFrom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipLeftC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLeftC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *comeFromLeftC;

@property (nonatomic,strong) NSDictionary *anDic;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
