//
//  DamMemberList.h
//  WZYD
//
//  Created by 吴定如 on 16/12/4.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DamMemberList : UIView

{
    UIView *_bView;
    UIImageView *_selectedAll;
    UIButton *_topbtn;
}

@property (nonatomic,assign) BOOL selected;
@property(nonatomic,strong) UIButton *confirmBtn;
@property(nonatomic,strong) UIButton *cancelBtn;
@property(nonatomic,strong) UILabel *sumName;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UIView *innerView;
@property(nonatomic,strong) UIImageView *line;
@property(nonatomic,strong) UIImageView *imageV;
@property(nonatomic,strong) NSString *nameString;

//初始化视图
- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title;
- (void)showInView:(UIView *)view animated:(BOOL)animated;

//屏幕旋转
-(void)screenRotation;

@property(nonatomic,strong) void(^selectedContactBlock)(NSString *contacts);

@end
