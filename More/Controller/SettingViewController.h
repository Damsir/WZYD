//
//  SettingViewController.h
//  XAYD
//
//  Created by songdan Ye on 15/12/31.
//  Copyright © 2015年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseViewController.h"
@interface SettingViewController : baseViewController<UIAlertViewDelegate>{
    UIAlertView *textAlert;
}

@property (nonatomic) BOOL swhOn;

@end
