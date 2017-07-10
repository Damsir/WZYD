//
//  OfficialBaseView.m
//  HAYD
//
//  Created by 叶松丹 on 16/7/25.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "OfficialBaseView.h"

@implementation OfficialBaseView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        if (_officialDocVV == nil) {
            _officialDocVV = [[OfficialDocVV alloc] initWithFrame:frame];
            _cqBaseView = [[CQBaseView alloc] initWithFrame:frame];
            
        }
        [self addSubview:_cqBaseView];
        [self addSubview:_officialDocVV];
        
    }
    return self;
}




-(void)layoutSubviews{
    [super layoutSubviews];
    
    _officialDocVV.frame = self.frame;
    _cqBaseView.frame =self.frame;
    
//        _officialDocVV.mScrollPageView.frame= CGRectMake(0, MENUHEIHT, self.frame.size.width, self.frame.size.height - MENUHEIHT);
//        _officialDocVV.mMenuHriZontal.frame = CGRectMake(0, 0, SCREEN_WIDTH, 37);
}

@end
