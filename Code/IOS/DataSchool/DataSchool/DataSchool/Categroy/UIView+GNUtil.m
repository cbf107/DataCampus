//
//  UIView+GNHelper.m
//  citytime
//
//  Created by mac on 14-3-10.
//  Copyright (c) 2014年 wonler. All rights reserved.
//

#import "UIView+GNUtil.h"

@implementation UIView (GNUtil)


+ (void)dumpView:(UIView *)aView atIndent:(int)indent into:(NSMutableString *)outstring
{
    for (int i = 0; i < indent; i++) [outstring appendString:@"----"];
    [outstring appendFormat:@"[%2d] %@\n", indent, [[aView class] description]];
    for (UIView *view in [aView subviews])
        [self dumpView:view atIndent:indent + 1 into:outstring];
}

// Start the tree recursion at level 0 with the root view
+ (NSString *) displayViews: (UIView *) aView
{
    NSMutableString *outstring = [[NSMutableString alloc] init];
    [self dumpView: aView atIndent:0 into:outstring];
    return outstring ;
}



-(void)setX:(CGFloat)x {
    CGRect r = self.frame;
    r.origin.x = x;
    self.frame = r;
}
-(void)setY:(CGFloat)y {
    CGRect r = self.frame;
    r.origin.y = y;
    self.frame = r;
}
-(void)setWidth:(CGFloat)width {
    CGRect r = self.frame;
    r.size.width = width;
    self.frame = r;
}
-(void)setHeight:(CGFloat)height {
    CGRect r = self.frame;
    r.size.height = height;
    self.frame = r;
}

-(CGFloat)right {
    return self.x + self.width;
}

-(CGFloat)bottom {
    return self.y + self.height;
}

-(CGFloat)x {
    return self.frame.origin.x;
}
-(CGFloat)y {
    return self.frame.origin.y;
}
-(CGFloat)width {
    return self.frame.size.width;
}
-(CGFloat)height {
    return self.frame.size.height;
}

- (void)replaceConstraint:(NSLayoutAttribute)attribute1 onFirstItem:(id)view1 andConstraint:(NSLayoutAttribute)attribute2 onSecondItem:(id)view2 withConstant:(float)constant
{
    [self.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        if ((constraint.firstItem == view1) && (constraint.firstAttribute == attribute1) &&
            (constraint.secondItem == view2) && (constraint.secondAttribute == attribute2)) {
            constraint.constant = constant;
            *stop = YES;
        }
    }];
}

-(void)resetConstraint:(NSLayoutAttribute)attribute constant:(CGFloat)constant {
    NSArray *constraints = [self constraints];
    for (NSLayoutConstraint *c in constraints) {
        if (c.firstAttribute == attribute && c.firstItem == self) {
            c.constant = constant;
        }
    }
}
-(void)resetHeightConstraint:(CGFloat)height {
    [self resetConstraint:NSLayoutAttributeHeight constant:height];
}
-(void)resetWdithConstraint:(CGFloat)width {
    [self resetConstraint:NSLayoutAttributeWidth constant:width];
}

-(UIViewController*)getParentVC {
    UIViewController *currentVC = nil;
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            currentVC = (UIViewController *)nextResponder;
            break;
        }
    }
    
    return currentVC;
}
@end
