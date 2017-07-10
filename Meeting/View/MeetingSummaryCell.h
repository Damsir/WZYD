//
//  MeetingSummaryCell.h
//  HAYD
//
//  Created by 吴定如 on 16/9/7.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeetingSummaryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end
