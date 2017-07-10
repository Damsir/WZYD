//
//  SHMeetingDCell.m
//  distmeeting
//
//  Created by songdan Ye on 15/10/21.
//  Copyright (c) 2015年 dist. All rights reserved.
//

#import "SHMeetingDCell.h"
#import "SHMeetingModel.h"
#import "UIImageView+AFNetworking.h"

@implementation SHMeetingDCell

/**
 * 创建cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString *meetingId = @"meetingID";
    
    SHMeetingModel *cell = [tableView dequeueReusableCellWithIdentifier:meetingId];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SHMeetingDCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}



- (void)setModel:(SHMeetingModel *)model
{

    _model = model;
    NSURL *url =nil;
   

    
    NSString *url1 = [NSString stringWithFormat:@"%@/DistMobile/appIcon/userIcon/%@.jpg?r=1",DistMUrl,self.model.presenterid];
    NSString *url2 = [NSString stringWithFormat:@"%@/DistMobile/appIcon/userIcon/%@.jpg",DistMUrl,self.model.presenterid];


    
    if ([_model.presenterid isEqualToString:[defaults objectForKey:@"userId"]]) {
         url = [NSURL URLWithString:url1];
    }
    else{
        url = [NSURL URLWithString:url2];
    }
    //将图片设置为圆形的
    _presenticon.layer.cornerRadius = _presenticon.frame.size.width/2.0;
    _presenticon.layer.masksToBounds = YES;
    [_presenticon.layer setBorderWidth:1];
    [_presenticon.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.presenticon setImageWithURL:url placeholderImage:[UIImage imageNamed:@"meeting.png"]];
    
    self.meetingtitle.text = _model.meetingtitle;
    self.meetingplace.text = _model.meetingplace;
    
    NSString*ss =_model.starttime;
    
    self.starttime.text = [ss substringToIndex:16];
    self.userName.text = _model.userName;

}


- (void)awakeFromNib {
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
