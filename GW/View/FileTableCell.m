//
//  FileTableVCell.m
//  分层
//
//  Created by 叶松丹 on 16/1/14.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "FileTableCell.h"

@implementation FileTableCell

/**
 * 创建cell
 */

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.jiantou = [[UIImageView alloc]initWithFrame:CGRectMake(5, 15, 7, 11)];
        self.jiantou.image = [UIImage imageNamed:@"iconfont-jiantou"];
        [self.contentView addSubview:self.jiantou];
        
        self.fileImage = [[UIImageView alloc]initWithFrame:CGRectMake(13, 10, 20, 20)];
//        self.fileImage.image = [UIImage imageNamed:@"Icon"];
        [self.contentView addSubview:self.fileImage];
        
        self.name = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, 320, 20)];
        self.name.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.name];

        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    float indentPoints = self.indentationLevel * self.indentationWidth;
    
    self.contentView.frame = CGRectMake(
                                        indentPoints,
                                        self.contentView.frame.origin.y,
                                        self.contentView.frame.size.width - indentPoints,
                                        self.contentView.frame.size.height
                                        );
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString *meetingId = @"fileID";
    
    FileTableCell *cell = [tableView dequeueReusableCellWithIdentifier:meetingId];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FileTableVCell" owner:nil options:nil] lastObject];
    
    }
    
    return cell;
}






- (void)awakeFromNib {
    // Initialization code
}


@end
