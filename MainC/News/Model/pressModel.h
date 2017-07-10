//
//  pressModel.h
//  XAYD
//
//  Created by songdan Ye on 16/2/17.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>


 
@interface pressModel : NSObject



@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *date;
@property (nonatomic,strong)NSString *showurl;




- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)pressModelWithDict:(NSDictionary *)dict;

@end
