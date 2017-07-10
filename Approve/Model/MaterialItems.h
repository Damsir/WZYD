//
//  MaterialItems.h
//  XAYD
//
//  Created by songdan Ye on 16/4/21.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MaterialItems : NSObject

//@property (nonatomic,strong) NSString *name;
//@property (nonatomic,strong) NSString *ext;
//@property (nonatomic,strong) NSString *identity;
@property (nonatomic, copy) NSString *Extension;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *Path;
@property (nonatomic, copy) NSString *Id;

- (instancetype)initDetailWithDict:(NSDictionary *)dict;

+ (instancetype)materialDetailWithDict:(NSDictionary *)dict;

@end
