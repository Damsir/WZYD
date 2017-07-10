//
//  FIleDownload.h
//  CP
//
//  Created by zhangliang on 13-9-25.
//  Copyright (c) 2013年 zhangliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FileDownloadDelegate;


@interface FileDownload : NSObject<NSURLConnectionDelegate>{
    NSString *savePath;
    BOOL downloadFlag;
    NSThread *downThread;
}

@property(nonatomic,assign) id<FileDownloadDelegate> delegate;
@property(nonatomic,retain) NSURLConnection *connection;
@property long currentSize;
@property long long totalSize;
@property NSString *fileId;
@property NSString *downloadUrl;
@property NSString *downloadExt;
@property NSString *tempPath;
@property NSString *docPath;
//
@property(nonatomic,assign) CGFloat currentlySize;
@property(nonatomic,assign) CGFloat totallySize;

//-(void)update:(NSString *)downloadUrl fileId:(NSString *)downFileId fileExt:(NSString *) ext;

-(NSString *)download:(NSString *)downloadUrl fileId:(NSString *)downFileId fileExt:(NSString *) ext;


-(NSString *)savePath;

-(void)exitDownload;

-(void)cancel;
@end


@protocol FileDownloadDelegate <NSObject>

@optional
-(void)download:(FileDownload *)dowanlod onFileStartDownload:(NSString *)fileId;

@optional
-(void)download:(FileDownload *)dowanlod onFileDownloaded:(NSString *)fileId filePath:(NSString *)filePath;

@optional
-(void)download:(FileDownload *)dowanlod onFileDownloadFaild:(NSString *)fileId;

@optional
-(void)download:(FileDownload *)dowanlod updateProgress:(NSString *)fileId progress:(float)progressValue sizeRate:(NSString *)sizeRate;;



@end