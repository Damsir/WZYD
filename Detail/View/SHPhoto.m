//
//  SHPhoto.m
//  distmeeting
//
//  Created by songdan Ye on 15/12/7.
//  Copyright © 2015年 dist. All rights reserved.
//

#import "SHPhoto.h"


@implementation SHPhoto


-(NSMutableArray *)imageArray
{
    if (_imageArray ==nil) {
        _imageArray =[NSMutableArray array];
    }
    return _imageArray;
}


- (void)setImage:(UIImage *)image
{
    _image = image;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = image;
    imageView.backgroundColor =[UIColor blueColor];
    [_imageArray addObject:imageView];
    
    [self addSubview:imageView];

}
//
- (void)setNameS:(NSString *)nameS
{
    
    _nameS = nameS;
    
    UILabel *namel =[[UILabel alloc] init];
    [namel setText:nameS];

    [_nameArray addObject:namel];
    [self addSubview:namel];


}


// 每添加一个子控件的时候也会调用，特殊如果在viewDidLoad添加子控件，就不会调用layoutSubviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    NSInteger cols = 3;
    CGFloat marign = 10.0;
    CGFloat wh = (SCREEN_WIDTH - (cols - 1) * marign-20) / cols;
    
    CGFloat x = 0;
    CGFloat y = 0;
    NSInteger col = 0;
    NSInteger row = 0;
    
  
    if (self.imageArray.count >= 1) {
        for (int i = 0; i < self.imageArray.count; i++) {
            UIImageView *imageV = self.imageArray[i];
            //            UILabel *nameL=self.nameArray[i];
            col = i % cols;
            row = i / cols;
            x = col * (marign + wh)+10;
            y = row * (marign + wh)+10;
            imageV.frame = CGRectMake(x, y, wh, wh);
                   imageV.userInteractionEnabled = YES;
            //设置tag
            imageV.tag = i;
            
            // 添加点按手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
            [imageV addGestureRecognizer:tap];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"imageSelectedd" object:nil];
            
        }
    }
}

#pragma mark - 点击图片的时候调用
- (void )tap:(UITapGestureRecognizer *)tap
{
    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[NSDictionary dictionary];
    dict= @{@"tag":[NSString stringWithFormat:@"%ld",tap.view.tag]};
    //创建通知,发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"imageDidTap" object:nil userInfo:dict];

}

@end
