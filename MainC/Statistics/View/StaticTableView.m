//
//  StaticTableView.m
//  XAYD
//
//  Created by 叶松丹 on 16/7/13.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "StaticTableView.h"

@implementation StaticTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.frame =CGRectMake(0, 0, MainR.size.width, MainR.size.height-74-49);
    
    

}
@end
