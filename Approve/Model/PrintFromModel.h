//
//  PrintFromModel.h
//  XAYD
//
//  Created by songdan Ye on 16/3/15.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 
 {
 "identity": "550",
 "project": "12680",
 "busiFormId": "250",
 "name": "义乌市《建设项目选址意见书》申请表"
 },
 
 
 */
@interface PrintFromModel : NSObject
@property (nonatomic,strong) NSString *identity;
@property (nonatomic,strong) NSString *project;
@property (nonatomic,strong) NSString *busiFormId;
@property (nonatomic,strong) NSString *name;

//@property (nonatomic, assign, getter = isOpened) BOOL opened;


- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)printFromWithDict:(NSDictionary *)dict;

- (NSDictionary *)dictionary;


+ (NSDictionary *)dictionaryWithprintModel:(PrintFromModel *)model;





@end
