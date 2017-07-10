//
//  BaseMessageCell.h
//  KSYD
//
//  Created by 吴定如 on 16/8/25.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseMessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *detailTitle;

@end
