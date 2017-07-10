
//
//  SHImformationDetailViewController.m
//  distmeeting
//
//  Created by songdan Ye on 15/12/3.
//  Copyright © 2015年 dist. All rights reserved.
//

#import "SHImformationDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD+MJ.h"
#import "Global.h"
#import "UIImage+SimpleImage.h"
#import "MyRequestManager.h"



@interface SHImformationDetailViewController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UINavigationControllerDelegate>
//头像
@property(nonatomic,weak)UIButton *portrait;
//弹出背景图
@property(nonatomic,weak) UIView *detailView;
//选中图片
@property (nonatomic,strong)UIImage *img;
//头像
@property (nonatomic,strong)UIImageView *portaitI;
@property(nonatomic,strong) UIImagePickerController *imgPC;
@property(nonatomic,strong) NSURL *url;
@property(nonatomic,strong) UIImage *image;

@end

@implementation SHImformationDetailViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
    [self LoadImage];

//    //设置返回按钮的颜色
//    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    //self.navigationItem.title = @"个人资料";
    [self initNavigationBarTitle:@"个人资料"];
    
    self.view.backgroundColor =[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
    
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoadImage) name:@"portaitChange"object:nil];
    
//    [self setChildView1];
//    [self setChildView2];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeImformation) name:UIDeviceOrientationDidChangeNotification object:nil];
}
//屏幕旋转结束执行的方法
- (void)changeImformation
{
    self.infromationTableView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [self.infromationTableView reloadData];
}

- (void)createTableView
{
    UITableView *tabLeMore = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    tabLeMore.separatorStyle =UITableViewCellSeparatorStyleNone;
    tabLeMore.backgroundColor = [UIColor whiteColor];
    _infromationTableView = tabLeMore;
    _infromationTableView.delegate =self;
    _infromationTableView.dataSource= self;
    _infromationTableView.backgroundColor =[UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:243.0/255.0];
    [self.view addSubview:_infromationTableView];
    
    _infromationTableView.bounces = NO;

}

#pragma mark --- UITableViewDataSource,UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }

    if (indexPath.section==0) {
        
        for (UIView *view in cell.contentView.subviews) {
                        [view removeFromSuperview];
                    }
        UILabel *title =[[UILabel alloc] initWithFrame:CGRectMake(20, 40, 40, 20)];
        [title setText:@"头像"];
        [title setTextAlignment:NSTextAlignmentCenter];
        [title setTextColor: [UIColor blackColor]];
        title.font =[UIFont systemFontOfSize:18];
        [cell.contentView addSubview:title];
        UIImageView *portaitI=[[UIImageView alloc] initWithFrame:CGRectMake(MainR.size.width-80, 20, 60, 60)];
        portaitI.userInteractionEnabled = NO;
        
        _portaitI = portaitI;
        
       // [[SDWebImageManager sharedManager].imageCache clearDisk];

        //将图片设置为圆形的
        portaitI.layer.borderWidth = 0.5;
        portaitI.layer.borderColor = GRAYCOLOR_MIDDLE.CGColor;
        portaitI.layer.cornerRadius = 5;
        portaitI.layer.masksToBounds = YES;

        [_portaitI setImageWithURL:_url placeholderImage:[UIImage imageNamed:@"icon"]];
        
            
        UIView *lineView =[[UIView alloc] initWithFrame:CGRectMake(0, 99, MainR.size.width, 1)];
        lineView.backgroundColor =RGB(238.0, 238.0, 238.0);

        [cell.contentView addSubview:portaitI];
        [cell.contentView addSubview:lineView];

        }else if(indexPath.section==1){
            //设置cell的选中样式
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //cell左侧label
            UILabel *leftLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 9, 100, 30)];
            leftLabel.font=[UIFont systemFontOfSize:16];
            leftLabel.textColor=[UIColor blackColor];
            //cell 右侧label
            UILabel *rightLabel=[[UILabel alloc]initWithFrame:CGRectMake(MainR.size.width-200, 9, 180, 30)];
            rightLabel.font=[UIFont systemFontOfSize:15];
            rightLabel.textColor=[UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
            rightLabel.textAlignment = NSTextAlignmentRight;
            
            UIView *lineView =[[UIView alloc] initWithFrame:CGRectMake(0, 49, MainR.size.width, 1)];
            lineView.backgroundColor =RGB(238.0, 238.0, 238.0);
            
            [cell.contentView addSubview:leftLabel];
            [cell.contentView addSubview:rightLabel];
            [cell.contentView addSubview:lineView];
            
            
            
        if (indexPath.row==0) {
            [leftLabel setText:@"名称"];
            [rightLabel setText:[[Global userInfo] objectForKey:@"name"]];
            
        }
        else if (indexPath.row==1){
            
            [leftLabel setText:@"单位"];
            [rightLabel setText:[[Global userInfo] objectForKey:@"org"]];
            
            
        }
        else if (indexPath.row==2){
            [leftLabel setText:@"岗位"];
            [rightLabel setText:@"无信息"];
        }
        else if (indexPath.row==3){

            [leftLabel setText:@"科室"];
            [rightLabel setText:@"信息中心"];

            
        }

        
        
    }
    
    cell.contentView.backgroundColor =[UIColor colorWithRed:253.0/255.0 green:253.0/255.0 blue:253.0/255.0 alpha:1];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==1){
        return 4;
    }
    else
        return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 0.1;
            break;
        case 1:
            return 10;
            break;
            
        default:
            break;
    }
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 100;
    }
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    self.navigationController.navigationBar.tintColor =[UIColor blackColor];
    
    if (indexPath.section==0) {
        
        [self photos];
    }
    else if (indexPath.section==1) {
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//监听到头像改变时调用
-(void)LoadImage
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *parameters = @{@"type":@"smartplan",@"action":@"getUserPic",@"userId":[Global userId]};
    
    [manager POST:[Global serverAddress] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *rs = (NSDictionary *)responseObject;
        if ([[rs objectForKey:@"success"] isEqualToString:@"true"]) {
            _url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?r=%ld",[rs objectForKey:@"result"],random()/10]];
            
            [_portaitI setImageWithURL:_url placeholderImage:[UIImage imageNamed:@"icon"]];
            
        }
        else
        {
            [_portaitI setImage:[UIImage imageNamed:@"profile"]];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_portaitI setImage:[UIImage imageNamed:@"icon"]];
    
        [_infromationTableView reloadData];
    }];
}


- (void)setUpLabelWithName:(UILabel *)label frame:(CGRect )frame title:(NSString *)title
{
    label.frame=frame;
    [label setText:title];
    label.font =[UIFont systemFontOfSize:17];
    [label setTextColor:[UIColor blackColor]];
    
    [self.detailView addSubview:label];
}


- (void)photos
{
    //"头像被点击";
    [self choseImg];

}

#pragma mark 选择图片
-(void)choseImg{
    
    // 图片选择器
    UIImagePickerController *imgPC = [[UIImagePickerController alloc] init];
    _imgPC = imgPC;
    //设置代理
    imgPC.delegate = self;
    //允许编辑图片
    imgPC.allowsEditing = YES;

    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册中选取", nil];
    sheet.delegate = self;
   // [sheet showInView:self.view];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请选择" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册中选取", nil];
    alert.delegate = self;
    [alert show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {//拍照
        _imgPC.sourceType =  UIImagePickerControllerSourceTypeCamera;
    }else if (buttonIndex == 2){//相册中选取
        _imgPC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else
    {
        return;
    }
    [self.view.window.rootViewController presentViewController:_imgPC animated:YES completion:nil];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {//拍照
        _imgPC.sourceType =  UIImagePickerControllerSourceTypeCamera;
    }else{//相册中选取
        _imgPC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
//    imgPC.navigationBar.appearance
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    
    //显示控制器
    [self.view.window.rootViewController presentViewController:_imgPC animated:YES completion:nil];
}


#pragma mark 图片选择器的代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    
    UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    _img = image;
    //关闭相册界面
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    [self uploadOne];
    
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [picker dismissViewControllerAnimated:YES completion:nil];
    

}

- (void) uploadOne
{

   UIImage *newImage=[UIImage imageWithImageSimple:_img scaledToSize:CGSizeMake(200, 200)];
    
    // 创建一个参数字典
    NSDictionary *params = @{@"type":@"smartplan",@"action":@"uploadUserPic",@"userId":[Global userId]};
    

//    NSString *urllll = @"http://192.168.2.221/server/ServiceProvider.ashx";
//    urllll = @"http://192.168.2.239/HAYDService/ServiceProvider.ashx";
    //urllll = @"http://112.1.17.7:9000/WebApp/ServiceProvider.ashx";

    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObject:@"application/json"];
    NSMutableString *requestAddress = [NSMutableString stringWithString:[Global serviceUrl]];
    [requestAddress appendString:@"?"];
    
    if (nil!=params) {
        for (NSString *key in params.keyEnumerator) {
            NSString *val = [params objectForKey:key];
            [requestAddress appendFormat:@"&%@=%@",key,val];
        }
    }
    
    NSLog(@"上传头像%@",requestAddress);
    
    [manager POST:[Global serviceUrl] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
        [formData appendPartWithFileData:UIImagePNGRepresentation(newImage) name:@"image"fileName:@"image.png"mimeType:@"image/png"];

        
    }success:^(AFHTTPRequestOperation *operation,id responseObject) {
        
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers |NSJSONReadingMutableLeaves error:nil];
        
        [MBProgressHUD showSuccess:@"头像上传成功"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"portaitChange" object:nil];
        
    }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        
//        [self LoadImage];
//        [_infromationTableView reloadData];

        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"portaitChange" object:nil];
//

    }];
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
