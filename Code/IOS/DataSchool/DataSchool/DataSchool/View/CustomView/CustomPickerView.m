//
//  CustomPickerView.m
//  MarketEleven
//
//  Created by Bergren Lam on 12/22/14.
//  Copyright (c) 2014 Meinekechina. All rights reserved.
//

#import "CustomPickerView.h"

@interface CustomPickerView ()

@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@end



@implementation CustomPickerView

- (void)awakeFromNib {
    self.datePicker.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.valueLabel.textColor = [UIColor colorWithHexString:kAppFontColorBlue];
    self.valueLabel.font = [UIFont systemFontOfSize:kAppFontSizeTitle];
    self.valueLabel.text = nil;
    self.valueLabel.hidden = NO;
    
    [self.okBtn setBackgroundColor:[UIColor colorWithHexString:AppColorNormalBkg]];
    self.okBtn.titleLabel.font = [UIFont systemFontOfSize:kAppFontSizeSubtitle];
    [self.okBtn setTitleColor:[UIColor colorWithHexString:kAppFontColorDark] forState:UIControlStateNormal];
    
    
    [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
    
}


+ (CustomPickerView *)show {
    
    CustomPickerView *picker = Nib_Object(@"CustomPickerView");

    UIWindow *window = KEY_WINDOW;
    picker.frame = window.bounds;
    
    [window addSubview:picker];

    [picker.contentView resetHeightConstraint:260];
    [picker resetBottomConstraint:-260];
    [picker layoutIfNeeded];

    [picker resetBottomConstraint:0];
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    f.dateFormat = @"yyyy-MM-dd hh:mm";
    //picker.currentValue = [f stringFromDate:[NSData data]];
    
    [picker setCurrentValue:[f stringFromDate:[NSDate date]]];
    
    [UIView animateWithDuration:0.2 animations:^{
        [picker layoutIfNeeded];
    }];
    
    return picker;
}

- (void)setCurrentValue:(id)value{
    _currentValue = value;
    self.valueLabel.text = value;
}

-(void)resetBottomConstraint:(CGFloat)bottom {
    NSArray *constraints = self.constraints;
    for (NSLayoutConstraint *constraint in constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeBottom) {
            constraint.constant = bottom;
            break;
        }
    }
}

-(void)dismiss{
    [self resetBottomConstraint:-286];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutIfNeeded];
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.onCacelBlock) {
            self.onCacelBlock(self.currentValue);
        }
    }];
}

-(void)dateChanged:(id)sender{
    UIDatePicker *control = (UIDatePicker*)sender;
    NSDate *date = control.date;
    /*添加你自己响应代码*/
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    f.dateFormat = @"yyyy-MM-dd hh:mm";
    self.currentValue = [f stringFromDate:date];
    
    [self.valueLabel setText:self.currentValue];
}

- (IBAction)onOkButton:(id)sender {
    
    
    if (self.currentValue && self.onOkBlock) {
        self.onOkBlock(self.currentValue);
    }
    
    [self dismiss];
}

- (IBAction)onTap:(id)sender {
    [self dismiss];
}

@end
