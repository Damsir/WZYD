//
//  PLogModel.m
//  XAYD
//
//  Created by songdan Ye on 16/3/14.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "PLogModel.h"

@implementation PLogModel

//@property (nonatomic,strong) NSString *logId;
//@property (nonatomic,strong) NSString *startTime;
//@property (nonatomic,strong) NSString *endTime;
//@property (nonatomic,strong) NSString *logName;
//@property (nonatomic,strong) NSString *userName;
//@property (nonatomic,strong) NSString *type;
//@property (nonatomic,strong) NSString *remark;



- (instancetype)initWithDict:(NSDictionary *)dict
{
//    if (self=[super init]) {
//        self.logId = [dict objectForKey:@"Id"];
//        self.startTime = [dict objectForKey:@"StartTime"];
//        self.endTime =[dict objectForKey:@"EndTime"];
//        self.logName =[dict objectForKey:@"LogName"];
//        self.userName =[dict objectForKey:@"UserName"];
//        self.type =[dict objectForKey:@"Type"];
//        self.remark =[dict objectForKey:@"Remark"];
//    }
//    return self;
    if (self = [super init])
    {
        for (NSString *key in dict)
        {
            [self setValue:dict[key] forKey:key];
        }
    }
    
    return self;
    
}

+(instancetype)plogWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
    
    
}






@end
