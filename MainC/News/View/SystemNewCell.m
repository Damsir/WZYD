//
//  SystemNewCell.m
//  XAYD
//
//  Created by songdan Ye on 16/4/13.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "SystemNewCell.h"
#import "pressModel.h"



@implementation SystemNewCell



+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString *systemNewCell = @"cell";

SystemNewCell *cell = [tableView dequeueReusableCellWithIdentifier:systemNewCell];

if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"SystemNewCell" owner:nil options:nil] lastObject];
}

return cell;
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
- (void)setPModel:(pressModel *)pModel
{
    _pModel = pModel;
    //添加四个边阴影
    self.babaView.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
   self.babaView.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
   self.babaView.layer.shadowOpacity = 0.6;//不透明度
    self.babaView.layer.shadowRadius = 3.0;//半径
    
    self.bgView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.2];
    self.time.text = pModel.date;
    self.title.text = pModel.title;
//   self.title.text = @"第十届规划信息化实务论坛";
 
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
