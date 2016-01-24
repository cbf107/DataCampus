//
//  HomeMetroButton.h
//  WanDa
//
//  Created by coreyfu on 15/7/17.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeMetroButton : UIButton
@property (retain, nonatomic) UIImageView *mTipImageView;


- (void) setCustomImage:(UIImage *) img tipImage:(UIImage *) tipImg;
@end
