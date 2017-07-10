//
//  ApproveBaseView.m
//  XAYD
//
//  Created by 叶松丹 on 16/7/6.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "ApproveBaseView.h"

@implementation ApproveBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        if (_approHomeView == nil) {
            _approHomeView = [[ApproHomeView alloc] initWithFrame:frame];
            
        }
        [self addSubview:_approHomeView];
        
    }
    return self;
}




-(void)layoutSubviews{
    [super layoutSubviews];
    

    if (_approHomeView.approScrollPageView.openSB) {
                _approHomeView.frame =CGRectMake(0, 20, self.frame.size.width, self.frame.size.height);
                _approHomeView.approMenuHriZontal.frame= CGRectMake(0, 0, SCREEN_WIDTH*2/3, MENUHEIHT);
                _approHomeView.approScrollPageView.openSB = YES;
                _approHomeView.approScrollPageView.frame = CGRectMake(0, MENUHEIHT+44, self.frame.size.width, self.frame.size.height - MENUHEIHT);
            }
    else
    {
        _approHomeView.frame =CGRectMake(0, 20, self.frame.size.width, self.frame.size.height);
            _approHomeView.approMenuHriZontal.frame= CGRectMake(0, 0, SCREEN_WIDTH*2/3, MENUHEIHT);
                _approHomeView.approScrollPageView.openSB = NO;
        
            _approHomeView.approScrollPageView.frame = CGRectMake(0, MENUHEIHT, self.frame.size.width, self.frame.size.height - MENUHEIHT);
    
    }
    
}


@end
