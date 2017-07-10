//
//  FileTableVCell.h
//  分层
//
//  Created by 叶松丹 on 16/1/14.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileTableCell : UITableViewCell
@property (strong, nonatomic)  UIImageView *jiantou;
@property (strong, nonatomic)  UIImageView *fileImage;
@property (strong, nonatomic)  UIImageView *line;

@property (strong, nonatomic) UILabel *name;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifie
    ;
//保存当前cell显示数据
//@property (nonatomic,retain)  *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;





@end
