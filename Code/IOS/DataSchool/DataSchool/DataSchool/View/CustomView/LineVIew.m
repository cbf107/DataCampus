//
//  LineVIew.m
//  ZhiKu
//
//  Created by coreyfu on 15/6/25.
//  Copyright (c) 2015年 darktech. All rights reserved.
//

#import "LineVIew.h"

@implementation LineVIew
- (void)awakeFromNib{
    [super awakeFromNib];
    [self customInit];
}

//- (instancetype)initWithCoder:(NSCoder *)coder
//{
//    self = [super initWithCoder:coder];
//    if (self) {
//        //[self customInit];
//    }
//    return self;
//}
//
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if ((self = [super initWithFrame:frame]) != nil) {
//        //[self customInit];
//    }
//    
//    return self;
//}

- (void)customInit
{
    NSArray *constraints = self.constraints;
    __block NSLayoutConstraint *w;
    __block NSLayoutConstraint *h;
    
    [constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        if (constraint.firstItem == self) {
            if (constraint.firstAttribute == NSLayoutAttributeWidth) {
                w = constraint;
            }else if (constraint.firstAttribute == NSLayoutAttributeHeight){
                h = constraint;
            }
        }
    }];
    
    if (w.constant == 1) {
        w.constant = 0.5;
    }
    if (h.constant == 1) {
        h.constant = 0.5;
    }
    
    self.backgroundColor = [UIColor colorWithHexString:kAppLineColor];
}
@end
