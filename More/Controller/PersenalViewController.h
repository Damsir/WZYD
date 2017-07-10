//
//  PersenalViewController.h
//  XAYD
//
//  Created by dist on 15/8/4.
//  Copyright (c) 2015年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersenalViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    UIAlertView *textAlert;
}


@property (weak, nonatomic) IBOutlet UITableView *tableViewPersonal;


@property (nonatomic) BOOL swhOn;

@end
