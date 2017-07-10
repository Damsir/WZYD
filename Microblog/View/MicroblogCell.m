//
//  MicroblogCell.m
//  WZYD
//
//  Created by 吴定如 on 16/11/10.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "MicroblogCell.h"

@implementation MicroblogCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backView.layer.cornerRadius = 25.0;
    self.backView.clipsToBounds = YES;
    self.reply.layer.cornerRadius = 3;
    self.reply.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
