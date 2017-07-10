//
//  matterModel.h
//  XAYD
//
//  Created by songdan Ye on 16/3/1.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface matterModel : NSObject

@property (nonatomic,copy)NSString *maintitle;

@property (nonatomic,copy)NSString *publishtime;
@property (nonatomic,copy)NSString *content;

- (instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)matterWithDict:(NSDictionary *)dict;



@end
