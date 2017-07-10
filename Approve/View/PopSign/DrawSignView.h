//
//  DrawSignView.h
//  popSign
//
//  Created by 吴定如 on 16/7/25.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyView.h"

typedef void(^SignCallBackBlock) (UIImage *);
typedef void(^CallBackBlock) ();

@interface DrawSignView : UIView


@property(nonatomic,copy)SignCallBackBlock signCallBackBlock;
@property(nonatomic,copy)CallBackBlock cancelBlock;

-(void)screenRotationChangeFrame;

@end
