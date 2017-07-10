//
//  SHSiteCell.m
//  distmeeting
//
//  Created by songdan Ye on 15/12/16.
//  Copyright © 2015年 dist. All rights reserved.
//

#import "SHSiteCell.h"

@implementation SHSiteCell
/**
 * 创建cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString *siteId = @"siteID";
    
    SHSiteModel *cell = [tableView dequeueReusableCellWithIdentifier:siteId];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SHSiteCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}



- (void)setModel:(SHSiteModel *)model
{
    
    _model = model;
    
    _siteName.text = _model.name;
    
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
