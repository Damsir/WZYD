//
//  SHmemeberHeadder.h
//  distmeeting
//
//  Created by songdan Ye on 15/10/29.
//  Copyright (c) 2015年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MailContactModel;

@protocol MemberHeaderDelegate <NSObject>

@optional

- (void)clickHeaderView;

- (void)selctGroupWithButton:(UIButton *)btn;

@end


@interface SHmemeberHeadder : UITableViewHeaderFooterView

{
    BOOL			m_checked;
//    UIImageView*	m_checkImageView;
}

@property (nonatomic,strong) MailContactModel *membersModel;

 @property (nonatomic ,strong) UIButton *selectBut;



@property (nonatomic ,weak) id<MemberHeaderDelegate> delegate;

+ (instancetype)memberHeaderWithTableView:(UITableView *)tableView;
- (void)setChecked:(BOOL)checked;



@end
