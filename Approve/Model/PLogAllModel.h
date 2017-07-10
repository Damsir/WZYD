//
//  PLogAllModel.h
//  XAYD
//
//  Created by songdan Ye on 16/3/29.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PLogModel;
@interface PLogAllModel : NSObject
@property (nonatomic,strong) NSArray *log;
@property (nonatomic,strong) NSString *date;
//是否打开
@property (nonatomic, assign, getter = isOpened) BOOL opened;
- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)pLogAllWithDict:(NSDictionary *)dict;



@end
