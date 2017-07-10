//
//  SHSiteList.h
//  distmeeting
//
//  Created by songdan Ye on 15/10/28.
//  Copyright (c) 2015年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SiteListDelegate;

@interface SHSiteList : UIView<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    NSString *_title;
    
}
@property (nonatomic,strong) NSMutableArray *sites;
@property (nonatomic, assign) id<SiteListDelegate> delegate;


- (id)initWithTitle:(NSString *)aTitle options:(NSArray *)aOptions;
- (void)showInView:(UIView *)aView animated:(BOOL)animated;
@end

@protocol SiteListDelegate <NSObject>

- (void)siteList:(SHSiteList *)SHSiteListView didSelectedIndex:(NSInteger)Index;
- (void)siteListViewDidCancel;

@end
