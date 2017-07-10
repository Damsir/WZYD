//
//  PTreeItems.h
//  XAYD
//
//  Created by songdan Ye on 16/3/15.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTreeItems : NSObject

//@property (nonatomic,strong)NSString *name;
//@property (nonatomic,assign)int lever;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *projectNo;
@property (nonatomic, copy) NSString *projectCaseNo;
@property (nonatomic, copy) NSString *name;


- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)itemsWithDict:(NSDictionary *)dict;

@end
