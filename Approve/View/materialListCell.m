//
//  materialListCell.m
//  XAYD
//
//  Created by songdan Ye on 16/3/30.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "materialListCell.h"

@implementation materialListCell

- (void)awakeFromNib {
    // Initialization code
}

// 项目材料
-(void)setMaterialDetailModel:(MaterialItems *)materialDetailModel
{
    _materialDetailModel = materialDetailModel;
    NSString *type = materialDetailModel.Extension;
    NSString *imageName ;
    if ([type isEqualToString:@""]) {
        imageName=@"filetype-unknow48.png";
    }else if([type isEqualToString:@"png"]||[type isEqualToString:@"PNG"]||[type isEqualToString:@"jpg"]||[type isEqualToString:@"JPG"]){
        imageName=@"pic icon";
    }else if([type isEqualToString:@"docx"] || [type isEqualToString:@"doc"]){
        imageName=@"filetype-word48.png";
    }else if([type isEqualToString:@"xlsx"] || [type isEqualToString:@"xls"]){
        imageName=@"filetype-excel48.png";
    }else if([type isEqualToString:@"pptx"] || [type isEqualToString:@"ppt"]){
        imageName=@"filetype-ppt48.png";
    }else if([type isEqualToString:@"pdf"] || [type isEqualToString:@"PDF"]){
        imageName=@"filetype-pdf48.png";
    }else if([type isEqualToString:@"zip"] || [type isEqualToString:@"ZIP"]){
        imageName=@"filetype-zip48.png";
    }else if([type isEqualToString:@"rar"] || [type isEqualToString:@"RAR"]){
        imageName=@"filetype-rar48.png";
    }else if([type isEqualToString:@"dwg"] || [type isEqualToString:@"DWG"]){
        imageName=@"filetype-dwg48.png";
    }else if([type isEqualToString:@"mp3"] || [type isEqualToString:@"MP3"]||[type isEqualToString:@"wma"] || [type isEqualToString:@"WMA"]){
        imageName=@"filetype-music48.png";
    }else if([type isEqualToString:@"mp4"] || [type isEqualToString:@"MP4"]||[type isEqualToString:@"rmvb"] || [type isEqualToString:@"RMVB"]||[type isEqualToString:@"avi"] || [type isEqualToString:@"AVI"]||[type isEqualToString:@"mov"] || [type isEqualToString:@"MOV"]||[type isEqualToString:@"mkv"] || [type isEqualToString:@"MKV"]){
        imageName=@"filetype-video48.png";
    }else{
        imageName=@"filetype-unknow48.png";
    }
    //根据材料类型加载不同的图片
    [self.fileTypeImage setImage:[UIImage imageNamed:imageName]];
    
    self.fileNameL.text = materialDetailModel.Name;
   
}

//会议材料文件
-(void)setMaterialListModel:(MaterialList *)MaterialListModel
{
    
    _MaterialListModel = (MaterialList *)MaterialListModel;
    //NSString *type = resultModel.ext;
    NSString *imageName ;
//    if ([type isEqualToString:@""]) {
//        imageName=@"filetype-folder48.png";
//    }else if([type isEqualToString:@".png"]||[type isEqualToString:@".jpg"]||[type isEqualToString:@".JPG"]){
//        imageName=@"pic icon";
//    }else if([type isEqualToString:@".docx"] || [type isEqualToString:@".doc"]){
//        imageName=@"filetype-word48.png";
//    }else if([type isEqualToString:@".xlsx"] || [type isEqualToString:@".xls"]){
//        imageName=@"filetype-excel48.png";
//    }else if([type isEqualToString:@".pptx"] || [type isEqualToString:@".ppt"]){
//        imageName=@"filetype-ppt48.png";
//    }else{
        imageName=@"filetype-unknow48.png";
//    }
    //根据材料类型加载不同的图片
    [self.fileTypeImage setImage:[UIImage imageNamed:imageName]];
    
    self.fileNameL.text = MaterialListModel.MaterialName;
}

// 附件材料 (邮件)
-(void)setAttachmentModel:(AttachmentModel *)attachmentModel
{
    _attachmentModel = attachmentModel;
    NSString *type = attachmentModel.Extension;
    NSString *imageName ;
    if ([type isEqualToString:@""]) {
        imageName=@"filetype-unkown48.png";
    }else if([type isEqualToString:@".png"]||[type isEqualToString:@"PNG"]||[type isEqualToString:@".jpg"]||[type isEqualToString:@".JPG"]){
        imageName=@"pic icon";
    }else if([type isEqualToString:@".docx"] || [type isEqualToString:@".doc"]){
        imageName=@"filetype-word48.png";
    }else if([type isEqualToString:@".xlsx"] || [type isEqualToString:@".xls"]){
        imageName=@"filetype-excel48.png";
    }else if([type isEqualToString:@".pptx"] || [type isEqualToString:@".ppt"]){
        imageName=@"filetype-ppt48.png";
    }else if([type isEqualToString:@".pdf"] || [type isEqualToString:@".PDF"]){
        imageName=@"filetype-pdf48.png";
    }else if([type isEqualToString:@".zip"] || [type isEqualToString:@".ZIP"]){
        imageName=@"filetype-zip48.png";
    }else if([type isEqualToString:@".rar"] || [type isEqualToString:@".RAR"]){
        imageName=@"filetype-rar48.png";
    }else if([type isEqualToString:@".dwg"] || [type isEqualToString:@".DWG"]){
        imageName=@"filetype-dwg48.png";
    }else if([type isEqualToString:@".mp3"] || [type isEqualToString:@".MP3"]||[type isEqualToString:@".wma"] || [type isEqualToString:@".WMA"]){
        imageName=@"filetype-music48.png";
    }else if([type isEqualToString:@".mp4"] || [type isEqualToString:@".MP4"]||[type isEqualToString:@".rmvb"] || [type isEqualToString:@".RMVB"]||[type isEqualToString:@".avi"] || [type isEqualToString:@".AVI"]||[type isEqualToString:@"mov"] || [type isEqualToString:@".MOV"]||[type isEqualToString:@".mkv"] || [type isEqualToString:@".MKV"]){
        imageName=@"filetype-video48.png";
    }else{
        imageName=@"filetype-unknow48.png";
    }
    //根据材料类型加载不同的图片
    [self.fileTypeImage setImage:[UIImage imageNamed:imageName]];
    
    self.fileNameL.text = attachmentModel.Name;
}


-(void)setCyQHismodel:(CQhistoryModel *)cyQHismodel
{    
    [self.fileTypeImage setImage:[UIImage imageNamed:@"阅读量"]];
    
    self.fileTypeImage.frame = CGRectMake(38, 10, 20, 10);
    self.fileNameL.text = cyQHismodel.historydiscrption;
    
}


+ (instancetype)cellWithTableView:(UITableView *)tableView
{

    NSString *materialId = @"materialCellId";
    
    materialListCell *cell = [tableView dequeueReusableCellWithIdentifier:materialId];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"materialListCell" owner:nil options:nil] lastObject];
        
    }
    
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
