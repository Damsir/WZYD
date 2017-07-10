//
//  materialListCell.h
//  XAYD
//
//  Created by songdan Ye on 16/3/30.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MaterialItems.h"
#import "CQhistoryModel.h"
#import "MeetingMaterialModel.h"
#import "AttachmentModel.h"

@interface materialListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *fileTypeImage;
@property (weak, nonatomic) IBOutlet UILabel *fileNameL;

@property (nonatomic,strong) MaterialItems *materialDetailModel;
@property (nonatomic,strong) CQhistoryModel *cyQHismodel;
@property (nonatomic,strong) MaterialList *MaterialListModel;
@property (nonatomic,strong) AttachmentModel *attachmentModel;


@property (weak, nonatomic) IBOutlet UIImageView *linImage;


+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
