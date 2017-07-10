//
//  SHSiteModel.h
//  distmeeting
//
//  Created by songdan Ye on 15/10/29.
//  Copyright (c) 2015年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHSiteModel : NSObject

/*
 {
 "id": "1",
 "name": "一楼会议室",
 "note": "1"
 }
 */

@property (nonatomic,strong) NSString *siteId;
@property (nonatomic ,strong) NSString *name;

- (instancetype) initWithDict:(NSDictionary *)dict;
+(instancetype) siteModelWithDict:(NSDictionary *)dict;

@end
