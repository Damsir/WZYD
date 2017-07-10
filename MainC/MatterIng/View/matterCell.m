//
//  matterCell.m
//  XAYD
//
//  Created by songdan Ye on 16/1/4.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "matterCell.h"

@implementation matterCell
/**
 * 创建cell
 */

+(instancetype)CellWithTableView:(UITableView *)tableView
{
    NSString *matterID = @"matterID";
    
    matterCell *cell = [tableView dequeueReusableCellWithIdentifier:matterID];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"matterCell" owner:nil options:nil] lastObject];
    }
    
    return cell;


}


- (void)setMatterModel:(matterModel *)matterModel
{
    _matterModel = matterModel;
    self.mainTitle.text = matterModel.maintitle;
    self.publishTime.text = matterModel.publishtime;
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
