//
//  PlogHeaderFooterView.h
//  XAYD
//
//  Created by songdan Ye on 16/3/29.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PLogAllModel;
@class CYQYAllModel;
//@class MaterialModel;
@protocol PlogHeaderFooterViewDelegate <NSObject>

@optional

- (void)clickHeaderView;

@end

@interface PlogHeaderFooterView : UITableViewHeaderFooterView

@property (nonatomic,strong)NSDictionary *model;
@property (nonatomic,weak) id<PlogHeaderFooterViewDelegate>delegate;
@property (nonatomic,strong)PLogAllModel *pLogAllModel;

@property (nonatomic,strong)CYQYAllModel *cqModel;
//@property (nonatomic,strong)MaterialModel *mModel;

+ (instancetype)pLogHeaderWithTableView:(UITableView *)tableView;
@end
