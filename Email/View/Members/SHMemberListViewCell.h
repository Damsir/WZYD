//
//  SHMemberListViewCell.h
//  distmeeting
//
//  Created by songdan Ye on 15/10/9.
//  Copyright (c) 2015年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHMemberListViewCell : UITableViewCell

{
BOOL			m_checked;
UIImageView*	m_checkImageView;
}
- (void)setChecked:(BOOL)checked;

@end
