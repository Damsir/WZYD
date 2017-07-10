//
//  ContactsListTableViewCell.m
//  XAYD
//
//  Created by songdan Ye on 16/1/13.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "ContactsListTableViewCell.h"
#import "SHMembers.h"
#import "MembersModel.h"
#import "ContactModel.h"

@implementation ContactsListTableViewCell

/**
 * 创建cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString *meetingId = @"meetingID";
    
    ContactsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:meetingId];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactsListTableViewCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}


- (void)setMemsModel:(SHMembers *)memsModel
{
    
    self.subNameL.layer.cornerRadius = self.subNameL.bounds.size.width/2;
    self.subNameL.layer.masksToBounds = YES;
    
    _memsModel = memsModel;
    NSLog(@"%@",memsModel.name);
    
    self.name.text =memsModel.name;
    NSString *fullName = memsModel.name;
    NSString *firstName =[fullName substringToIndex:1];
    self.subNameL.text =firstName;
    self.phoneNumber.text =memsModel.phoneNumber;

    
}

- (void)setMModel:(ContactModel *)mModel
{
    self.subNameL.layer.cornerRadius = self.subNameL.bounds.size.width/2;
    self.subNameL.layer.masksToBounds = YES;
    
    _mModel = mModel;
    NSLog(@"%@",mModel.Name);
    
    self.name.text =mModel.Name;
   // NSString *fullName = mModel.Name;
   // NSString *firstName =[fullName substringToIndex:1];
    self.subNameL.text = [NSString stringWithFormat:@"%@",mModel.index];
    self.phoneNumber.text =mModel.bmName;

}

//
//
//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        self.backgroundColor = [UIColor whiteColor];
//        self.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.];
//        
//        [self creat];
//    }
//    return self;
//}
//
//
//- (void)creat{
//    if (m_checkImageView == nil)
//    {
//        m_checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calendar_date_focused"]];
//        m_checkImageView.frame = CGRectMake(self.frame.size.width - 85, 10, 19, 19);
//        [self addSubview:m_checkImageView];
//    }
//}
//
//
//
//- (void)setChecked:(BOOL)checked{
//    if (checked)
//    {
//        
//        m_checkImageView.image = [UIImage imageNamed:@"iconfont-check"];
//        self.backgroundView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1.0];
//    }
//    else
//    {
//        m_checkImageView.image = [UIImage imageNamed:@"btn_check_off_holo_light1"];
//        self.backgroundView.backgroundColor = [UIColor whiteColor];
//    }
//    m_checked = checked;
//    
//    
//}
//
//
//
//
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    self.imageView.frame = CGRectOffset(self.imageView.frame, 15, 0);
//    self.textLabel.frame = CGRectOffset(self.textLabel.frame, 15, 0);
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}



- (void)awakeFromNib {
    // Initialization code
}

@end
