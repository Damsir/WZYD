//
//  ApproHomeView.h
//  XAYD
//
//  Created by songdan Ye on 16/4/8.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MHrizontal.h"
#import "ScrollPageView.h"

@interface ApproHomeView : UIView<MHrizontalDelegate,ScrollPageViewDelegate>

@property (nonatomic,strong)MHrizontal *approMenuHriZontal;
@property (nonatomic,strong)ScrollPageView *approScrollPageView;
@property (nonatomic,strong)UINavigationController *nav;


- (void) transNav:(UINavigationController *)nav;
@end
