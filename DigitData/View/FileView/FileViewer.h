//
//  FileViewController.h
//  zzzf
//  文件查看浏览的公共组建，提供保存到本地的功能
//  Created by zhangliang on 13-11-22.
//  Copyright (c) 2013年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileDownload.h"
#import "FGalleryPhoto.h"
#import "FGalleryPhotoView.h"
//#import "NSTiffSplitter.h"
//#import "SysWebViewController.h"
#import "SysButton.h"
#import "JSDownloadView.h"

@protocol FileViewerDelegate;

@interface FileViewer : UIView<UIWebViewDelegate,FileDownloadDelegate,UIAlertViewDelegate,FGalleryPhotoDelegate,UIScrollViewDelegate,JSDownloadAnimationDelegate>{
    NSString *_currentOpenFilePath;
    FGalleryPhotoView *_galleryPhotoView;
    FGalleryPhoto *_galleryPhoto;
    NSString *_toSavePath;
    NSString *_toSaveName;
    FileDownload *_currentDownload;
    int _pageIndex;
    NSArray *_files;
    
    CGFloat turnRight;
    
    //tif
//    NSTiffSplitter *splitter;
    NSUInteger currentImage;
    UIImageView *tiffPageView;
    UILabel *pageIndicatorLabel;
    UIBarButtonItem *nextPageButton;
    UIBarButtonItem *previousPageButton;
    SysButton  *_tifpreviousButton;
    SysButton  *_tifnextButton;
    
    CGFloat _downloadRate;
    NSString *_sizeRate;
    NSTimer *_downloadReateTimer;
    NSString *_currentDownlaodPath;

    
    UIDocumentInteractionController *documentController;
}



@property (weak, nonatomic) IBOutlet UIView *topBackGroundView;

@property (nonatomic,strong) NSArray *files;
@property (nonatomic,strong) NSString *isNetwork;
@property (nonatomic,retain) NSString *fileName;
@property (nonatomic,retain) NSString *path;
@property (nonatomic,retain) NSString *ext;
@property (nonatomic,retain) NSString *strType;
@property (nonatomic) int index;

@property (weak, nonatomic) IBOutlet UIScrollView *pagerView;
@property (weak, nonatomic) IBOutlet UIWebView *fileWebView;
@property(nonatomic,retain) IBOutlet UIView *photoScrollView;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *fileWaiting;
@property(nonatomic,retain) IBOutlet UIProgressView *downProgressView;
@property(nonatomic,retain) IBOutlet UILabel *downProgressLabel;
@property (nonatomic, strong) JSDownloadView *downloadView;

-(void)openFileFromLocation:(NSString *)filePath;
-(void)openFileFromNetwork:(NSString *)fileId url:(NSString *)url ext:(NSString *)ext;

-(void)openFiles:(NSArray *)files at:(int)index;
-(void)clear;

+(FileViewer *) createView;
+(void)clearCache;





@property (weak, nonatomic) IBOutlet UIButton *btnClose;
//@property (weak, nonatomic) IBOutlet UIButton *btnRefersh;
@property (weak, nonatomic) IBOutlet UILabel *lblFIleName;
@property (nonatomic,retain) id<FileViewerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *labelForDWG;



@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UIButton *btnDownload;

//Zeng Xu,2015-07-21
@property (weak, nonatomic) NSString *searchKey;
@property (nonatomic) BOOL isContent;

-(void)setDownloadButtonVisible:(BOOL)visible;
-(void)setDeleteButtonVisible:(BOOL)visible;


- (IBAction)onBtnCloseTap:(id)sender;
- (IBAction)onBtnRefershTap:(id)sender;
- (IBAction)onBtnDownload:(id)sender;
- (IBAction)onBtnDelete:(id)sender;

//-(void)openFileFromLocation:(NSString *)fileName filePath:(NSString *)filePath ext:(NSString *)ext;
//-(void)openFileFromNetwork:(NSString *)fileName url:(NSString *)url ext:(NSString *)ext;

-(void)openFileFromLocation:(NSString *)fileName filePath:(NSString *)filePath ext:(NSString *)ext;
-(void)openFileFromNetwork:(NSString *)fileName url:(NSString *)url ext:(NSString *)ext searchKey:(NSString *)sk;



@end

@protocol FileViewerDelegate <NSObject>
-(void)fileViewerDidClosed:(FileViewer *)sender;
-(NSString *)fileViewerShouldToSave:(FileViewer *)sender name:(NSString *)name path:(NSString *)path;
-(void)fileViewerDidDeleted:(FileViewer *)sender name:(NSString *)name path:(NSString *)path;
-(void)FileViewerDidSaved:(FileViewer *)sender name:(NSString *)name path:(NSString *)path;

@end
