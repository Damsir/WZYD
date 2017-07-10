//
//  QuestionCell.h
//  WZYD
//
//  Created by 吴定如 on 16/12/13.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *userName; /**< 问题发布者信息 */
@property (weak, nonatomic) IBOutlet UILabel *reply; /**< 问题及回复详情 */
@property (weak, nonatomic) IBOutlet UIButton *replyButton; /**< 回复 */


@end
