//
//  AnnoTableViewCell.m
//  XAYD
//
//  Created by songdan Ye on 16/2/29.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "AnnoTableViewCell.h"
#import "AnnoModel.h"

@implementation AnnoTableViewCell

/**
 * 创建cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString *annoID = @"annoID";
    
    AnnoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:annoID];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AnnoTableViewCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}

- (void)setAnDic:(NSDictionary *)anDic
{
    _anDic =anDic;
    
    self.bageView.backgroundColor = [UIColor clearColor];
    self.bageView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.bageView.layer.cornerRadius = 2;
    self.bageView.layer.borderColor = [UIColor colorWithRed:0.871 green:0.875 blue:0.878 alpha:1.000].CGColor;
    self.bageView.layer.borderWidth = 0.5;
    
    self.lableTitle.text = [_anDic objectForKey:@"mainTitle"];
    self.labelTypeName.text =[_anDic objectForKey:@"publishTime"];
    self.comeFrom.text =[_anDic objectForKey:@"creater"];
//    annoModel.publishTime;



}


- (void)setAnnoModel:(AnnoModel *)annoModel
{
        _annoModel = annoModel;
        self.bageView.backgroundColor = [UIColor clearColor];
        self.bageView.layer.backgroundColor = [UIColor whiteColor].CGColor;
        self.bageView.layer.cornerRadius = 2;
        self.bageView.layer.borderColor = [UIColor colorWithRed:0.871 green:0.875 blue:0.878 alpha:1.000].CGColor;
        self.bageView.layer.borderWidth = 0.5;
    
    self.lableTitle.text = annoModel.mainTitle;
    self.labelTypeName.text = annoModel.publishTime;
    self.comeFrom.text =annoModel.comeFrom;

  

}





- (void)awakeFromNib {
    // Initialization code
}


//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    self.bageView.layer.cornerRadius = 6;
//    self.bageView.layer.masksToBounds = YES;
//
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
