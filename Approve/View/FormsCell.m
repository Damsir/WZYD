//
//  FormsCell.m
//  XAYD
//
//  Created by songdan Ye on 16/3/30.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "FormsCell.h"

@implementation FormsCell
/**
 * 创建cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString *meetingId = @"fileID";
    
    FormsCell *cell = [tableView dequeueReusableCellWithIdentifier:meetingId];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FormsCell" owner:nil options:nil] lastObject];
        
    }
    
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




//- (void)layoutSubviews{
//    [super layoutSubviews];
//    float indentPoints = self.indentationLevel * self.indentationWidth;
//    
//    self.contentView.frame = CGRectMake(
//                                        indentPoints,
//                                        self.contentView.frame.origin.y,
//                                        self.contentView.frame.size.width - indentPoints,
//                                        self.contentView.frame.size.height
//                                        );
//}



- (void)setPrintModel:(PrintFromModel *)printModel
{
    _printModel =printModel;
    self.name.text = printModel.name;
    self.name.font =[UIFont fontWithName:@"Helvetica" size:15];
    
}


@end
