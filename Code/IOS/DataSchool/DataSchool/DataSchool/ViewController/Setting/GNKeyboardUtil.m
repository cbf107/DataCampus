//
//  GNKeyboardUtil.m
//  MarketEleven
//
//  Created by Bergren Lam on 8/26/14.
//  Copyright (c) 2014 Meinekechina. All rights reserved.
//

#import "GNKeyboardUtil.h"

@interface GNKeyboardUtil ()

@property(nonatomic, strong)UIView *adjustView;


@end

static GNKeyboardUtil *_shareInstance;

@implementation GNKeyboardUtil

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}


+(GNKeyboardUtil *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[self alloc] init];
    });
    
    return _shareInstance;
}



+(void)addKeyboardObserverForAdjustView:(UIView *)adjustView {
    [[NSNotificationCenter defaultCenter] addObserver:[self shareInstance] selector:@selector(keyboardFrameChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    _shareInstance.adjustView = adjustView;
}




-(void)keyboardFrameChanged:(NSNotification *)noti {
    NSDictionary *userInfo = noti.userInfo;
    
    CGRect endFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    
    if (self.adjustView && self.adjustView.superview) {
        CGPoint p = [self.adjustView.superview convertPoint:endFrame.origin fromView:KEY_WINDOW];
        CGFloat newHeight = p.y - self.adjustView.frame.origin.y;
        CGRect r = self.adjustView.frame;
        r.size.height = newHeight;
        
        self.adjustView.superview.backgroundColor = self.adjustView.backgroundColor;
        self.adjustView.frame = r;
    }else {
        return;
    }
    
}

+(void)removeKeyboradObserver {
    _shareInstance.adjustView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:[self shareInstance]];
}

@end
