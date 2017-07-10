//
//  MyView.h
//  popSign
//
//  Created by 吴定如 on 16/7/25.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MyView : UIView

// get point  in view
-(void)addPA:(CGPoint)nPoint;
-(void)addLA;
-(void)revocation;
-(void)refrom;
-(void)clear;
-(void)setLineColor:(NSInteger)color;
-(void)setlineWidth:(NSInteger)width;

@end
