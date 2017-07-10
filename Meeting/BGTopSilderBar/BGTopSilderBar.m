//
//  BGTopSilderBar.m
//  topSilderBar
//
//  Created by dingru Wu on 16/7/7.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "BGTopSilderBar.h"
#import "BGTopSilderBarCell.h"
#import "MyGlobal.h"

@interface BGTopSilderBar()<UICollectionViewDataSource, UICollectionViewDelegate,UIScrollViewDelegate>
{
    NSInteger itemNum;
    CGFloat W;
}

@property(nonatomic,strong)NSArray *items;//collection
@property(nonatomic,strong)NSArray *viewsArray;//控制器的view
@property(nonatomic,strong)UICollectionViewFlowLayout *layout;
@property(nonatomic,strong)UICollectionView *collectView;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIView *underline;
@property(nonatomic,assign)NSInteger currentBarIndex;//当前选中item的位置

@end

static NSString *BGTopSilderBarCellID = @"BGTopSilderBarCell";

@implementation BGTopSilderBar

-(instancetype)initWithFrame:(CGRect)frame WithControllerViewArray:(NSArray *)ViewsArray AndWithTitlesArray:(NSArray *)titlesArray
{
    self = [super initWithFrame:frame];
    if (self)
    {
        itemNum = ViewsArray.count;
        _viewsArray = ViewsArray;
        W = SCREEN_W/itemNum;
        _currentBarIndex = 0;
        _items = titlesArray;
        [self initCollectView];
        [self initUnderline];
        
    }
    return self;
}

- (void)screenRotation
{
    //屏幕旋转的时候每个collectView的宽度也要改变
    W = SCREEN_W/itemNum;
    CGRect rect = CGRectMake(Margin,0,SCREEN_W,H);
    _layout.itemSize = CGSizeMake(W, H);
    //初始化collectionView
    _collectView.frame = rect;
    
    _scrollView.frame = CGRectMake(0, H, SCREEN_W, SCREEN_H-H-64);
    _scrollView.contentSize = CGSizeMake(SCREEN_W*2, SCREEN_H-H-64);
    _scrollView.contentOffset = CGPointMake(_currentBarIndex*SCREEN_W, 0);
    NSLog(@"_currentBarIndex::%ld",(long)_currentBarIndex);
    //每个控制器的view改变frame
    for (int i=0; i<_viewsArray.count; i++)
    {
        UIView *view = _viewsArray[i];
        view.frame = CGRectMake(i*SCREEN_W, 0, SCREEN_W, SCREEN_H-H-64);
    }
    
    _underline.frame = CGRectMake(_scrollView.contentOffset.x/itemNum,48,SCREEN_W/itemNum,2);
    
}
/**
 初始化下划线
 */
-(void)initUnderline
{
    CGSize titleSize = [MyGlobal sizeWithText:[_items firstObject] font:BGFont(BigSize) maxSize:CGSizeMake(SCREEN_W/itemNum, MAXFLOAT)];
    //和字体宽度一样宽的下划线
    //UIView *underline = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_W/itemNum - titleSize.width)*0.5,48,titleSize.width,2)];
    UIView *underline = [[UIView alloc] initWithFrame:CGRectMake(0 ,48,SCREEN_W/itemNum,2)];
    underline.backgroundColor = UnderlineColor;
    _underline  = underline;
    [_collectView addSubview:underline];
}
/**
 初始化装载导航文字的collectView
 */
-(void)initCollectView{
    
    //    CGFloat Margin = 0;
    //    CGFloat W = SCREEN_W/itemNum;
    //    CGFloat H = 50;
    CGRect rect = CGRectMake(Margin,0,SCREEN_W,H);
    //初始化布局类(UICollectionViewLayout的子类)
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    _layout = layout;
    layout.itemSize = CGSizeMake(W, H);
    layout.minimumInteritemSpacing = 0;//设置行间隔
    layout.minimumLineSpacing = 0;//设置列间隔
    //初始化collectionView
    UICollectionView *collectView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:layout];
    collectView.backgroundColor = [UIColor clearColor];
    _collectView = collectView;
    //设置代理
    collectView.delegate = self;
    collectView.dataSource = self;
    collectView.showsHorizontalScrollIndicator = NO;
    // 注册cell
    [collectView registerNib:[UINib nibWithNibName:BGTopSilderBarCellID bundle:nil] forCellWithReuseIdentifier:BGTopSilderBarCellID];
    //[collectView registerClass:[BGTopSilderBarCell class] forCellWithReuseIdentifier:BGTopSilderBarCellID];
    //设置水平方向滑动
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self addSubview:collectView];
    
    
    //控制器VC
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, H, SCREEN_W, SCREEN_H-H-64)];
    scrollView.contentSize = CGSizeMake(SCREEN_W*2, SCREEN_H-H-64);
    scrollView.contentOffset = CGPointMake(0, 0);
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    _scrollView = scrollView;
    [self addSubview:scrollView];
    // 监听contentOffset
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    //将控制器的视图添加到scrollView上
    for (int i=0; i<_viewsArray.count; i++)
    {
        UIView *view = _viewsArray[i];
        view.frame = CGRectMake(i*SCREEN_W, 0, SCREEN_W, SCREEN_H-H-64);
        [scrollView addSubview:view];
        
    }
    
}
/**
 从某个item移动到另一个item
 */
-(void)setItemColorFromIndex:(NSInteger)fromIndex to:(NSInteger)toIndex{
    
    [self scrollToWithIndexPath:[NSIndexPath indexPathForRow:toIndex inSection:0]];
    BGTopSilderBarCell *fromCell = (BGTopSilderBarCell*)[_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:fromIndex inSection:0]];
    BGTopSilderBarCell *toCell = (BGTopSilderBarCell*)[_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:toIndex inSection:0]];
    
    [fromCell setTitleColor:NormalColor];
    [fromCell setFontScale: NO];//反选字体保持原样
    [toCell setTitleColor:SelectedColor];
    [toCell setFontScale:YES];//选中字体放大
    _currentBarIndex = toIndex;
}

/**
 设置外部内容的UICollectionView
 */
-(void)setContentCollectionView:(UICollectionView *)contentCollectionView{
    
    //_contentCollectionView = contentCollectionView;
    // 监听contentOffset
    // [contentCollectionView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

/**
 移除监听方法有两种:
 1.重写removeFromSuperview 方法移除监听
 */
-(void)removeFromSuperview{
    // [super removeFromSuperview];
    //移除监听contentOffset
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [_scrollView removeFromSuperview];
    _scrollView = nil;
    
    
}
/**
 *  2.重写dealloc 方法移除监听
 */
-(void)dealloc
{
    //移除监听contentOffset
    //    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    //    [_scrollView removeFromSuperview];
    //    _scrollView = nil;
}
/**
 设置下划线的x轴距离
 */
-(void)setUnderlineX:(CGFloat)underlineX{
    
    _underlineX = underlineX;
    CGRect frame = _underline.frame;
    frame.origin.x = underlineX;
    _underline.frame = frame;
}
/**
 设置下划线的宽度
 */
-(void)setUnderlineWidth:(CGFloat)underlineWidth{
    
    _underlineWidth = underlineWidth;
    CGRect frame = _underline.frame;
    frame.size.width = underlineWidth;
    _underline.frame = frame;
}
#pragma -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BGTopSilderBarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BGTopSilderBarCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.row == _currentBarIndex) {
        [cell setTitleColor:SelectedColor];
        cell.BGTitleFont = BGFont(BigSize);
    }
    else{
        [cell setTitleColor:NormalColor];
        cell.BGTitleFont = BGFont(NormalSize);
    }
    cell.item = _items[indexPath.row];
    return cell;
}

/**
 设置移动位置
 */
-(void)scrollToWithIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger toRow = indexPath.row;
    
    // 点击字体和下划线改变
    //    CGSize titleSize = [global sizeWithText:_items[toRow] font:BGFont(19.5) maxSize:CGSizeMake(SCREEN_W/itemNum, MAXFLOAT)];
    //    if (toRow != _currentBarIndex) {
    //        [self setItemColorFromIndex:_currentBarIndex to:toRow];
    //        [UIView animateWithDuration:0.3 animations:^{
    //            CGFloat X = _contentCollectionView.contentOffset.x/itemNum + (SCREEN_W/itemNum - titleSize.width)*0.5;
    //            [self setUnderlineX:X];
    //            [self setUnderlineWidth:titleSize.width];
    //        }];
    //        NSLog(@"item = %d",toRow);
    //    }
    //NSLog(@"item = %ld ,_currentBarIndex = %ld",toRow ,_currentBarIndex);
    if (indexPath.row > _currentBarIndex) {
        if ((indexPath.row+2) < _items.count) {
            toRow = indexPath.row+2;
            // NSLog(@"toRow = %ld",toRow);
        }else if ((indexPath.row+1) < _items.count) {
            toRow = indexPath.row+1;
            // NSLog(@"toRow = %ld",toRow);
        }else;
        [_collectView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:toRow inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }else if (indexPath.row < _currentBarIndex){
        if ((indexPath.row-2) >= 0) {
            toRow = indexPath.row-2;
            // NSLog(@"toRow = %ld",toRow);
        }else if ((indexPath.row-1) >= 0) {
            toRow = indexPath.row-1;
            // NSLog(@"toRow = %ld",toRow);
        }else;
        [_collectView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:toRow inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }else{
        return;
    }
    
}

#pragma mark - UIScrollViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self scrollToWithIndexPath:indexPath];
    _scrollView.contentOffset = CGPointMake(SCREEN_W * indexPath.row, 0);
    //NSLog(@"section:%ld",(long)indexPath.section);
    //[_contentCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
}

#pragma mark 监听UIScrollView的contentOffset属性
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![@"contentOffset" isEqualToString:keyPath]) return;
    /**
     whichItem 是实时更新的,_scrollView.contentOffset.x为屏幕宽度的一半
     */
    int whichItem = (int)((_scrollView.contentOffset.x/_scrollView.frame.size.width)+0.5);
    NSLog(@"whichItem:%ld",(long)whichItem);
    CGSize titleSize = [MyGlobal sizeWithText:_items[whichItem] font:BGFont(BigSize) maxSize:CGSizeMake(SCREEN_W/itemNum, MAXFLOAT)];
    if (whichItem != _currentBarIndex) {
        [self setItemColorFromIndex:_currentBarIndex to:whichItem];
        [UIView animateWithDuration:0.3 animations:^{
            CGFloat X = _scrollView.contentOffset.x/itemNum + (SCREEN_W/itemNum - titleSize.width)*0.5;
            X = _scrollView.contentOffset.x/itemNum ;
            [self setUnderlineX:X];
            //[self setUnderlineWidth:titleSize.width];
            [self setUnderlineWidth:SCREEN_W/itemNum];
        }];
        //NSLog(@"item = %d",whichItem);
    }
    
    if (_scrollView.isDragging) {
        CGFloat X = _scrollView.contentOffset.x/itemNum + (SCREEN_W/itemNum - titleSize.width)*0.5;
        X = _scrollView.contentOffset.x/itemNum ;
        [self setUnderlineX:X];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            CGFloat X = _scrollView.contentOffset.x/itemNum + (SCREEN_W/itemNum - titleSize.width)*0.5;
            X = _scrollView.contentOffset.x/itemNum ;
            [self setUnderlineX:X];
        }];
    }
    _currentBarIndex = whichItem;
    // NSLog(@"x=%f , y=%f",_collectView.contentOffset.x,_collectView.contentOffset.y);
}

#pragma mark -- scrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //NSInteger index = _scrollView.contentOffset.x/_scrollView.frame.size.width;
    //NSLog(@"index_scroll:%ld",(long)index);
    
    
    //    CGSize titleSize = [global sizeWithText:_items[index] font:BGFont(19.5) maxSize:CGSizeMake(SCREEN_W/itemNum, MAXFLOAT)];
    //    if (index != _currentBarIndex)
    //    {
    //        NSLog(@"_currentBarIndex:%ld",(long)_currentBarIndex);
    //
    //        [self setItemColorFromIndex:_currentBarIndex to:index];
    //        [UIView animateWithDuration:0.3 animations:^{
    //            CGFloat X = _scrollView.contentOffset.x/itemNum + (SCREEN_W/itemNum - titleSize.width)*0.5;
    //            [self setUnderlineX:X];
    //            [self setUnderlineWidth:titleSize.width];
    //        }];
    //        //NSLog(@"item = %d",whichItem);
    //    }
    //
    //    if (_scrollView.isDragging)
    //    {
    //        CGFloat X = _scrollView.contentOffset.x/itemNum + (SCREEN_W/itemNum - titleSize.width)*0.5;
    //        [self setUnderlineX:X];
    //    }
    //    else{
    //        [UIView animateWithDuration:0.3 animations:^{
    //            CGFloat X = _scrollView.contentOffset.x/itemNum + (SCREEN_W/itemNum - titleSize.width)*0.5;
    //            [self setUnderlineX:X];
    //        }];
    //    }
    // _currentBarIndex = index;
    
    //防止加在scrollView上的视图偏移,作此处理
//    CGPoint offset = _scrollView.contentOffset;
//    if (offset.x == _scrollView.frame.size.width)
//    { //防止滑动一点点并不切换scrollview的视图
//        return;
//    }
//    else
//    {
//        _scrollView.contentOffset = CGPointMake(offset.x/SCREEN_W, 0);
//    }
}



//-(void)layoutSubViews
//{
//    self.frame = CGRectMake(0, 0, MainR.size.width, MainR.size.height-H);
//    _scrollView.frame = CGRectMake(0, H, SCREEN_W, SCREEN_H);
//    _scrollView.contentSize = CGSizeMake(SCREEN_W*2, SCREEN_H);
//    _scrollView.contentOffset = CGPointMake(_currentBarIndex*SCREEN_W, 0);
//
//    _baseVC.view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H-H);
//    _materialVC.view.frame = CGRectMake(SCREEN_W, 0, SCREEN_W, SCREEN_H-H);
//
//}


@end
