//
//  BaseInfoModel.h
//  WZYD
//
//  Created by 吴定如 on 16/10/21.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseInfoModel : NSObject

// 项目办理
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *x;
@property (nonatomic, copy) NSString *y;
@property (nonatomic, copy) NSString *width;
@property (nonatomic, copy) NSString *field;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *extensionType;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *table;
@property (nonatomic, copy) NSString *height;
@property (nonatomic, copy) NSString *readonly;
@property (nonatomic, copy) NSString *name;

// 项目查询
@property (nonatomic, copy) NSString *relationControl;
//@property (nonatomic, copy) NSString *Id;
//@property (nonatomic, copy) NSString *x;
//@property (nonatomic, copy) NSString *y;
//@property (nonatomic, copy) NSString *width;
//@property (nonatomic, copy) NSString *field;
//@property (nonatomic, copy) NSString *value;
//@property (nonatomic, copy) NSString *extensionType;
//@property (nonatomic, copy) NSString *text;
//@property (nonatomic, copy) NSString *table;
//@property (nonatomic, copy) NSString *height;
//@property (nonatomic, copy) NSString *readonly;
//@property (nonatomic, copy) NSString *name;

- (instancetype)initWithDictionary:(NSDictionary *)dic;


@end
