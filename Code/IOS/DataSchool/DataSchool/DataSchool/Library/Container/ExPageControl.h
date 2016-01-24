
//  ExPageControl.h
//
//
//  Created by coreyfu on 12-8-20.
//  Copyright (c) 2012年 starcpt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
	PageControlTypeOnFullOffFull		= 0,
	
    PageControlTypeOnFullOffEmpty		= 1,
	
    PageControlTypeOnEmptyOffFull		= 2,
	
    PageControlTypeOnEmptyOffEmpty	    = 3,
}
PageControlType ;

@interface ExPageControl : UIControl
{
    NSInteger numberOfPages ;
	
    NSInteger currentPage ;

}

// Replicate UIPageControl features
@property(nonatomic) NSInteger numberOfPages ;

@property(nonatomic) NSInteger currentPage ;

@property(nonatomic) BOOL hidesForSinglePage ;

@property(nonatomic) BOOL defersCurrentPageDisplay ;

- (void)updateCurrentPageDisplay ;

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount ;

/*
 ExPageControl add-ons - all these parameters are optional
 Not using any of these parameters produce a page control identical to Apple's UIPage control
 */
- (id)initWithType:(PageControlType)theType ;

@property (nonatomic) PageControlType type ;

@property (nonatomic,strong) UIColor *onColor ;

@property (nonatomic,strong) UIColor *offColor ;

@property (nonatomic,strong) UIColor *textColor ;

@property (nonatomic) CGFloat indicatorDiameter ;

@property (nonatomic) CGFloat indicatorSpace ;

//Ex
@property(nonatomic) BOOL drawPageNumber;

@end
