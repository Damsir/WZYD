//
//  CQhistoryModel.h
//  XAYD
//
//  Created by songdan Ye on 16/5/24.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CQhistoryModel : NSObject
@property (nonatomic ,strong) NSString *cqId;
//作为sourchId
@property (nonatomic ,strong) NSString *historydiscrption;

- (instancetype) initWithDict:(NSDictionary *)dict;
+(instancetype) CQHisModelWithDict:(NSDictionary *)dict;
@end
