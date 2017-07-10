//
//  BGTopSilderBarCell.m
//  topSilderBar
//
//  Created by dingru Wu on 16/7/7.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "BGTopSilderBarCell.h"
#import "MyGlobal.h"

@interface BGTopSilderBarCell()

@property (weak, nonatomic) IBOutlet UILabel *BGTitle;
@property(nonatomic,strong) UILabel *itemLabel;

@end

@implementation BGTopSilderBarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createCollectionView];
        
    }
    return self;
}

-(void)createCollectionView
{
    UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    itemLabel.backgroundColor = [UIColor whiteColor];
    itemLabel.textAlignment = NSTextAlignmentCenter;
    _itemLabel = itemLabel;
    //[self addSubview:itemLabel];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setItem:(NSString *)item{
    
    _item = item;
    _BGTitle.text = item;
   // _itemLabel.text = item;
}

-(void)setTitleColor:(UIColor *)color{
    
    _BGTitle.textColor = color;
}

-(void)setBGTitleFont:(UIFont *)BGTitleFont{
    
    _BGTitleFont = BGTitleFont;
    _BGTitle.font = BGTitleFont;
}

-(void)setFontScale:(BOOL)scale{
    
    if (scale) {
        // 1.3 = bigSize / normalSize
        [UIView animateWithDuration:0.3 animations:^{
            CGAffineTransform trans = CGAffineTransformScale(_BGTitle.transform,BigSize/NormalSize,BigSize/NormalSize);
            [_BGTitle setTransform:trans];
        } completion:^(BOOL finished) {
            [_BGTitle setTransform:CGAffineTransformIdentity];
            _BGTitle.font = BGFont(BigSize);
        }];
    }else{
        // 0.7692 = normalSize / bigSize
        [UIView animateWithDuration:0.3 animations:^{
            CGAffineTransform trans = CGAffineTransformScale(_BGTitle.transform,NormalSize/BigSize,NormalSize/BigSize);
            [_BGTitle setTransform:trans];
        } completion:^(BOOL finished) {
            [_BGTitle setTransform:CGAffineTransformIdentity];
            _BGTitle.font = BGFont(NormalSize);
        }];
    }
}

@end
