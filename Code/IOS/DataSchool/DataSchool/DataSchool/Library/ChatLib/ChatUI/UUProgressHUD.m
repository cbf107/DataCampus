//
//  UUProgressHUD.m
//  1111
//
//  Created by shake on 14-8-6.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUProgressHUD.h"

@interface UUProgressHUD ()
{
    UIImageView *animationImageView;
    UIImageView *voiceImageView;

}
@property (nonatomic, strong, readonly) UIWindow *overlayWindow;

@end

@implementation UUProgressHUD

@synthesize overlayWindow;

+ (UUProgressHUD*)sharedView {
    static dispatch_once_t once;
    static UUProgressHUD *sharedView;
    dispatch_once(&once, ^ {
        sharedView = [[UUProgressHUD alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        sharedView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    });
    return sharedView;
}

+ (void)show {
    [[UUProgressHUD sharedView] show];
}

- (void)show {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(!self.superview)
            [self.overlayWindow addSubview:self];
        
        if (!self.titleLabel){
            self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 20)];
            self.titleLabel.backgroundColor = [UIColor clearColor];
        }
        
        CGFloat w = [[UIScreen mainScreen] bounds].size.width;
        CGFloat h = [[UIScreen mainScreen] bounds].size.height;

        if (!voiceImageView){
            voiceImageView = [[UIImageView alloc] initWithFrame:CGRectMake((w - 100) * 0.5, (h - 100) * 0.5, 62, 100)];
            voiceImageView.image = PNGIMAGE(@"RecordingBkg");
            
        }
        if (!animationImageView){
            animationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(voiceImageView.right, voiceImageView.y, 38, 100)];
            animationImageView.animationDuration = 0.8;
            
            NSMutableArray *images = [[NSMutableArray alloc] init];
            for (NSInteger i = 1; i < 9; i++) {
                NSString *name = [NSString stringWithFormat:@"RecordingSignal00%@",@(i)];
                [images addObject:PNGIMAGE(name)];
            }
            
            animationImageView.animationImages = images;
        }
        
        self.titleLabel.center = CGPointMake(w * 0.5,voiceImageView.bottom);
        self.titleLabel.text = @"手指上滑，取消录音";
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.titleLabel.textColor = [UIColor whiteColor];
        
        
        [self addSubview:voiceImageView];
        [self addSubview:animationImageView];
        [self addSubview:self.titleLabel];

        
        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.alpha = 1;
                             [self startAnimation];
                         }
                         completion:^(BOOL finished){
                         }];
        [self setNeedsDisplay];
    });
}

-(void) startAnimation
{
    [animationImageView startAnimating];
}

+ (void)changeTitle:(NSString *)str
{
    [[UUProgressHUD sharedView] setState:str];
}

- (void)setState:(NSString *)str
{
    self.titleLabel.text = str;
}

+ (void)dismissWithSuccess:(NSString *)str {
	[[UUProgressHUD sharedView] dismiss:str];
}

+ (void)dismissWithError:(NSString *)str {
	[[UUProgressHUD sharedView] dismiss:str];
}

- (void)dismiss:(NSString *)state {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.titleLabel.text = nil;
        
        [animationImageView stopAnimating];
        
        [UIView animateWithDuration:0.6
                              delay:0
                            options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             self.alpha = 0;
                         }
                         completion:^(BOOL finished){
                             if(self.alpha == 0) {
                                 [voiceImageView removeFromSuperview];
                                 voiceImageView = nil;
                                 
                                 [animationImageView removeFromSuperview];
                                 animationImageView = nil;
                                 
                                 [self.titleLabel removeFromSuperview];
                                 self.titleLabel = nil;

                                 NSMutableArray *windows = [[NSMutableArray alloc] initWithArray:[UIApplication sharedApplication].windows];
                                 [windows removeObject:overlayWindow];
                                 overlayWindow = nil;
                                 
                                 [windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow *window, NSUInteger idx, BOOL *stop) {
                                     if([window isKindOfClass:[UIWindow class]] && window.windowLevel == UIWindowLevelNormal) {
                                         [window makeKeyWindow];
                                         *stop = YES;
                                     }
                                 }];
                             }
                         }];
    });
}

- (UIWindow *)overlayWindow {
    if(!overlayWindow) {
        overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlayWindow.userInteractionEnabled = NO;
        [overlayWindow makeKeyAndVisible];
    }
    
    return overlayWindow;
}


@end
