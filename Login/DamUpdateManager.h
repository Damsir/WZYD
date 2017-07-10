//
//  DamUpdateManager.h
//  WZYD
//
//  Created by 吴定如 on 16/11/28.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^Picker_CheckUpdatedBlock)(BOOL isNewVersion, NSString *versionAddress);

@interface DamUpdateManager : NSObject

+ (void)compareVersionWithPlist:(Picker_CheckUpdatedBlock)block;

@end
