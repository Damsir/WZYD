//
//  TouchTableView.h
//  iBusiness
//
//  Created by zhangliang on 15/5/5.
//  Copyright (c) 2015年 sh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TouchTableViewDelegate <NSObject>

- (void)tableView:(UITableView *)tableView
     touchesBegan:(NSSet *)touches
        withEvent:(UIEvent *)event;
@end

@interface TouchTableView : UITableView
@property (nonatomic,assign) id<TouchTableViewDelegate> touchDelegate;
@end
