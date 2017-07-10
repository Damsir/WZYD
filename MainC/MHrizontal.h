//
//  MHrizontal.h
//  XAYD
//
//  Created by songdan Ye on 16/3/28.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#define NOMALKEY   @"normalKey"
#define HEIGHTKEY  @"helightKey"
#define TITLEWIDTH @"titleWidth"
#define TOTALWIDTH @"totalWidth"

@protocol MHrizontalDelegate <NSObject>

@optional
-(void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)aIndex;
@end


@interface MHrizontal : UIView
{
    NSMutableArray        *mButtonArray;
    NSMutableArray        *mItemInfoArray;
    UIScrollView          *mScrollView;
    float                 mTotalWidth;
}

@property (nonatomic,assign) id <MHrizontalDelegate> delegate;

#pragma mark 初始化菜单
- (id)initWithFrame:(CGRect)frame ButtonItems:(NSArray *)aItemsArray;

#pragma mark 选中某个button
-(void)clickButtonAtIndex:(NSInteger)aIndex;

#pragma mark 改变第几个button为选中状态，不发送delegate
-(void)changeButtonStateAtIndex:(NSInteger)aIndex;

@end
