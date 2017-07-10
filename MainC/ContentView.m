//
//  ContentView.m
//  XAYD
//
//  Created by 叶松丹 on 16/7/5.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "ContentView.h"

@implementation ContentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

 - (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        if (_homeView == nil) {
            _homeView = [[SHHomeVV alloc] initWithFrame:frame];
            
        }
        [self addSubview:_homeView];

    }
    return self;
    }




-(void)layoutSubviews{
    [super layoutSubviews];

    _homeView.frame =self.frame;
    
    _homeView.mScrollPageView.frame= CGRectMake(0, MENUHEIHT, self.frame.size.width, self.frame.size.height - MENUHEIHT);
    _homeView.mMenuHriZontal.frame = CGRectMake(0, 0, SCREEN_WIDTH, MENUHEIHT);
}

@end
