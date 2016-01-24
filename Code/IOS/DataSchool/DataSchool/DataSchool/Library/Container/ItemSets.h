//
//  ItemSets.h
//
//
//  Created by coreyfu on 13-4-14.
//  Copyright (c) 2013年 starcpt. All rights reserved.
//


@interface ItemView : UIView
@property (nonatomic,strong) NSString *identify;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) UIEdgeInsets iconOffset;
@property (nonatomic,strong) UIImage *backgroundImage;
@property (nonatomic,strong) UIImage *iconImage;
@property (nonatomic,strong) UIImage *iconHighlightedImage;
@property (nonatomic,strong) UIImage *iconBackgroundImage;
@property (nonatomic,strong) UIImage *iconBackgroundHighlightedImage;

@property (nonatomic, copy) void (^clickedHandler)(NSString *identify);

@end


@interface ScrollImageView : UIImageView

/*
 set image use image,image URL or image url string
 
 @object :can be UIImage,NSURL or NSString
 */
- (void)setImageUseObject:(id)object placeholder:(UIImage *)image;
@end