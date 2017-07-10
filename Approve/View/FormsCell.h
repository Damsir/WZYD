//
//  FormsCell.h
//  XAYD
//
//  Created by songdan Ye on 16/3/30.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrintFromModel.h"

@interface FormsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifie
;
//保存当前cell显示数据
@property (nonatomic,strong)  PrintFromModel *printModel;


+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
