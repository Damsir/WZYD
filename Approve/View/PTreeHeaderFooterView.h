//
//  PTreeHeaderFooterView.h
//  XAYD
//
//  Created by songdan Ye on 15/12/30.
//  Copyright © 2015年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PTreeModel;
@class MaterialModel;
@class CYQYAllModel;

@protocol PTreeHeaderFooterViewDelegate <NSObject>

@optional

- (void)clickHeaderView;

@end
@interface PTreeHeaderFooterView : UITableViewHeaderFooterView


@property (nonatomic,strong)NSDictionary *model;
@property (nonatomic,weak) id<PTreeHeaderFooterViewDelegate>delegate;

@property (nonatomic,strong)PTreeModel *pTreeModel;
@property (nonatomic,strong)MaterialModel *mModel;
//传阅签阅历史模型
@property (nonatomic,strong)CYQYAllModel *cqModel;


+ (instancetype)pTreeHeaderWithTableView:(UITableView *)tableView fileTypeImageName:(NSString *)imageName;
+ (instancetype)pTreeHeaderWithTableView:(UITableView *)tableView;


@end

