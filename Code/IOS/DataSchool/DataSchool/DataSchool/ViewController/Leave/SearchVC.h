//
//  ConfirmOrderBookCell.h
//  MarketEleven
//
//  Created by coreyfu on 14-9-15.
//  Copyright (c) 2014年 Meinekechina. All rights reserved.
//
#import <UIKit/UIKit.h>
@protocol SearchVCDelegate <NSObject>
- (void) selectData:(NSString *)strData;
@end


@interface SearchVC:UIViewController
@property ( nonatomic , copy ) NSString *mTitle;
@property (nonatomic, weak) id <SearchVCDelegate> delegate;

@end