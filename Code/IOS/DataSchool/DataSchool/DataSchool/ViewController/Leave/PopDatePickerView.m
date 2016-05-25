//
//  ConfirmOrderBookCell.m
//
//  Created by coreyfu on 14-9-15.
//  Copyright (c) 2014年 Meinekechina. All rights reserved.
//

#import "PopDatePickerView.h"


#define kToolBarHeight 44.0


@implementation PopDatePickerView {
    
    NSDateFormatter *dateFormatter;
    
}


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, kToolBarHeight)];
        
        self.toolBar.backgroundColor = [UIColor clearColor];
        [self addSubview:self.toolBar];
        
        UIBarButtonItem *doneBarBtnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
        
        UIBarButtonItem *cancelBarBtnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)];

        UIBarButtonItem *sepBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        NSArray *aryItesm = [[NSArray alloc] initWithObjects:cancelBarBtnItem,sepBarItem, doneBarBtnItem, nil];
        
        [self.toolBar setItems:aryItesm animated:YES];
        
        
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kToolBarHeight, self.frame.size.width, self.frame.size.height - self.toolBar.frame.origin.y - self.toolBar.frame.size.height)];
        
        self.datePicker.backgroundColor = [UIColor whiteColor];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        [self addSubview:self.datePicker];
        
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
    }
    
    return self;
}


- (void) setDatePickerMode:(UIDatePickerMode)dateMode {
    [self.datePicker setDatePickerMode:dateMode];
}


- (void) setDateFormatter:(NSString *)strFormatter {
    [dateFormatter setDateFormat:strFormatter];
}


- (void) setDateLocal:(NSLocale *)local {
    [self.datePicker setLocale:local];
}


- (void) doneButtonPressed:(id)sender {
    if (self.delegate) {
        NSString *strDate = [dateFormatter stringFromDate:self.datePicker.date];
        [self.delegate doneBarButtonItemClicked:strDate];
    }
    
}

-(void) cancelButtonPressed:(id)sender {
    if (self.delegate) {
        [self.delegate cancelBarButtonItemClicked];
    }

}
@end
