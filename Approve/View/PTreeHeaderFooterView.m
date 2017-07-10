//
//  PTreeHeaderFooterView.m
//  XAYD
//
//  Created by songdan Ye on 15/12/30.
//  Copyright © 2015年 dist. All rights reserved.
//

#import "PTreeHeaderFooterView.h"
#import "PTreeModel.h"
#import "MaterialModel.h"
#import "CYQYAllModel.h"

@interface PTreeHeaderFooterView ()
{
    UIButton *_bgButton;
    UIView *_line;
    
    
}
@end
@implementation PTreeHeaderFooterView

+ (instancetype)pTreeHeaderWithTableView:(UITableView *)tableView fileTypeImageName:(NSString *)imageName
{
    static NSString *headerIdentify =@"header";
    
    PTreeHeaderFooterView *headView =[tableView dequeueReusableCellWithIdentifier:headerIdentify];
    if (headView == nil) {
        headView = [[PTreeHeaderFooterView alloc] initWithReuseIdentifier:headerIdentify imageName:imageName];
        
    }
    return  headView;

}
+ (instancetype)pTreeHeaderWithTableView:(UITableView *)tableView
{
    static NSString *headerIdentify =@"header";
    
    PTreeHeaderFooterView *headView =[tableView dequeueReusableCellWithIdentifier:headerIdentify];
    if (headView == nil) {
        headView = [[PTreeHeaderFooterView alloc] initWithReuseIdentifier:headerIdentify ];
        
    }
    return  headView;
    
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self =[super initWithReuseIdentifier:reuseIdentifier]) {
        UIButton *bgBut =[UIButton buttonWithType:UIButtonTypeCustom];
        bgBut.titleLabel.font =[UIFont systemFontOfSize:15];
        bgBut.titleLabel.numberOfLines = 0;
        [bgBut setImage:[UIImage imageNamed:@"sanjiao"] forState:UIControlStateNormal];
        [bgBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        bgBut.imageView.contentMode =UIViewContentModeCenter;
        bgBut.imageView.clipsToBounds = NO;
        bgBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        bgBut.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        bgBut.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [bgBut addTarget:self action:@selector(headBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [bgBut setBackgroundColor:[UIColor whiteColor]];
        _bgButton = bgBut;
        [self addSubview:_bgButton];
             //        UIButton *selBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        //        [selBtn addTarget:self action:@selector(selection:) forControlEvents:UIControlEventTouchUpInside];
        //        [self addSubview:selBtn];
        //        _selectBut= selBtn;
        
        UIView *line= [[UIView alloc] init];
        line.backgroundColor = GRAYCOLOR;
        _line = line;
        [self addSubview:_line];
        
    }
    return self;
    
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier imageName:(NSString *)imageName
{
    if (self =[super initWithReuseIdentifier:reuseIdentifier]) {
        UIButton *bgBut =[UIButton buttonWithType:UIButtonTypeCustom];
        bgBut.titleLabel.font =[UIFont systemFontOfSize:15];
        bgBut.titleLabel.numberOfLines = 0;
//        [bgBut setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [bgBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        bgBut.imageView.contentMode =UIViewContentModeCenter;
//        bgBut.imageView.clipsToBounds = NO;
        bgBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        bgBut.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
        bgBut.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        
        
        
        [bgBut addTarget:self action:@selector(headBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [bgBut setBackgroundColor:[UIColor whiteColor]];
        _bgButton = bgBut;
        [self addSubview:_bgButton];
        UIImageView *fileTypeImage =[[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 25, 25)];
        fileTypeImage.image = [UIImage imageNamed:imageName];
        [self addSubview:fileTypeImage];
      
        UIView *line= [[UIView alloc] init];
        line.backgroundColor = GRAYCOLOR;
        _line = line;
        [self addSubview:_line];
        
    }
    return self;
    
}


//点击头部视图
- (void)headBtnClick
{
    _pTreeModel.opened = !_pTreeModel.isOpened;
        [_bgButton setTitle:_pTreeModel.group forState:UIControlStateNormal];
    _mModel.opened = !_mModel.isOpened;
    _cqModel.opened = !_cqModel.isOpened;
    if ([_delegate respondsToSelector:@selector(clickHeaderView)]) {
        [_delegate clickHeaderView];
    }
    
}

- (void)setPTreeModel:(PTreeModel *)pTreeModel
{
    _pTreeModel = pTreeModel;
    NSInteger counts =pTreeModel.items.count;
    NSString *title =[NSString stringWithFormat:@"%@ (%ld)",pTreeModel.name,(long)counts];
    [_bgButton setTitle:title forState:UIControlStateNormal];

}

- (void)setMModel:(MaterialModel *)mModel
{
    _mModel =mModel;
    
//    NSInteger counts =mModel.files.count;
//    NSString *title =[NSString stringWithFormat:@"%@ (%ld)",mModel.group,(long)counts];
//    
//    [_bgButton setTitle:title forState:UIControlStateNormal];

}


- (void)setCqModel:(CYQYAllModel *)cqModel
{
    _cqModel =cqModel;
    NSInteger counts =cqModel.files.count;
    NSString *title =[NSString stringWithFormat:@"%@ (%ld)",cqModel.historydiscrption,(long)counts];
    
    [_bgButton setTitle:title forState:UIControlStateNormal];

}

- (void)didMoveToSuperview
{
    _bgButton.imageView.transform = _pTreeModel.isOpened?CGAffineTransformMakeRotation(M_PI_2):CGAffineTransformMakeRotation(0);
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _bgButton.frame =self.bounds;
    
    _line.frame =CGRectMake(0, self.frame.size.height-0.5, self.frame.size.width, 0.5);
    
}





@end
