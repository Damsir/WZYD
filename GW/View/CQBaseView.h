//
//  CQBaseView.h
//  WSYD
//
//  Created by 叶松丹 on 16/9/19.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHrizontal.h"
#import "ScrollPageView.h"
@interface CQBaseView : UIView<MHrizontalDelegate,ScrollPageViewDelegate>

@property (nonatomic,strong)MHrizontal *mMenuHriZontal;
@property (nonatomic,strong)ScrollPageView *mScrollPageView;
@property (nonatomic,strong)UINavigationController *nav;
//@property (nonatomic,strong)NSString *DataType;

- (void) transNav:(UINavigationController *)nav;

@end
