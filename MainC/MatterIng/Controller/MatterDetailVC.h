//
//  MatterDetailVC.h
//  XAYD
//
//  Created by songdan Ye on 16/3/1.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@class matterModel;

@interface MatterDetailVC : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,strong)matterModel *matModel;

@end
