//
//  PopSelectView.h
//  XAYD
//
//  Created by songdan Ye on 16/1/4.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#define imgW 10
#define imgH 10
#define tableH 150
#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)


@class PopSelectView;
@protocol PopSelectViewDelegate <NSObject>

-(void)selectAtIndex:(int)index inCombox:(PopSelectView *)_combox;

@end

@interface PopSelectView : UIView

@property (nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,assign)BOOL isOpen;
@property(nonatomic,strong)UITableView *listTable;
@property(nonatomic,strong)NSArray *titlesList;
@property(nonatomic,assign)int defaultIndex;
@property(nonatomic,assign)float tableHeight;
@property(nonatomic,strong)UIImageView *arrow;
@property(nonatomic,assign)id<PopSelectViewDelegate>delegate;

-(void)defaultSettings;
-(void)reloadData;
-(void)tapAction;



@end
