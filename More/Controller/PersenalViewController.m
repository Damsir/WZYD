//
//  PersenalViewController.m
//  XAYD
//
//  Created by dist on 15/8/4.
//  Copyright (c) 2015年 dist. All rights reserved.
//

#import "PersenalViewController.h"
#import "GesturesUnLock.h"
#import "Global.h"
//#import "NewEmailViewController.h"
@interface PersenalViewController ()

@end

@implementation PersenalViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_tableViewPersonal setFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height)];
    
    [self.tabBarController.tabBar setFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
    
    self.navigationController.navigationBarHidden=NO;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableViewPersonal setFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height)];
    float width=SCREEN_SIZE.width-15;
    NSLog(@"%f",width);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePerson) name:UIDeviceOrientationDidChangeNotification object:nil];
}
//屏幕旋转结束执行的方法
- (void)changePerson
{
    self.tableViewPersonal.frame=CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [self.tableViewPersonal reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --- UITableViewDataSource,UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    //cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if (indexPath.section==0) {
        UIImageView *imageview1=[[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 70, 70)];
        imageview1.image=[UIImage imageNamed:@"profile"];
        imageview1.layer.cornerRadius=6.0;
        imageview1.layer.masksToBounds=YES;
        
        UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(102, 20, 120, 30)];
        lblName.text=[[Global userInfo] objectForKey:@"name"];
        lblName.font=[UIFont boldSystemFontOfSize:17];
        
        UILabel *lblHint=[[UILabel alloc]initWithFrame:CGRectMake(102, 50, 180, 30)];
        lblHint.textColor=[UIColor grayColor];
        lblHint.font=[UIFont systemFontOfSize:15];
        //lblHint.text=@"点击查看个人资料";
        lblHint.text=[[Global userInfo] objectForKey:@"org"];
        
        UIImageView *moreImg=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_SIZE.width-18, 42, 9, 16)];
        moreImg.image=[UIImage imageNamed:@"more.png"];
        
        [cell.contentView addSubview:imageview1];
        [cell.contentView addSubview:lblName];
        [cell.contentView addSubview:lblHint];
        //[cell.contentView addSubview:moreImg];
    }else if(indexPath.section==1){
        if (indexPath.row==0) {
            cell.textLabel.text=@"手势密码";
            UILabel *lbl_2=[[UILabel alloc]initWithFrame:CGRectMake(90, 9, 150, 30)];
            lbl_2.text=@"(点击单元格重置密码)";
            lbl_2.font=[UIFont systemFontOfSize:14];
            lbl_2.textColor=[UIColor lightGrayColor];
            [cell.contentView addSubview:lbl_2];
            
            UISwitch *gesSwitch=[[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_SIZE.width-70, 10, 70, 30)];
            
            NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
            NSDictionary *dic=[userDefaults objectForKey:@"touchLock"];
            
            if (dic!=nil&&dic.count>0) {
                NSString *flag=[dic objectForKey:@"isLock"];
                if ([flag isEqualToString:@"YES"]) {
                    gesSwitch.on=YES;
                }
                else
                    gesSwitch.on=NO;
            }
            else
                gesSwitch.on=self.swhOn;
            [gesSwitch addTarget:self action:@selector(gesSwitch:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:gesSwitch];
        }
        else if (indexPath.row==1){
            UILabel *lblIP=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_SIZE.width-130, 9, 150, 30)];
            NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
            NSString *server = [accountDefaults stringForKey:@"server"];
           
            lblIP.text=server;
            lblIP.font=[UIFont systemFontOfSize:14];
            lblIP.textColor=[UIColor lightGrayColor];
            
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_SIZE.width-18, 17, 9, 16)];
            imageView.image=[UIImage imageNamed:@"more.png"];
            cell.textLabel.text=@"IP地址";
            
            [cell.contentView addSubview:lblIP];
            [cell.contentView addSubview:imageView];
        }
//        else if (indexPath.row==2){
//            cell.textLabel.text=@"用户反馈";
//            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_SIZE.width-18, 17, 9, 16)];
//            imageView.image=[UIImage imageNamed:@"more.png"];
//            [cell.contentView addSubview:imageView];
//        }
    }
    else if (indexPath.section==2){
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame=CGRectMake((SCREEN_SIZE.width-100)/2, 10, 100, 30);
        [btn setTitle:@"退出登录" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(exitLogin) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==1){
        return 2;
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
        case 2:
            return 30;
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
    if (indexPath.section==0) {
        //[self.navigationItem setTitle:@"返回"];
        //UserInfoViewController *userInfoVC=[[UserInfoViewController alloc]init];
        //[self.navigationController pushViewController:userInfoVC animated:YES];
    }
    else if (indexPath.section==1) {
        if (indexPath.row==0) {
            GesturesUnLock *lockVC=[[GesturesUnLock alloc]init];
            lockVC.Flag=YES;
            lockVC.reSet=YES;
            lockVC.isHomePage=NO;
            lockVC.btnBack.alpha=1.0;
            [self.navigationController pushViewController:lockVC animated:YES];
        }
        /*else if (indexPath.row==1) {
            //弹出设置IP框
            textAlert=[[UIAlertView alloc]initWithTitle:@"请输入服务器IP地址" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            textAlert.alertViewStyle=UIAlertViewStyleSecureTextInput;
            [textAlert show];
            //[self.infoTableView reloadData];
        }*/
        
    }
    else if (indexPath.section==2) {
        exit(0);
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)gesSwitch:(UISwitch *)sender
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:[userDefaults objectForKey:@"touchLock"]];
    NSLog(@"是否开启手势");
    if (sender.on==YES) {
        if (dic!=nil&&dic.count>0) {
            [dic setObject:@"YES" forKey:@"isLock"];
            [userDefaults setObject:dic forKey:@"touchLock"];
            return;
        }
        else{
            UIAlertView *lockAlert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您尚未设置手势密码，现在开始设置?" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:@"不了", nil];
            [lockAlert show];
        }
    }
    else{
        if (dic!=nil&&dic.count>0) {
            [dic setObject:@"NO" forKey:@"isLock"];
            [userDefaults setObject:dic forKey:@"touchLock"];
            return;
        }
        else
            return;
        //        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
        //        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    }
}

#pragma -mark     UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==textAlert) {
        if (buttonIndex==0) {
            NSLog(@"密码是 :%@",[alertView textFieldAtIndex:0].text);
        }
        else
            NSLog(@"取消");
    }
    else{
        if (buttonIndex==0) {
            GesturesUnLock *lockVC=[[GesturesUnLock alloc]init];
            lockVC.Flag=YES;
            lockVC.isHomePage=NO;
            [self.navigationController pushViewController:lockVC animated:YES];
        }
        else
            return;
    }
}

-(void)exitLogin
{
    NSLog(@"退出登录");
    exit(0);
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
