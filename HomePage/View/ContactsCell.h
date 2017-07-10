//
//  ContactsCell.h
//  WZYD
//
//  Created by 吴定如 on 16/12/22.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name; /**< 姓名 */
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber; /**< 电话 */
@property (weak, nonatomic) IBOutlet UILabel *cornet; /**< 短号 */

@end
