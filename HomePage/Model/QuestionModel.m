//
//  QuestionModel.m
//  WZYD
//
//  Created by 吴定如 on 16/12/13.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "QuestionModel.h"

@implementation QuestionModel

-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [self init])
    {
        for (NSString *key in dic)
        {
            [self setValue:dic[key] forKey:key];
            self.replyList = [NSMutableArray array];
            NSArray *replyList = [dic objectForKey:@"replyList"];
            for (NSDictionary *dic in replyList)
            {
                ReplyListModel *model = [[ReplyListModel alloc] initWithDictionary:dic];
                [self.replyList addObject:model];
            }
        }
    }
    return self;
}

@end

@implementation ReplyListModel

-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [self init])
    {
        for (NSString *key in dic)
        {
            [self setValue:dic[key] forKey:key];
        }
    }
    return self;
}

@end
