//
//  MicroblogModel.h
//  WZYD
//
//  Created by 吴定如 on 16/11/10.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MicroblogModel : NSObject

/*
 {
 "id": "3826",
 "userId": "85",
 "newssetdate": "2016年03月14日 08:56",
 "newscontent": "<span>作风起，工作启。点赞徐书记“公职工作当事业追求，实现人生价值”的导向，点赞规划局“每月一主题，每月一简报”的作风工作抓手。</span><span onclick=\\"showReply(this,3826);\\" style=\\"color:#915833;cursor:pointer; margin-left:20px;\\">回复</span>",
 "username": "张金夫",
 "pageCount": "111"
 }
 */

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *newssetdate;
@property (nonatomic, copy) NSString *newscontent;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *pageCount;



-(instancetype)initWithDictionary:(NSDictionary *)dic;

@end
