//
//  BLTopTabView.h
//  MarketEleven
//
//  Created by Bergren Lam on 12/15/14.
//  Copyright (c) 2014 Meinekechina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLTopTabView : UIView

@property (nonatomic, strong)NSArray *titles;


-(void)selectIndex:(NSInteger)index;

@property (nonatomic, copy)void (^changedBlock) (NSInteger tag);

@end
