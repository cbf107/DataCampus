//
//  ConfirmOrderBookCell.h
//  MarketEleven
//
//  Created by coreyfu on 14-9-15.
//  Copyright (c) 2014年 Meinekechina. All rights reserved.
//
#import <UIKit/UIKit.h>

#define IS_IOS7 ([[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue] >= 7)


@protocol PopDatePickerViewDelegate <NSObject>
@optional
- (void) doneBarButtonItemClicked:(NSString *)strDate;
- (void) cancelBarButtonItemClicked;

@end


@interface PopDatePickerView : UIView

@property (nonatomic, weak) id <PopDatePickerViewDelegate> delegate;
@property (nonatomic, retain) UIToolbar *toolBar;
@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) NSLocale *locale;
@property (nonatomic, retain) NSString *dateFormatter;
- (void) setDatePickerMode:(UIDatePickerMode)dateMode;
- (void) setDateFormatter:(NSString *)strFormatter;
- (void) setDateLocal:(NSLocale *)local;


@end