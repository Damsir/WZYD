//
//  SPDetailCell.m
//  XAYD
//
//  Created by songdan Ye on 16/3/7.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "SPDetailCell.h"
#import "SPDetailModel.h"
#import "ComprehensiveModel.h"

@interface SPDetailCell ()


@end

@implementation SPDetailCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString *spDetailID = @"spDetailID";
    
    SPDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:spDetailID];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SPDetailCell" owner:nil options:nil] lastObject];
    }
    
    return cell;


}


- (void)setSpDetailmodel:(SPDetailModel *)spDetailmodel
{
    _spDetailmodel = spDetailmodel;
    self.title.text = spDetailmodel.name;
//    if ([[spDetailmodel.FLOWLEFTTIME substringToIndex:2]isEqualToString:@"剩余"]) {
//        self.time.text = _spDetailmodel.FLOWLEFTTIME;
//        [self.time setTextColor:RGB(71, 153, 222)];
//    self.imageState.image = [UIImage imageNamed:@"wenjianB"];
//
//    }
//    else if([[spDetailmodel.FLOWLEFTTIME substringToIndex:2]isEqualToString:@"超期"])
//    {
////    self.time.text =[NSString stringWithFormat:@"超期%@天",spDetailmodel.flowLeftTime];
//        self.time.text = _spDetailmodel.FLOWLEFTTIME;
////    [self.time setTextColor:RGB(145, 66, 73)];
//        [self.time setTextColor:RGB(238, 80, 57)];
//
//        self.imageState.image =[UIImage imageNamed:@"wenjianR"];
//    }
    
    
    if (_spDetailmodel.businessName)
    {
        //self.xmbh.text = _spDetailmodel.ProjectNo;
        self.xmbh.text = _spDetailmodel.businessName;
    }
    if (_spDetailmodel.ProjectCaseNo)
    {
       // self.xmbh.text = _spDetailmodel.ProjectId;
        self.xmbh.text = _spDetailmodel.ProjectCaseNo;
    }
    if (_spDetailmodel.activityName)
    {
        self.time.text = _spDetailmodel.activityName;
    }

}
- (void)setComModel:(searchResultModel *)comModel
{
    _comModel = comModel;
    self.title.text = comModel.xmmc;
    self.time.text =[NSString stringWithFormat:@"办理%@天",comModel.blts];
    self.imageState.image = [UIImage imageNamed:@"wenjianB"];
    self.xmbh.text = comModel.xmbh;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
