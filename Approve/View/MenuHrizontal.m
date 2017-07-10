//
//  MenuHrizontal.m
//  ShowProduct
//
//Created by songdan Ye on 15/12/28.
//  Copyright © 2015年 dist. All rights reserved.
//

#import "MenuHrizontal.h"
#import "NSString+StringSize.h"

#define BUTTONITEMWIDTH   70

@interface MenuHrizontal ()
@property (nonatomic,assign) float vButtonWidth ;
@property (nonatomic,assign) float ittemCount;
@end

@implementation MenuHrizontal
- (id)initWithFrame:(CGRect)frame ButtonItems:(NSArray *)aItemsArray
{
    self = [super initWithFrame:frame];
    if (self) {
        if (mButtonArray == nil) {
            mButtonArray = [[NSMutableArray alloc] init];
        }
        if (mScrollView == nil) {
            mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainR.size.width, self.frame.size.height)];
            mScrollView.showsHorizontalScrollIndicator = NO;
        
        }
        if (mItemInfoArray == nil) {
            mItemInfoArray = [[NSMutableArray alloc]init];
        }
        [mItemInfoArray removeAllObjects];
        [self createMenuItems:aItemsArray];
    }
    return self;
}

-(void)createMenuItems:(NSArray *)aItemsArray{
    int i = 0;
    float menuWidth = 0.0;
     _ittemCount =aItemsArray.count;
    

    for (NSDictionary *lDic in aItemsArray) {
        

        NSString *vTitleStr = [lDic objectForKey:TITLEKEY];

        //根据文字计算文字所需的宽度
        CGFloat fontSizte = 0.0;
        if (MainR.size.width==375) {
            fontSizte=18.0;
        }
        else if(MainR.size.width==320)
        {
            fontSizte = 16.0;
        }
        else
        {
            fontSizte=19.0;
 
            
        }
        
 
        _vButtonWidth = MainR.size.width/aItemsArray.count;

        UIButton *vButton = [UIButton buttonWithType:UIButtonTypeCustom];

        [vButton setTitle:vTitleStr forState:UIControlStateNormal];
        
        //设置按钮title的状态颜色
//        [vButton setTitleColor:[UIColor colorWithRed:31.0/255.0 green:88.0/255.0 blue:212.0/255.0 alpha:1] forState:UIControlStateSelected];
        //BLUECOLOR
        [vButton setTitleColor:RGB(34, 152, 239) forState:UIControlStateSelected];
// [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90] forState:UIControlStateSelected];

        [vButton setTitleColor:[UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:0.8] forState:UIControlStateNormal];
        [vButton setTag:i];
        [vButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [vButton setFrame:CGRectMake(menuWidth, 0, _vButtonWidth, self.frame.size.height)];
        [mScrollView addSubview:vButton];
        [mButtonArray addObject:vButton];
        menuWidth += _vButtonWidth;
        i++;
        
        //保存button资源信息，同时增加button.oringin.x的位置，方便点击button时，移动位置。
        NSMutableDictionary *vNewDic = [lDic mutableCopy];
        [vNewDic setObject:[NSNumber numberWithFloat:menuWidth] forKey:TOTALWIDTH];
        [mItemInfoArray addObject:vNewDic];
//    }
        [mScrollView setContentSize:CGSizeMake(MainR.size.width, self.frame.size.height)];
    [self addSubview:mScrollView];
    // 保存menu总长度，如果小于屏幕宽度则不需要移动，方便点击button时移动位置的判断
//    mTotalWidth = menuWidth+60;
        mTotalWidth = MainR.size.width;
    }
}

#pragma mark - 其他辅助功能


#pragma mark 选中第几个button
-(void)clickButtonAtIndex:(NSInteger)aIndex{
    //取出选中的按钮
    UIButton *vButton = [mButtonArray objectAtIndex:aIndex];
    [self menuButtonClicked:vButton];
}
#pragma mark - 点击事件
-(void)menuButtonClicked:(UIButton *)aButton{
    [self changeButtonStateAtIndex:aButton.tag];
    if ([_delegate respondsToSelector:@selector(didMenuHrizontalClickedButtonAtIndex:)]) {
        [_delegate didMenuHrizontalClickedButtonAtIndex:aButton.tag];
    }
}

#pragma mark 改变第几个button为选中状态，不发送delegate
-(void)changeButtonStateAtIndex:(NSInteger)aIndex{
    
    //按钮都设置为未选中
    for (UIButton *vButton in mButtonArray) {
        vButton.selected = NO;
    }
    //取出选中按钮
    UIButton *vButton = [mButtonArray objectAtIndex:aIndex];
    vButton.selected = YES;
    [vButton setBackgroundImage:[UIImage imageNamed:@"blue"] forState:UIControlStateSelected];

    //让按钮可视
    [self moveScrolViewWithIndex:aIndex];
}
//移动按钮scrollview
#pragma mark 移动button到可视的区域
-(void)moveScrolViewWithIndex:(NSInteger)aIndex{
    if (mItemInfoArray.count < aIndex) {
        return;
    }
     //宽度小于屏幕宽度肯定不需要移动
    if (mTotalWidth <= SCREEN_WIDTH) {
        return;
    }
    
    NSDictionary *vDic = [mItemInfoArray objectAtIndex:aIndex];
    
    float vButtonOrigin = [[vDic objectForKey:TOTALWIDTH] floatValue];
    if (vButtonOrigin >= 300) {
        if ((vButtonOrigin + 180) >= mScrollView.contentSize.width) {
            [mScrollView setContentOffset:CGPointMake(mScrollView.contentSize.width - MainR.size.width, mScrollView.contentOffset.y) animated:YES];
            return;
        }
        
        float vMoveToContentOffset = vButtonOrigin - 180;
        if (vMoveToContentOffset > 0) {
            [mScrollView setContentOffset:CGPointMake(vMoveToContentOffset, mScrollView.contentOffset.y) animated:YES];
        }
    }else{
        [mScrollView setContentOffset:CGPointMake(0, mScrollView.contentOffset.y) animated:YES];
            return;
    }
}


- (void)layoutSubviews

{
    [super layoutSubviews];
  
    mScrollView.frame =CGRectMake(0, 0, MainR.size.width, self.frame.size.height);
   
        _vButtonWidth =MainR.size.width/_ittemCount;
        
   
    CGFloat w = 0;
    for (UIButton *btn in mButtonArray) {
        
        btn.frame =CGRectMake(w, 0, _vButtonWidth, self.frame.size.height);
        w+=_vButtonWidth;
    }
    mScrollView.contentSize=CGSizeMake(MainR.size.width, self.frame.size.height);
    
    mTotalWidth = MainR.size.width;

}

@end
