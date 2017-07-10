//
//  QueryModel.h
//  WZYD
//
//  Created by 吴定如 on 16/10/24.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QueryModel : NSObject

/*{
 "groupName": "业务1",
 "child": [
 {
 "id": "201",
 "bizzName": "建设项目选址意见书",
 "groupName": "业务1"
 }]
 }
 */

@property (nonatomic, copy) NSString *groupName;
@property (nonatomic,strong) NSMutableArray *child;

-(instancetype)initWithDictionary:(NSDictionary *)dic;

@end

@interface ChildModel : NSObject

@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, copy) NSString *bizzName;

-(instancetype)initWithDictionary:(NSDictionary *)dic;

@end

