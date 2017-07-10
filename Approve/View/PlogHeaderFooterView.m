//
//  PlogHeaderFooterView.m
//  XAYD
//
//  Created by songdan Ye on 16/3/29.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "PlogHeaderFooterView.h"
#import "PLogAllModel.h"
#import "CYQYAllModel.h"
//#import "MaterialModel.h"
@interface PlogHeaderFooterView ()
{
    UIButton *_bgButton;
    UIView *_line;
    
}

@end

@implementation PlogHeaderFooterView

+ (instancetype)pLogHeaderWithTableView:(UITableView *)tableView
{
    static NSString *headerIdentify =@"header";
    
    PlogHeaderFooterView *headView =[tableView dequeueReusableCellWithIdentifier:headerIdentify];
    if (headView == nil) {
        headView = [[PlogHeaderFooterView alloc] initWithReuseIdentifier:headerIdentify ];
        
    }
    return  headView;
    
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self =[super initWithReuseIdentifier:reuseIdentifier]) {
        UIButton *bgBut =[UIButton buttonWithType:UIButtonTypeCustom];
        bgBut.titleLabel.font =[UIFont systemFontOfSize:15];
        bgBut.titleLabel.numberOfLines = 0;
        [bgBut setImage:[UIImage imageNamed:@"riqi"] forState:UIControlStateNormal];
        [bgBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        bgBut.imageView.contentMode =UIViewContentModeCenter;
        bgBut.imageView.clipsToBounds = NO;
        bgBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        bgBut.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        bgBut.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [bgBut addTarget:self action:@selector(headBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [bgBut setBackgroundColor:[UIColor whiteColor]];
        _bgButton = bgBut;
        [self addSubview:_bgButton];
        UIView *line= [[UIView alloc] init];
        line.backgroundColor =[UIColor colorWithRed:145.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:0.5];
        _line = line;
        [self addSubview:_line];
        
    }
    return self;
    
}


//点击头部视图
- (void)headBtnClick
{
    if (self.cqModel) {
        _cqModel.opened = !_cqModel.isOpened;
    }else
    {
    
    _pLogAllModel.opened = !_pLogAllModel.isOpened;
    [_bgButton setTitle:_pLogAllModel.date forState:UIControlStateNormal];
    }   
    if ([_delegate respondsToSelector:@selector(clickHeaderView)]) {
        [_delegate clickHeaderView];
    }
    
}

- (void)setPLogAllModel:(PLogAllModel *)pLogAllModel
{
    _pLogAllModel = pLogAllModel;
    [_bgButton setTitle:pLogAllModel.date forState:UIControlStateNormal];

}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _bgButton.frame =self.bounds;
    
    _line.frame =CGRectMake(0, self.frame.size.height-0.5, self.frame.size.width, 0.5);
    
}




@end
