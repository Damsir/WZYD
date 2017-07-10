//
//  MailContactModel.h
//  WZYD
//
//  Created by 吴定如 on 16/11/3.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MailContactModel : NSObject

@property (nonatomic, copy) NSString *bmName;
@property (nonatomic,strong) NSMutableArray *users;

@property (nonatomic, assign, getter = isOpened) BOOL opened;
@property (nonatomic, assign, getter = isSelected) BOOL selected;

-(instancetype)initWithDictionary:(NSDictionary *)dic;

@end

@interface UsersModel : NSObject

@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *name;

@property (nonatomic,assign,getter = isSelected ) BOOL selected;


-(instancetype)initWithDictionary:(NSDictionary *)dic;

@end