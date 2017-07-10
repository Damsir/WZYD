//
//  PLogCell.m
//  XAYD
//
//  Created by songdan Ye on 15/12/30.
//  Copyright © 2015年 dist. All rights reserved.
//

#import "PLogCell.h"
#import "PLogModel.h"
@implementation PLogCell


/**
 * 创建cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString *meetingId = @"meetingID";
    
    PLogCell *cell = [tableView dequeueReusableCellWithIdentifier:meetingId];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PLogCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}


//
- (void)setModel:(PLogModel *)model
{
    _model = model;
    //
    //    "Id": "21a8a873d0bc48a4a04da1b7fea5fa09",
    //    "StartTime": "2015/12/1 15:05:25",
    //    "EndTime": "2015/12/4 1:31:27",
    //    "LogName": "窗口受理，初审",
    //    "UserName": "banyq",
    //    "Type": "发送",
    //    "Remark": "经办复审（banyq）"
    //    NSInteger *timeY =[[starT substringToIndex:4] integerValue];
    //    NSInteger *timeM = [[starT substringWithRange:NSMakeRange(5, 2)] integerValue];
    //
    //    NSInteger * timeD = [[starT substringWithRange:NSMakeRange(8, 2)] integerValue];
    //
    
    // self.remarkLab.text = [NSString stringWithFormat:@"%@:%@",model.type,model.remark];
    
    
    
    NSArray *arr=[model.ReceiveTime componentsSeparatedByString:@"/"];
    NSString *subString =[arr objectAtIndex:2];
    NSArray *temparr= [subString componentsSeparatedByString:@" "];
    NSString *day=[temparr objectAtIndex:0];
    self.dayLabel.text = day;
    
    //_dayLabel.bounds.size.width/2;
    
    NSString *textStr=[temparr objectAtIndex:1];
    NSArray *tt =[textStr componentsSeparatedByString:@":"];
    NSString *hh = [tt objectAtIndex:0];
    NSString *minte =[tt objectAtIndex:1];
    
    NSString *riqi =[NSString stringWithFormat:@"%@:%@",hh,minte];
    self.timeLabel.text = riqi;
    NSString *a=[NSString stringWithFormat:@"%@(%@ -> %@)",model.ActivityContent,model.PreviousRoleName,model.NextRoleName];
    
    self.states.text = a;
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
