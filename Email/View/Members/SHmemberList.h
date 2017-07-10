//
//  SHmemberList.h
//  distmeeting
//
//  Created by songdan Ye on 15/10/9.
//  Copyright (c) 2015年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHmemeberHeadder.h"

@interface SHmemberList : UIView <UITableViewDataSource, UITableViewDelegate,MemberHeaderDelegate>
{
    UITableView *_tableView;
    NSString *_title;
    UIView *_bView;
    UIImageView *_selectedAll;
    UIButton *_topbtn;
    
    
}
@property (nonatomic,assign) BOOL selected;


@property(nonatomic,strong) UIButton *confirmBtn;
@property(nonatomic,strong) UIButton *cancelBtn;
@property(nonatomic,strong) NSMutableArray *contacts;
@property(nonatomic,strong) UILabel *sumName;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UIView *innerView;
@property(nonatomic,strong) UIImageView *line;
@property(nonatomic,strong) UIImageView *imageV;

//初始化视图
- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title;
- (void)showInView:(UIView *)view animated:(BOOL)animated;

//屏幕旋转
-(void)screenRotation;

@property(nonatomic,strong) void(^selectedContactBlock)(NSString *contacts);

@end



