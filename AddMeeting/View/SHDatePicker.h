//
//  SHDatePicker.h
//  distmeeting
//
//  Created by songdan Ye on 15/11/2.
//  Copyright (c) 2015年 dist. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickerDelegate;
@class SHDatePicker;

//Button for save
@interface MGPickerButton : UIButton

@end


//Scroll view
@interface MGPickerScrollView : UITableView

@property NSInteger tagLastSelected;

- (void)dehighlightLastCell;
- (void)highlightCellWithIndexPathRow:(NSUInteger)indexPathRow;


@end


@protocol DatePickerDelegate <NSObject>
@optional
- (void)datePicker:(SHDatePicker *)datePicker saveDate:(NSString *)date;
- (void)datePickerDidCancel;
@end


@interface SHDatePicker : UIView<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) NSDate *selectedD;


@property (nonatomic, weak) id <DatePickerDelegate>delegate;

@end


