//
//  OfficialDocVV.h
//  XAYD
//
//  Created by songdan Ye on 16/4/1.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHrizontal.h"
#import "ScrollPageView.h"
@interface OfficialDocVV : UIView<MHrizontalDelegate,ScrollPageViewDelegate>

@property (nonatomic,strong)MHrizontal *mMenuHriZontal;
@property (nonatomic,strong)ScrollPageView *mScrollPageView;
@property (nonatomic,strong)UINavigationController *nav;
//@property (nonatomic,strong)NSString *DataType;
- (void) transNav:(UINavigationController *)nav;

@end
