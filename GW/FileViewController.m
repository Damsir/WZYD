//
//  FileViewController.m
//  iBusiness
//
//  Created by zhangliang on 15/5/5.
//  Copyright (c) 2015年 sh. All rights reserved.
//

#import "FileViewController.h"
#import "Global.h"

@interface FileViewController (){
//    FileViewer *_fileViewer;
    NSString *_fileId;
    NSString *_ext;
    NSString *_url;
}
@end

@implementation FileViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;

    NSMutableDictionary *titleAttr = [NSMutableDictionary dictionary];
    titleAttr[NSForegroundColorAttributeName] = [UIColor blackColor];
    //self.navigationController.navigationBar.titleTextAttributes=titleAttr;
    //设置返回按钮的颜色
    //self.navigationController.navigationBar.tintColor = [UIColor blackColor];

}
- (void)viewDidLoad {
    [super viewDidLoad];

    _fileViewer = [FileViewer createView];
   
    
    _fileViewer.frame = CGRectMake(0, 10, self.view.frame.size.width, self.view.frame.size.height);

    if ([[[UIDevice currentDevice] systemVersion] floatValue]<8.0) {
         _fileViewer.topBackGroundView.hidden = YES;
         _fileViewer.frame = CGRectMake(0, -34, self.view.frame.size.width, self.view.frame.size.height+34);
    }
    
    
    [self.view addSubview:_fileViewer];

    _fileViewer.delegate =self;
    [_fileViewer openFileFromNetwork:_fileId url:_url ext:_ext];
    // Do any additional setup after loading the view from its nib.
}

-(void)openFile:(NSString *)fileId url:(NSString *)url ext:(NSString *)ext
{
    _fileId = fileId;
    _ext = ext;
    _url = url;
}



#pragma mark-FileViewerDelegate代理方法

-(void)fileViewerDidClosed:(FileViewer *)sender{
    // [self.navigationController popViewControllerAnimated:YES];
    
    //    [self dismissViewControllerAnimated:YES completion:nil];
//    [self dismissViewControllerAnimated:NO completion:^{
//        
//    }];
    
    
    
   

    [self dismissViewControllerAnimated:NO completion:^{
        
    }];

}
//
-(void)FileViewerDidSaved:(FileViewer *)sender name:(NSString *)name path:(NSString *)path
{
    
}
-(void)fileViewerDidDeleted:(FileViewer *)sender name:(NSString *)name path:(NSString *)path
{
    
}
//-(NSString *)fileViewerShouldToSave:(FileViewer *)sender name:(NSString *)name path:(NSString *)path
//{
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated{
    [_fileViewer clear];
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
