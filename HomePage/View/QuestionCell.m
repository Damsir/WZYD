//
//  QuestionCell.m
//  WZYD
//
//  Created by 吴定如 on 16/12/13.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "QuestionCell.h"

@implementation QuestionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.replyButton.layer.cornerRadius = 3;
    self.replyButton.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
