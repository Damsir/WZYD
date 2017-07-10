//
//  AppDelegate.h
//  HAYD
//
//  Created by 叶松丹 on 16/7/21.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
-(void)changeRootView;

@end

