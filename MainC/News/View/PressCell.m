//
//  PressCell.m
//  XAYD
//
//  Created by songdan Ye on 16/2/17.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "PressCell.h"
//#import "pressModel.h"

@implementation PressCell
/**
 * 创建cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString *pressID = @"pressID";
    
    PressCell *cell = [tableView dequeueReusableCellWithIdentifier:pressID];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PressCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}



-(void)setPressModel:(pressModel *)pressModel
{

    _pressModel = pressModel;
//    self.image.image =pressModel.content;
    self.title.text = pressModel.title;
    self.date.text = pressModel.date;

}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
