//
//  ContactViewController.h
//  XAYD
//
//  Created by songdan Ye on 16/1/13.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactViewController : UIViewController
@property (nonatomic,strong)UITableView *tableV;
@property (nonatomic,copy) NSArray *contacts;
@property (nonatomic,copy) NSArray *searchContacts;

//搜索框
@property (nonatomic,strong)UITextField *textField;

//部门数
@property (nonatomic,strong)NSString *sectionCount;
@end
