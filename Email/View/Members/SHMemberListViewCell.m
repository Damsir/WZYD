//
//  SHMemberListViewCell.m
//  distmeeting
//
//  Created by songdan Ye on 15/10/9.
//  Copyright (c) 2015年 dist. All rights reserved.
//

#import "SHMemberListViewCell.h"

@implementation SHMemberListViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14.];
        
        [self creat];
    }
    return self;
}

- (void)creat{
    if (m_checkImageView == nil)
    {
        m_checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calendar_date_focused"]];
        //        m_checkImageView.frame = CGRectMake(self.frame.size.width - 85, 10, 19, 19);
        //        m_checkImageView.frame = CGRectMake(self.frame.size.width-20-10 , 10, 20, 20);
        m_checkImageView.frame = CGRectMake(self.frame.size.width-100 , 10, 20, 20);
        
        if (MainR.size.width>414) {
            //             m_checkImageView.frame = CGRectMake(self.frame.size.width+200 , 10, 20,
            //            20);
            m_checkImageView.frame = CGRectMake(self.frame.size.width , 10, 20, 20);
            
        }
        [self.contentView addSubview:m_checkImageView];
    }
}



- (void)setChecked:(BOOL)checked{
    if (checked)
    {
        
        m_checkImageView.image = [UIImage imageNamed:@"iconfont-check"];
        self.backgroundView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1.0];
    }
    else
    {
        m_checkImageView.image = [UIImage imageNamed:@"btn_check_off_holo_light1"];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
    }
    m_checked = checked;
    
    
}




- (void)layoutSubviews
{
    [super layoutSubviews];
//    self.imageView.frame = CGRectOffset(self.imageView.frame, 15, 0);
    self.textLabel.frame = CGRectOffset(self.textLabel.frame, 15, 0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}



- (void)awakeFromNib {
    // Initialization code
}



@end
