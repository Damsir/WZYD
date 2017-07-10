//
//  CYQYModel.h
//  XAYD
//
//  Created by songdan Ye on 16/5/24.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYQYModel : NSObject
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *bh;
@property (nonatomic,strong) NSString *type;

@property (nonatomic ,strong) NSString *cyId;
@property (nonatomic ,strong) NSString *time;
@property (nonatomic ,strong) NSString *itemid;


//作为sourchId
@property (nonatomic ,strong) NSString *owner;

- (instancetype) initWithDict:(NSDictionary *)dict;
+(instancetype) CYQYModelWithDict:(NSDictionary *)dict;
- (NSDictionary *)dictionaryGWCQ;
+ (NSDictionary *)dictionaryGWCQ:(CYQYModel *)model;

@end
