//
//  ViewController.m
//  MKTreeTest
//
//  Created by 张平 on 15/12/24.
//  Copyright © 2015年 zhangping. All rights reserved.
//

#import "MKPeopleCellModel.h"

#define MKNAME      @"activityName"
#define MKNODE      @"node"

static MKPeopleCellModel  *_sharedPepple;

@implementation MKPeopleCellModel


+ (MKPeopleCellModel *)sharedPeople
{
    if (!_sharedPepple)
    {
        @synchronized (self)
        {
            if (!_sharedPepple)
            {
                _sharedPepple = [[MKPeopleCellModel alloc] init];
            }
        }
    }
    return _sharedPepple;
}

+ (MKPeopleCellModel *)uploadUser
{
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"people"];
    MKPeopleCellModel *people = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    if (!people)
    {
        people = [[MKPeopleCellModel alloc] init];
    }
    return people;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"])
    {
        self.messageId = [value integerValue];
    }
    else
    {
        NSLog(@"undefine key: %@,  value: %@", key, value);
    }
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
}

- (void)updateWithDictionary:(NSDictionary *)dict
{
    [self setValuesForKeysWithDictionary:dict];
}

- (void)savePeoples
{
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:self];
    [[NSUserDefaults standardUserDefaults] setObject:userData forKey:@"people"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)clear
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"people"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _sharedPepple = [[MKPeopleCellModel alloc] init];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.activityName  = [aDecoder decodeObjectForKey:MKNAME];
        self.node  = [aDecoder decodeObjectForKey:MKNODE];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.activityName forKey:MKNAME];
    [aCoder encodeObject:self.node forKey:MKNODE];
}

- (id)initWithName:(NSString *)name people:(NSArray *)people
{
    self = [super init];
    if (self) {
        self.peoples = people;
        self.activityName = name;
    }
    return self;
}

+ (id)dataObjectWithName:(NSString *)name children:(NSArray *)peoples
{
    return [[self alloc] initWithName:name people:peoples];
}

//
- (id)initWithActivityName:(NSString *)activityName activityID:(NSString *)activityID userName:(NSString *)userName userId:(NSString *)userId  type:(NSString *)type people:(NSArray *)people
{
    self = [super init];
    if (self) {
        self.peoples = people;
        self.activityID = activityID;
        self.type = type;
        self.activityName = activityName;
        self.userName = userName;
        self.userId = userId;
    }
    return self;
}

+ (id)dataObjectWithActivityName:(NSString *)activityName activityID:(NSString *)activityID userName:(NSString *)userName userId:(NSString *)userId type:(NSString *)type children:(NSArray *)peoples
{
    return [[self alloc] initWithActivityName:activityName activityID:activityID userName:userName userId:userId type:type people:peoples];
}

+ (id)dataObjectWithMobile:(NSString *)mobile children:(NSArray *)peoples
{
    return [[self alloc] initWithName:mobile people:peoples];
}
@end
