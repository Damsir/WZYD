//
//  LoginViewController.h
//  WZYD
//
//  Created by 吴定如 on 16/12/2.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>

@interface LoginViewController : UIViewController <UIAlertViewDelegate,NSURLConnectionDelegate>


@property (weak, nonatomic) IBOutlet UIView *loginBackView; /**< 登录背景 */
@property (weak, nonatomic) IBOutlet UITextField *userName; /**< 用户名 */
@property (weak, nonatomic) IBOutlet UITextField *passWord; /**< 密码 */
@property (weak, nonatomic) IBOutlet UIButton *rememberButton; /**< 记住密码 */
@property (weak, nonatomic) IBOutlet UIButton *autoLoginButton; /**< 自动登录 */
@property (weak, nonatomic) IBOutlet UIButton *loginButton; /**< 登录按钮 */


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginBackView_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginBackView_left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginBackView_right;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginBackViewHight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userIcon_left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passWordIcon_left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userLine_left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userLine_right;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passWordLine_left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passWordLine_right;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remenberButton_left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *autoLoginLabel_right;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginButton_left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginButton_right;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginButton_bottom;



@end
