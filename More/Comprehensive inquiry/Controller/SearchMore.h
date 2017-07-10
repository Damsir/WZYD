//
//  SearchMore.h
//  XAYD
//
//  Created by songdan Ye on 16/2/18.
//  Copyright © 2016年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "UIScrollView+touch.h"

@interface SearchMore : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *baScrollView;
@property (weak, nonatomic) IBOutlet UITextField *PN;
@property (weak, nonatomic) IBOutlet UITextField *contact;
@property (weak, nonatomic) IBOutlet UITextField *adress;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chaxunRC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chongzhiLC;
@property (weak, nonatomic) IBOutlet UITextField *num;
@property (weak, nonatomic) IBOutlet UITextField *pState;
@property (weak, nonatomic) IBOutlet UITextField *type;
@property (weak, nonatomic) IBOutlet UIButton *search;

@property (weak, nonatomic) IBOutlet UITextField *pName;
//受理,发证 日期
@property (weak, nonatomic) IBOutlet UITextField *slDate;
@property (weak, nonatomic) IBOutlet UITextField *fzDate;



@property (weak, nonatomic) IBOutlet UIButton *reset;

@property (nonatomic,strong)NSMutableArray *resultArray;
@property (nonatomic,strong)NSArray *PSarray;
@property (nonatomic,strong)NSArray *PSarray1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *resetWidthC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchBWidthC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameHeigtht;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numberHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contactHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adressHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sponsorHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pstateHeight;

- (IBAction)searchBtnClick:(id)sender;
- (IBAction)resetBtnClick:(id)sender;

@end
