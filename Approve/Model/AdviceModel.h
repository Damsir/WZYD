//
//  AdviceModel.h
//  HAYD
//
//  Created by 吴定如 on 16/9/5.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdviceModel : NSObject

@property(nonatomic,copy) NSString *success;
@property(nonatomic,copy) NSArray *result;



@end

@interface AdviceResult : NSObject

@property(nonatomic,copy) NSString *name;//有关部门
@property(nonatomic,copy) NSString *suggestion;//意见
@property(nonatomic,copy) NSString *pictureUrl;//签字图片

@end

