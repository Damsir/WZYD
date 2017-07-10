//
//  OfficialDocCell.m
//  XAYD
//
//  Created by songdan Ye on 16/4/5.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "OfficialDocCell.h"
#import "SPDetailModel.h"
#import "CYQYModel.h"

@implementation OfficialDocCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString *spDetailID = @"spDetailID";
    
    OfficialDocCell *cell = [tableView dequeueReusableCellWithIdentifier:spDetailID];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OfficialDocCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
    
    
}


- (void)setSpDetailmodel:(SPDetailModel *)spDetailmodel
{
    _spDetailmodel = spDetailmodel;
    self.title.text = spDetailmodel.projectName;
//    if (spDetailmodel.day.length == 0) {
//        self.time.text = @"不计时";
//        [self.time setTextColor:RGB(71, 153, 222)];
    self.imageState.image = [UIImage imageNamed:@"wenjianB"];
    //self.imageState.image = [UIImage imageNamed:@"sp_green"];
    
//    }
//    else
//    {
////        self.time.text =[NSString stringWithFormat:@"超期%@天",spDetailmodel.day];
////        [self.time setTextColor:RGB(145, 66, 73)];
//        self.imageState.image =[UIImage imageNamed:@"wenjianB@2x"];
//    }
    // "time": "2015/12/1 15:05:03",
    NSArray *arr=[spDetailmodel.time componentsSeparatedByString:@" "];
    NSString *subString =[arr objectAtIndex:0];
//    NSString *year =[arr objectAtIndex:0];
//    NSString *month =[arr objectAtIndex:1];
//    NSArray *temparr= [subString componentsSeparatedByString:@" "];
//    NSString *day=[temparr objectAtIndex:0];
//    self.time.text = [NSString stringWithFormat:@"%@年%@月%@日",year,month,day];

    self.time.text = subString;
    self.xmbh.text = spDetailmodel.xmbh;
    
    
}



- (void)setCqModel:(CYQYModel *)cqModel
{
    _cqModel = cqModel;
    self.title.text = cqModel.name;
//    if (cqModel.time.length == 0) {
//        //        self.time.text = @"不计时";
//        //        [self.time setTextColor:RGB(71, 153, 222)];
        self.imageState.image = [UIImage imageNamed:@"wenjianB"];
        
//    }
//    else
//    {
//        //        self.time.text =[NSString stringWithFormat:@"超期%@天",spDetailmodel.day];
//        //        [self.time setTextColor:RGB(145, 66, 73)];
//        self.imageState.image =[UIImage imageNamed:@"wenjianB@2x"];
//    }
    // "time": "2015/12/1 15:05:03",
    NSArray *arr=[cqModel.time componentsSeparatedByString:@" "];
    NSString *subString =[arr objectAtIndex:0];
    //    NSString *year =[arr objectAtIndex:0];
    //    NSString *month =[arr objectAtIndex:1];
    //    NSArray *temparr= [subString componentsSeparatedByString:@" "];
    //    NSString *day=[temparr objectAtIndex:0];
    //    self.time.text = [NSString stringWithFormat:@"%@年%@月%@日",year,month,day];
    
    self.time.text = subString;
    self.xmbh.text = cqModel.bh;

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
