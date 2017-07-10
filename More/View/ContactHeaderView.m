//
//  ContactHeaderView.m
//  XAYD
//
//  Created by songdan Ye on 16/1/13.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "ContactHeaderView.h"
#import "SHMembersModel.h"
#import "ContactModel.h"
@interface ContactHeaderView ()
{
    UIButton *_bgButton;
    UIView *_line;
}
@end
@implementation ContactHeaderView

- (void)setContact:(NSInteger )contact
{

}
- (void)tranformContatStatusWith:(NSInteger)status{
    self.contact = status;


}
+ (instancetype)memberHeaderWithTableView:(UITableView *)tableView
{
    static NSString *headerIdentify =@"header";
    ContactHeaderView *headView =[tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentify];
    if (headView == nil) {
        headView = [[ContactHeaderView alloc] initWithReuseIdentifier:headerIdentify];
    }
    return  headView;
    
}


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self =[super initWithReuseIdentifier:reuseIdentifier]) {
        UIButton *bgBut =[UIButton buttonWithType:UIButtonTypeCustom];
        [bgBut setImage:[UIImage imageNamed:@"jt"] forState:UIControlStateNormal];
        [bgBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        bgBut.imageView.contentMode =UIViewContentModeCenter;
        bgBut.imageView.clipsToBounds = NO;
        bgBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        bgBut.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        bgBut.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [bgBut setImageEdgeInsets:UIEdgeInsetsMake(0, MainR.size.width-40, 0, 40)];
        [bgBut addTarget:self action:@selector(headBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [bgBut setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:bgBut];
        _bgButton = bgBut;
  
        UIView *line= [[UIView alloc] init];
        line.backgroundColor =[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
        _line = line;
        [self addSubview:_line];
        
    }
    return self;
    
}



//点击头部视图
- (void)headBtnClick
{
    
    if (self.contact==1) {
        _ContactModel.opened = !_ContactModel.isOpened;
    }
    else
    {
    _membersModel.opened = !_membersModel.isOpened;
    //    [_bgButton setTitle:_membersModel.organName forState:UIControlStateNormal];
    }
    
    if ([_delegate respondsToSelector:@selector(clickHeaderView)]) {
        [_delegate clickHeaderView];
    }
    
}
- (void)setMembersModel:(SHMembersModel *)membersModel
{
    _membersModel = membersModel;
    [_bgButton setTitle:membersModel.organName forState:UIControlStateNormal];
    
}
- (void)setContactModel:(ContactModel *)ContactModel
{
    _ContactModel = ContactModel;
    [_bgButton setTitle:ContactModel.organName forState:UIControlStateNormal];


}

- (void)didMoveToSuperview
{
    
    if (self.contact==1) {
        _bgButton.imageView.transform = _ContactModel.isOpened?CGAffineTransformMakeRotation(M_PI_2):CGAffineTransformMakeRotation(0);
    }
    else
    {
   
        _bgButton.imageView.transform = _membersModel.isOpened?CGAffineTransformMakeRotation(M_PI_2):CGAffineTransformMakeRotation(0);
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _bgButton.frame =self.bounds;
    
    _line.frame =CGRectMake(25, self.frame.size.height-1, self.frame.size.width, 1);
    
}



@end
