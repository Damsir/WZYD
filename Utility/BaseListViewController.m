//
//  BaseListViewController.m
//  iDocument
//
//  Created by zhangliang on 15/5/10.
//  Copyright (c) 2015年 dist. All rights reserved.
//

#import "BaseListViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "Global.h"
#import "DejalActivityView.h"
#import "FileViewController.h"

@interface BaseListViewController ()

@end

@implementation BaseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)openZw:(NSString *)projectId{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *parameters = @{@"user":[Global myuserId],@"type":@"smartplan",@"action":@"materials",@"project":projectId};
    
    NSLog(@"%@?user=%@&type=smartplan&action=materials&project=%@",[Global serverAddress],[Global myuserId],projectId);
//    [DejalBezelActivityView activityViewForView:self.view withLabel:@"加载数据2"];
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"加载数据"];

    [manager POST:[Global serverAddress] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rs = (NSDictionary *)responseObject;
        [DejalBezelActivityView removeViewAnimated:YES];
        if ([[rs objectForKey:@"success"] isEqualToString:@"true"]) {
            NSArray *files = [rs objectForKey:@"result"];
            [self showZw:files];
        }else{
            [self showNoFileMsg];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [DejalBezelActivityView removeViewAnimated:YES];
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"数据访问失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }];
}

-(void)showNoFileMsg{
    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"没有正文" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
}

-(void)showZw:(NSArray *)fs{
    NSDictionary *firstFile = nil;
    for (int i=0; i<fs.count; i++) {
        NSArray *files = [[fs objectAtIndex:i] objectForKey:@"files"];
        if (files.count>0) {
            firstFile = [files objectAtIndex:0];
            break;
        }
    }
    if (nil==firstFile) {
        [self showNoFileMsg];
    }else{
        FileViewController *fvc = [[FileViewController alloc] init];
        NSString *fileId = [NSString stringWithFormat:@"%@_%@",[firstFile objectForKey:@"identity"],[firstFile objectForKey:@"identity"]];
        NSString *downloadUrl = [NSString stringWithFormat:@"%@?type=smartplan&action=downloadmaterial&fileId=%@",[Global serverAddress],[firstFile objectForKey:@"identity"]];
        [fvc openFile:fileId url:downloadUrl ext:[firstFile objectForKey:@"ext"]];
        [self.navigationController pushViewController:fvc animated:YES];
    }
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
