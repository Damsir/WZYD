//
//  FileViewController.h
//  iBusiness
//
//  Created by zhangliang on 15/5/5.
//  Copyright (c) 2015年 sh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileViewer.h"

@interface FileViewController : UIViewController<FileViewerDelegate>

@property (nonatomic,strong)UINavigationController *nav;
-(void)openFile:(NSString *)fileId url:(NSString *)url ext:(NSString *)ext;
@property (nonatomic,strong)FileViewer *fileViewer;

@property (nonatomic,strong) id<FileViewerDelegate> fileViewDelegate;


@end
