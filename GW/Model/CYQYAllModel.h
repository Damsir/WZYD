//
//  CYQYAllModel.h
//  XAYD
//
//  Created by songdan Ye on 16/5/24.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYQYAllModel : NSObject
@property (nonatomic,strong) NSString *historydiscrption;
@property (nonatomic,strong) NSString *remark;

//@property (nonatomic,assign)int lever;

@property (nonatomic,strong) NSArray *files;
@property (nonatomic, assign, getter = isOpened) BOOL opened;


- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)AllCQWithDict:(NSDictionary *)dict;

@end
