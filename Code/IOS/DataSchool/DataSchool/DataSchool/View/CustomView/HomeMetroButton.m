//
//  HomeMetroButton.m
//  WanDa
//
//  Created by coreyfu on 15/7/17.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "HomeMetroButton.h"

@implementation HomeMetroButton{
    CGPoint originalCenter;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
    }
    return self;
}

- (void) setCustomImage:(UIImage *) img tipImage:(UIImage *) tipImg {
    if (img) {
        UIImageView *imgView= [[UIImageView alloc] initWithImage:img];
//        if ((imgView.frame.size.height + 16) > self.frame.size.height) {// 处理居中
//            imgView.frame = CGRectOffset(imgView.frame, (self.frame.size.width - imgView.frame.size.width)/2, (self.frame.size.height - imgView.frame.size.height)/2);
//        } else {
//            if (self.frame.size.width >= self.frame.size.height*2) {
//                imgView.frame = CGRectOffset(imgView.frame, (self.frame.size.width - imgView.frame.size.width)/2, 8);
//            } else {
//                imgView.frame = CGRectOffset(imgView.frame, (self.frame.size.width - imgView.frame.size.width)/2, 19);
//            }
//        }
        
        imgView.frame = CGRectOffset(imgView.frame, (self.frame.size.width - imgView.frame.size.width)/2, (self.frame.size.height - imgView.frame.size.height)/2);
        
        [self addSubview:imgView];
    }
    
    if (tipImg) {
        UIImageView *imgView= [[UIImageView alloc] initWithImage:tipImg];
        
        if ((imgView.frame.size.width + 28) > self.frame.size.width) {
            imgView.frame = CGRectOffset(imgView.frame, (self.frame.size.width-imgView.frame.size.width)/2, self.frame.size.height - imgView.frame.size.height - 7);
        } else {
            imgView.frame = CGRectOffset(imgView.frame, 14, self.frame.size.height - imgView.frame.size.height - 7);
        }
        [self addSubview:imgView];
    }
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self animateDown];
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self animateUp];
//}

- (void)animateDown
{
    originalCenter = self.center;
    [UIView animateWithDuration:0.05 animations:^{
        //self.layer.bounds = CGRectInset(self.layer.bounds, 2, 2);
        self.layer.frame = CGRectInset(self.layer.frame, 2, 2);
    }];
}

- (void)animateUp
{
    self.center = originalCenter;
    [UIView animateWithDuration:0.05 animations:^{
        //self.layer.bounds = CGRectInset(self.layer.bounds, -2, -2);
        self.layer.frame = CGRectInset(self.layer.frame, -2, -2);
    }];
}
@end
