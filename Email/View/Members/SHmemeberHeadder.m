//
//  SHmemeberHeadder.m
//  distmeeting
//
//  Created by songdan Ye on 15/10/29.
//  Copyright (c) 2015年 dist. All rights reserved.
//

#import "SHmemeberHeadder.h"
#import "MailContactModel.h"

@interface SHmemeberHeadder ()
{
    UIButton *_bgButton;
    UIView *_line;
    

}
@end


@implementation SHmemeberHeadder

+ (instancetype)memberHeaderWithTableView:(UITableView *)tableView
{
    static NSString *headerIdentify = @"header";
    
    SHmemeberHeadder *headView =[tableView dequeueReusableCellWithIdentifier:headerIdentify];
    if (headView == nil) {
        headView = [[SHmemeberHeadder alloc] initWithReuseIdentifier:headerIdentify];
        
    }
    return  headView;

}




- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self =[super initWithReuseIdentifier:reuseIdentifier]) {
        UIButton *bgBut =[UIButton buttonWithType:UIButtonTypeCustom];
        [bgBut.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [bgBut setImage:[UIImage imageNamed:@"iconfont-jiantou"] forState:UIControlStateNormal];
        [bgBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        bgBut.imageView.contentMode =UIViewContentModeCenter;
        bgBut.imageView.clipsToBounds = NO;
        bgBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        bgBut.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        bgBut.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [bgBut addTarget:self action:@selector(headBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [bgBut setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:bgBut];
        _bgButton = bgBut;
        UIButton *selBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [selBtn addTarget:self action:@selector(selection:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:selBtn];
        _selectBut= selBtn;
       
       UIView *line= [[UIView alloc] init];
        line.backgroundColor =RGB(238.0, 238.0, 238.0);
        _line = line;
        [self addSubview:_line];
    
    }
    return self;

}


//点击选择组按钮
- (void)selection:(UIButton *)btn
{
    //    NSLog(@"btn.selected = %i ",btn.selected);
    //    if (btn.isSelected == true) {
    //        btn.selected = false;
    //    }
    //    else
    //    {
    //        btn.selected = true;
    //    }
    //    btn.selected = !btn.selected;
    //    NSLog(@"btn.selected = %i ",btn.selected);
    
    if ([_delegate respondsToSelector:@selector(selctGroupWithButton:)]) {
        [_delegate selctGroupWithButton:btn];
    }
    
}



//点击头部视图
- (void)headBtnClick
{

    _membersModel.opened = !_membersModel.isOpened;
    if ([_delegate respondsToSelector:@selector(clickHeaderView)]) {
        [_delegate clickHeaderView];
    }

}

- (void)setMembersModel:(MailContactModel *)membersModel
{
    _membersModel = membersModel;
    [_bgButton setTitle:[NSString stringWithFormat:@"%@(%ld)",membersModel.bmName,membersModel.users.count] forState:UIControlStateNormal];
    if (!_membersModel.isSelected) {

        [_selectBut setImage:[UIImage imageNamed:@"iconfont-unselected"] forState:UIControlStateNormal];
    }
    else
    {
    
        [_selectBut setImage:[UIImage imageNamed:@"iconfont-selected"] forState:UIControlStateNormal];
    }
}

- (void)didMoveToSuperview
{
    _bgButton.imageView.transform = _membersModel.isOpened?CGAffineTransformMakeRotation(M_PI_2):CGAffineTransformMakeRotation(0);

}
                                                                                                
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _bgButton.frame =self.bounds;
    
    _line.frame =CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1);


    //选择的imageView
    _selectBut.frame = CGRectMake(self.frame.size.width-50-10, -5, 50, 50);
    _selectBut.imageEdgeInsets = UIEdgeInsetsMake(13, 13, 13, 13);
   
}




@end
