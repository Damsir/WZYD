//
//  ContactHeaderView.h
//  XAYD
//
//  Created by songdan Ye on 16/1/13.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SHMembersModel;
@class ContactModel;
@protocol ContactHeaderViewDelegate <NSObject>

@optional

- (void)clickHeaderView;

@end


@interface ContactHeaderView : UITableViewHeaderFooterView

{
    BOOL  m_checked;
}



@property (nonatomic,strong)SHMembersModel *membersModel;
@property (nonatomic,strong)ContactModel *ContactModel;
@property (nonatomic,assign)NSInteger contact;





@property (nonatomic ,weak) id<ContactHeaderViewDelegate> delegate;

+ (instancetype)memberHeaderWithTableView:(UITableView *)tableView;

- (void)tranformContatStatusWith:(NSInteger)status;

@end
