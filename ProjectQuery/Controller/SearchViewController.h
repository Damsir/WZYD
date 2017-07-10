//
//  SearchViewController.h
//  WZYD
//
//  Created by 吴定如 on 16/10/25.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : SHBaseViewController

@property(nonatomic,strong) void(^SearchBlock)(NSDictionary *searchInfoDic);

@end
