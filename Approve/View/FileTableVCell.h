//
//  FileTableVCell.h
//  分层
//
//  Created by songdan Ye on 16/1/14.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTreeItems.h"
#import "PrintFromModel.h"

@interface FileTableVCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;

//@property (strong, nonatomic) UILabel *name;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifie
    ;
//保存当前cell显示数据
@property (nonatomic,strong)  PTreeItems *itemModel;
@property (nonatomic,strong)  PrintFromModel *printModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
