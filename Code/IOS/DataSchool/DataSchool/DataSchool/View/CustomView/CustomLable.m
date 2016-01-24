//
//  CustomLable.m
//  ZhiKu
//
//  Created by coreyfu on 15/6/29.
//  Copyright (c) 2015年 darktech. All rights reserved.
//

#import "CustomLable.h"

#import "CustomLable.h"
#import "UIColor+GNUtil.h"

@implementation RWLabel

- (void)awakeFromNib
{
    [super awakeFromNib];
    NSLog(@"self.preferredMaxLayoutWidth=%f, width=%f",self.preferredMaxLayoutWidth,self.frame.size.width);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.numberOfLines == 0) {
        
        // If this is a multiline label, need to make sure
        // preferredMaxLayoutWidth always matches the frame width
        // (i.e. orientation change can mess this up)
        
        if (self.preferredMaxLayoutWidth != self.frame.size.width) {
            self.preferredMaxLayoutWidth = self.frame.size.width;
            [self setNeedsUpdateConstraints];
        }
    }
}

- (CGSize)intrinsicContentSize
{
    CGSize size = [super intrinsicContentSize];
    
    if (self.numberOfLines == 0) {
        
        // There's a bug where intrinsic content size
        // may be 1 point too short
        
        size.height += 1;
    }
    
    return size;
}

@end


@implementation BaseLabel

- (void)customInit {
    
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]) != nil) {
        [self customInit];
    }
    
    return self;
}

@end


@implementation DarkGrayRemarkLabel

- (void)customInit {
    self.textColor = [UIColor colorWithHexString:kAppFontColorDark];
}
@end

@implementation LightGrayRemarkLabel

- (void)customInit {
    self.textColor = [UIColor colorWithHexString:kAppFontColorLight];
    //self.font = [UIFont systemFontOfSize:kAppFontSizeRemark];
}
@end

@implementation GrayRemarkLabel

- (void)customInit {
    //self.textColor = [UIColor appFontColor];
    //self.font = [UIFont systemFontOfSize:kAppFontSizeRemark];
}
@end


@implementation DarkGrayContentLabel

- (void)customInit {
    self.textColor = [UIColor colorWithHexString:kAppFontColorDark];
    self.font = [UIFont systemFontOfSize:kAppFontSizeContent];
}
@end

@implementation GrayContentLabel

- (void)customInit {
    self.textColor = [UIColor colorWithHexString:kAppFontColor];
    self.font = [UIFont systemFontOfSize:kAppFontSizeContent];
}
@end

@implementation LightGrayContentLabel

- (void)customInit {
    //self.textColor = [UIColor appFontColorLight];
    //self.font = [UIFont systemFontOfSize:kAppFontSizeContent];
}
@end



@implementation MineRowLabel

- (void)customInit {
    self.textColor = [UIColor colorWithHexString:kAppFontColorDark];
    self.font = [UIFont systemFontOfSize:kAppFontSizeSubtitle];
}
@end

@implementation RedFontLabel

- (void)customInit {
    self.textColor = [UIColor colorWithHexString:kAppFontColorRed];
}
@end