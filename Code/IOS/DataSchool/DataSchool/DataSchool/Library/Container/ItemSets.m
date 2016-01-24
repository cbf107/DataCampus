//
//  ItemSets.m
//
//
//  Created by coreyfu on 13-4-14.
//  Copyright (c) 2013年 starcpt. All rights reserved.
//

#import "ItemSets.h"

@interface ItemView ()
@property (nonatomic,strong) UIButton *buttonIcon;
@property (nonatomic,strong) UILabel *labelName;
@property (nonatomic,strong) UIButton *backgroundView;
@property (nonatomic,assign) NSInteger iconBackgroundOffset;
@end
@implementation ItemView

- (void)awakeFromNib
{
    [self commonInit];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInit];
    }
    return self;
}

- (void)setIdentify:(NSString *)identify
{
    _identify = identify;
    [_buttonIcon setTitle:_identify forState:UIControlStateNormal];
}

- (void)setIconImage:(UIImage *)image
{
    [_buttonIcon setImage:image forState:UIControlStateNormal];

}

- (void)setIconHighlightedImage:(UIImage *)image
{
    [_buttonIcon setImage:image forState:UIControlStateHighlighted];
}

- (void)setIconBackgroundImage:(UIImage *)image
{
    [_buttonIcon setImageEdgeInsets:UIEdgeInsetsMake(_iconBackgroundOffset, _iconBackgroundOffset, _iconBackgroundOffset, _iconBackgroundOffset)];
    
    [_buttonIcon setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)setIconBackgroundHighlightedImage:(UIImage *)image
{
    [_buttonIcon setImageEdgeInsets:UIEdgeInsetsMake(_iconBackgroundOffset, _iconBackgroundOffset, _iconBackgroundOffset, _iconBackgroundOffset)];
    
    [_buttonIcon setBackgroundImage:image forState:UIControlStateHighlighted];
}

- (void)setBackgroundImage:(UIImage *)image
{
    [_backgroundView setImage:image forState:UIControlStateNormal];
}

- (void)setName:(NSString *)n
{
    _name = n;
    [_labelName setText:n];
    
    NSInteger btnAndNameSpace = 5;
    CGSize s = [_labelName contentSizeFixWithSize:CGSizeMake(CGRectGetWidth(self.frame), 10000)];
    
    [_labelName setFrame:CGRectMake(0, CGRectGetMaxY(_buttonIcon.frame) + btnAndNameSpace, CGRectGetWidth(self.frame), s.height)];
//    [self setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(_buttonIcon.frame) + _iconOffset.top + _iconOffset.bottom + btnAndNameSpace + s.height)];
}

- (void)setIconOffset:(UIEdgeInsets)offset
{
    _iconOffset = offset;
    CGFloat btnWidth = self.frame.size.width - _iconOffset.left - _iconOffset.right;
    [_buttonIcon setFrame:CGRectMake(_iconOffset.left, _iconOffset.top, btnWidth, btnWidth)];

}

- (void)commonInit
{
    //_iconOffset = UIEdgeInsetsMake(5, 5, 5, 5);
    //_iconBackgroundOffset = 5;
    //_identify = nil;
    //_name = nil;
    
    self.layer.borderWidth = 0.5;
    //self.layer.borderColor = [UIColor appEdgeLineColor].CGColor;
    
    UIButton *background = [UIButton buttonWithType:UIButtonTypeCustom];
    [background setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    [background setBackgroundColor:[UIColor whiteColor]];
    [background setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [background addTarget:self action:@selector(iconClicked:) forControlEvents:UIControlEventTouchUpInside];
    [background addTarget:self action:@selector(highlightColor:) forControlEvents:UIControlEventTouchDown];
    [background addTarget:self action:@selector(resetColor:) forControlEvents:UIControlEventTouchDragOutside | UIControlEventTouchCancel];
    _backgroundView = background;
    [self addSubview:background];
    
    UIButton *icon = [UIButton buttonWithType:UIButtonTypeCustom];
    [icon setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [icon setTitleColor:[UIColor clearColor] forState:UIControlStateHighlighted];
    icon.adjustsImageWhenHighlighted = NO;
//    [icon addTarget:self action:@selector(iconClicked:) forControlEvents:UIControlEventTouchUpInside];
    icon.userInteractionEnabled = NO;
    
    _buttonIcon = icon;
    [self addSubview:icon];
    
    [self setIconOffset:_iconOffset];
    
    UILabel *lbName = [[UILabel alloc] initWithFrame:CGRectZero];
    [lbName setBackgroundColor:[UIColor clearColor]];
    [lbName setTextAlignment:NSTextAlignmentCenter];
    [lbName setText:nil];
    [lbName setFont:[UIFont systemFontOfSize:12]];
    //[lbName setTextColor:[UIColor appFontColorDark]];
    [self addSubview:lbName];
    
    _labelName = lbName;
    [self setName:nil];
}

- (void)iconClicked:(id)sender
{
    if (self.clickedHandler) {
        self.clickedHandler(self.identify);
    }
    [self resetColor:nil];
}

- (void)resetColor:(id)sender
{
    [_backgroundView setBackgroundColor:[UIColor whiteColor]];
}

- (void)highlightColor:(id)sender
{
    //[_backgroundView setBackgroundColor:[UIColor appEdgeLineColor]];
}

@end


@implementation ScrollImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setImageUseObject:(id)object placeholder:(UIImage *)image
{
    if ([object isKindOfClass:[UIImage class]]) {
        [self setImage:(UIImage *)object];
    }else if ([object isKindOfClass:[NSString class]] ||
              [object isKindOfClass:[NSURL class]]){
        
        [self setImage:image];
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] init];
        activityIndicator.center = (CGPoint){self.frame.size.width * 0.5, self.frame.size.height * 0.5};
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self addSubview:activityIndicator];
        [activityIndicator startAnimating];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            NSString *urlString = [object isKindOfClass:[NSString class]]?object:[(NSURL *)object absoluteString];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
            UIImage *netImage = [UIImage imageWithData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [activityIndicator stopAnimating];
                [activityIndicator removeFromSuperview];
                
                if (netImage) {
                    [UIView transitionWithView:self.superview
                                      duration:0.35
                                       options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowUserInteraction
                                    animations:^{
                                        self.image = netImage;
                                    } completion:nil];
                }
            });
        });
    }else{
        [self setImage:image];
    }
}

@end