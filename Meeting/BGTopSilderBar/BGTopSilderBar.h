//
//  BGTopSilderBar.h
//  topSilderBar
//
//  Created by dingru Wu on 16/7/7.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "global.h"

//平常状态的颜色
#define NormalColor [UIColor blackColor]
//[UIColor colorWithRed:93.0/255.0 green:93.0/255.0 blue:93.0/255.0 alpha:1]
//被选中状态的颜色
#define SelectedColor BLUECOLOR
//[UIColor colorWithRed:243.0/255.0 green:39.0/255.0 blue:66.0/255.0 alpha:1]
//下划线的颜色
#define UnderlineColor BLUECOLOR
//[UIColor colorWithRed:243.0/255.0 green:39.0/255.0 blue:66.0/255.0 alpha:1]

//设置一页标题item有几个,默认6个
//#define itemNum 2
#define Margin 0
//#define W SCREEN_W/itemNum
#define H 50

@interface BGTopSilderBar : UIView

@property(nonatomic,weak)UICollectionView *contentCollectionView;
@property(nonatomic,assign)CGFloat underlineX;//下划线的x轴距离
@property(nonatomic,assign)CGFloat underlineWidth;//下划线的宽度

/**
 从某个item移动到另一个item
 */
-(void)setItemColorFromIndex:(NSInteger)fromIndex to:(NSInteger)toIndex;

/**
 屏幕旋转
 */
- (void)screenRotation;
-(instancetype)initWithFrame:(CGRect)frame WithControllerViewArray:(NSArray *)ViewsArray AndWithTitlesArray:(NSArray *)titlesArray;

@end
