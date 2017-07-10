//
//  MaterialModel.m
//  XAYD
//
//  Created by songdan Ye on 16/3/15.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "MaterialModel.h"
#import "MaterialItems.h"
/*
 
 {
 "group": "相关材料",
 "instanceid": "590",
 "groupid": "2991",
 "files": [
 {
 "name": "箭头.png",
 "ext": ".png",
 "identity": "369"
 }
 ]
 }
 
 */

@implementation MaterialModel
- (instancetype)initWithDict:(NSDictionary *)dict
{
//    if (self=[super init]) {
//        self.group = [dict objectForKey:@"group"];
//        self.groupid = [dict objectForKey:@"groupid"];
//        self.instanceid = [dict objectForKey:@"instanceid"];
////        NSArray *tempArray = [NSArray array];
////        tempArray= [dict objectForKey:@"items"];
////        NSMutableArray *array =[NSMutableArray array];
////        for (NSDictionary *dict in tempArray) {
////            PTreeItems *itemModel = [PTreeItems itemsWithDict:dict];
////            [array addObject:itemModel];
////        }
////        self.items = array;
////        self.files  =
//        NSMutableArray *mulA=[NSMutableArray array];
//        for (NSDictionary *detailDict in [dict objectForKey:@"files"]) {
//         MaterialItems *mDModel=[MaterialItems materialDetailWithDict:detailDict];
//            [mulA addObject:mDModel];
//        }
//        self.files = [mulA copy];
//        
//    }
//    return self;
    self = [super init];
    if (self) {
        for (NSString *key in dict) {
            //NSLog(@"key:::%@",key);
            [self setValue:dict[key] forKey:key];
        }
    }
    return self;

    
}

+(instancetype)materialWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
    
}

@end



