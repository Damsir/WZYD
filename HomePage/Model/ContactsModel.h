//
//  ContactsModel.h
//  WZYD
//
//  Created by 吴定如 on 16/12/22.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactsModel : NSObject

@property (nonatomic, copy) NSString *org; /**< 部门 */
@property (nonatomic, strong) NSMutableArray *users; /**< 人员数组 */

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end

@interface ChildrenModel : NSObject

@property (nonatomic, copy) NSString *name; /**< 姓名 */
@property (nonatomic, copy) NSString *dh; /**< 短号 */
@property (nonatomic, copy) NSString *ch; /**< 手机 */

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
