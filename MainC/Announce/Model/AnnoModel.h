//
//  AnnoModel.h
//  XAYD
//
//  Created by songdan Ye on 16/2/29.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnnoModel : NSObject
@property (nonatomic,copy) NSString *mainTitle;
//@property (nonatomic,copy) NSString *image;
@property(nonatomic,strong)NSString *showurl;
@property(nonatomic,strong)NSString *publishTime;
//@property (nonatomic,copy) NSString *typename;
//@property (nonatomic,copy)NSString *extension;
//@property (nonatomic,copy)NSString *name;
@property (nonatomic,strong)NSString *content;

@property (nonatomic,strong) NSString *comeFrom;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)annoModelWithDict:(NSDictionary *)dict;

@end
