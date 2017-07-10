/*
 DSLCalendarMonthSelectorView.h
 
 Copyright (c) 2012 Dative Studios. All rights reserved.
 

 */
#import <UIKit/UIKit.h>


@interface DSLCalendarMonthSelectorView : UIView

@property (nonatomic, weak) IBOutlet UIButton *backButton;
@property (nonatomic, weak) IBOutlet UIButton *forwardButton;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *dayLabels;
@property (weak, nonatomic) IBOutlet UILabel *sun;
@property (weak, nonatomic) IBOutlet UILabel *mon;
@property (weak, nonatomic) IBOutlet UILabel *tues;
@property (weak, nonatomic) IBOutlet UILabel *wed;
@property (weak, nonatomic) IBOutlet UILabel *thur;
@property (weak, nonatomic) IBOutlet UILabel *fri;
@property (weak, nonatomic) IBOutlet UILabel *sat;

// Designated initialiser
+ (id)view;

@end
