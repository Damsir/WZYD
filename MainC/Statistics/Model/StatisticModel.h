//
//  StatisticModel.h
//  HAYD
//
//  Created by 叶松丹 on 16/8/30.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatisticModel : NSObject
@property (nonatomic,strong)NSString *month;
@property (nonatomic,strong)NSString *sjCount;
@property (nonatomic,strong)NSString *fjCount;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)StaticModelWithDict:(NSDictionary *)dict;
@end
