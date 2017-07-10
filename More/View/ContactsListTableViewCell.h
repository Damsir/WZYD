//
//  ContactsListTableViewCell.h
//  XAYD
//
//  Created by songdan Ye on 16/1/13.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SHMembers;
@class MembersModel;
@class ContactModel;
@interface ContactsListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *subNameL;

//
//{
//    BOOL			m_checked;
//    UIImageView*	m_checkImageView;
//}
@property (nonatomic,strong)SHMembers *memsModel;
@property (nonatomic,strong)ContactModel *mModel;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

//- (void)setChecked:(BOOL)checked;

@end
