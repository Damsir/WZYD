//
//  MaterialModel.h
//  XAYD
//
//  Created by songdan Ye on 16/3/15.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 {
 "group": "申请表（原件）",
 "instanceid": "623",
 "groupid": "3125",
 "files": [
 {
 "name": "箭头.png",
 "ext": ".png",
 "identity": "369"
 }
 ]
 },
 
 
 */
@interface MaterialModel : NSObject

@property (nonatomic, copy) NSString *Extension;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *Path;
@property (nonatomic, copy) NSString *Id;


//@property (nonatomic,strong) NSString *group;
//@property (nonatomic,strong) NSString *groupid;
//@property (nonatomic,strong) NSString *instanceid;
//
//@property (nonatomic,strong) NSArray *files;
@property (nonatomic, assign, getter = isOpened) BOOL opened;


- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)materialWithDict:(NSDictionary *)dict;

@end


