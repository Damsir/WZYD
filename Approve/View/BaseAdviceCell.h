//
//  BaseAdviceCell.h
//  HAYD
//
//  Created by 吴定如 on 16/9/2.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseAdviceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *activityLabel;
@property (weak, nonatomic) IBOutlet UILabel *adviceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *popSignImage;

@end
